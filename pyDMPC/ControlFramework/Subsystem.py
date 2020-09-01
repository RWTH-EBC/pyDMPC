import Init
import Modeling
import System
import SystemTime
import time

class BaseSubsystem:

    """This class represents the the agents that are assigned to the subsystems.
    The agents can predict the behavior of their subsystems and store the
    current costs, coupling variables and states.

    Parameters
    ----------
    sys_id : int
        The unique identifier of a subsystem as specified in the Init

    Attributes
    ----------
    sys_id : int
        The unique identifier of a subsystem as specified in the Init
    name : string

    model_type : string
        The type of the model that this subsystem uses
    model : Model
        The model object created according to the model type
    ups_neigh : int or None
        The ID of the upstream neighbor if it exists
    downs_neigh : int
        The ID of the downstream neighbor if it exists
    coup_vars_send : list of floats
        A list of the current values of coupling variables that should be sent
    coup_vars_rec : list of floats
        A list of the current values of coupling variables that are received
    cost_send : list of floats
        A list of the current values of cost variables that should be sent
    cost_rec : list of floats
        A list of the current values of cost variables that are received
    command_send : list of floats
        A list of the current values of command variables that should be sent
    command_rec : list of floats
        A list of the current values of cost variablesare received
    cost_fac : list of floats
        The cost factors are essential to select which types of costs should
        be considered and how they should be weighted. The first element in the
        list is the cost related to the control effort. The second is the cost
        that is received from the dowmstream neighbor and the third is the cost
        due to deviations form the set point.
    last_opt : float
        Time when the last optimization was conducted
    last_read : float
        Time when the last measurement was taken
    last_write : float
        Time when the last command was sent
    commands : list of floats
        The possible commands of a subsystem
    inputs : list of floats
        The considered inputs of a subsystem
    fin_command : float
        The final command that results from the optimization
    traj_var : list of strings
        The variable in the subsystem that represents a trajectory that other
        subsystems should follow
    traj_points : list of floats
        Possible values of the trajectory variable considered in advance to
        calculate the cost of deviating from the ideal value
    """

    def __init__(self, sys_id):
        self.sys_id = sys_id
        self.name = Init.name[sys_id]
        self.model_type = Init.model_type[sys_id]
        self.ups_neigh = Init.ups_neigh[sys_id]
        self.downs_neigh = Init.downs_neigh[sys_id]
        self.par_neigh = Init.par_neigh[sys_id]
        self.coup_vars_send = []
        self.coup_vars_rec = []
        self.cost_send = []
        self.cost_rec = []
        self.command_send = []
        self.command_rec = []
        self.cost_fac = Init.cost_fac[sys_id]
        self.last_opt = 0
        self.last_read = 0
        self.last_write = 0
        self.commands = Init.commands[sys_id]
        self.inputs = Init.inputs[sys_id]
        self.fin_command = 0
        self.traj_var = Init.traj_var[sys_id]
        self.traj_points = Init.traj_points[sys_id]


class Subsystem(BaseSubsystem):

    def __init__(self, sys_id):
        super().__init__(sys_id = sys_id)
        self.model = self.prepare_model()

    def prepare_model(self):
        """Prepares the model of a subsystem according to the subsystem's model
        type.

        Parameters
        ----------

        Returns
        ----------
        model : Model
            The created model object
        """

        if self.model_type == "Modelica":
            model = Modeling.ModelicaMod(self.sys_id)
            model.translate()
        elif self.model_type == "Scikit":
            model = Modeling.SciMod(self.sys_id)
            model.load_mod()
        elif self.model_type == "Linear":
            model = Modeling.LinMod(self.sys_id)
        elif self.model_type == "Fuzzy":
            model = Modeling.FuzMod(self.sys_id)

        return model

    def predict(self, inputs, commands):

        if inputs != "external":
            if type(inputs) is not list:
                inputs = [inputs]

        self.model.states.inputs = inputs
        self.model.states.commands = commands
        self.model.predict()

        return self.model.states.outputs

    def optimize(self, interp):

        cur_time = SystemTime.Time.get_time()

        if (cur_time - self.last_opt) >= self.model.times.opt_time or (
                cur_time == 0):
            self.last_opt = cur_time

            self.interp_minimize(interp)

    def interp_minimize(self, interp):

        from scipy import interpolate as it

        opt_costs = []
        opt_outputs =  []
        opt_command = []

        self.model.states.outputs_his = self.get_outputs()
        self.model.states.state_vars = self.get_state_vars()

        if self.model.states.input_variables[0] != "external":
            if self.inputs == []:
                self.get_inputs()
                inputs = self.model.states.inputs[0]
            else:
                inputs = self.inputs
        else:
            if self.inputs == []:
                inputs = [-1.0]
            else:
                inputs = self.inputs


        for inp in inputs:

            outputs = []
            costs = []

            for com in self.commands:
                results = self.predict(inp, com)
                outputs.append(results)
                costs.append(self.calc_cost(com, results[-1][-1]))

            min_ind = costs.index(min(costs))

            opt_costs.append(costs[min_ind])
            temp = outputs[min_ind]
            opt_outputs.append(temp[0][-1])

            if len(self.commands) == 1:
                opt_command.append(self.model.states.set_points)
            else:
                opt_command.append(self.commands[min_ind])

        if self.traj_var != []:
            traj_costs = []
            traj = self.model.get_results(self.traj_var[0])
            set_point = traj[10]
            for pts in self.traj_points:
                traj_costs.append((pts - set_point)**2)


            self.traj_points.insert(self.traj_points[0] - 1.)
            traj_costs.insert(traj_costs[0] * 5)
            self.traj_points.append(self.traj_points[-1] + 1)
            traj_costs.append(traj_costs[-1] * 5)

            self.cost_send = it.interp1d(self.traj_points, traj_costs,
                                       fill_value = (100,100), bounds_error = False)
        else:

            if len(inputs) >= 2:
                if interp:
                    self.cost_send = it.interp1d(inputs, opt_costs,
                                               fill_value = (100,100), bounds_error = False)
                else:
                    self.cost_send = opt_costs

            else:
                self.cost_send = opt_costs[0]

        if len(inputs) >= 2:
            if interp:
                interp_com = []
                self.coup_vars_send = opt_outputs
                for com in opt_command:
                    interp_com.append(com[0])
                self.command_send = it.interp1d(inputs, interp_com,
                                             fill_value = (interp_com[0],interp_com[-1]), bounds_error = False)
            else:
                self.coup_vars_send = opt_outputs
                self.command_send = opt_command

        else:
            self.coup_vars_send = opt_outputs[0]
            self.command_send = opt_command[0]


    def calc_cost(self, command, outputs):
        import scipy.interpolate
        import numpy as np

        cost = self.cost_fac[0] * abs(sum(command))
        i = 0
        if self.cost_rec != [] and self.cost_rec != [[]]:
            for i, c in enumerate(self.cost_rec):
                if type(c) is scipy.interpolate.interpolate.interp1d:
                    cost += self.cost_fac[1+i] * c(outputs)
                    print(c(outputs))
                elif type(c) is list:
                    idx = self.find_nearest(np.asarray(self.inputs), outputs)
                    cost += self.cost_fac[1+i] * c[idx]
                else:
                    cost += self.cost_fac[1+i] * c

        if self.model.states.set_points is not None:
            cost += (self.cost_fac[2+i] * (outputs -
                                 self.model.states.set_points[0])**2)


        return cost
    
    def find_nearest(self, a, a0):
        import numpy as np
        idx = np.abs(a - a0).argmin()
        
        return idx

    def interp(self, iter_real):
        import scipy.interpolate
        import numpy as np

        if iter_real == "iter" and self.coup_vars_rec != []:
            inp = self.coup_vars_rec
        else:
            inp = self.model.states.inputs

        idx = self.find_nearest(np.asarray(self.inputs), inp[0])

        if self.command_send != []:
            if (type(self.command_send) is scipy.interpolate.interpolate.interp1d):
                self.fin_command = self.command_send(inp[0])
            else:
                self.fin_command = self.command_send[idx]

        if self.coup_vars_send != []:
            if type(self.coup_vars_send) is scipy.interpolate.interpolate.interp1d:
                self.fin_coup_vars = self.coup_vars_send(inp[0])
            elif type(self.coup_vars_send) is list:
                self.fin_coup_vars = self.coup_vars_send[idx]
            else:
                self.fin_coup_vars = self.coup_vars_send

        print(f"self.fin_coup_vars: {self.fin_coup_vars}")


    def get_inputs(self):

        inputs = []

        if self.model.states.input_variables is not None:
            for i, nam in enumerate(self.model.states.input_names):
                val  = System.Bexmoc.read_cont_sys(nam) 
                inputs.append(val[0] * self.model.modifs.input_factors[i] + 
                self.model.modifs.input_offsets[i])

        self.model.states.inputs = inputs

    def get_state_vars(self):

        states = []

        if self.model.states.state_var_names is not None:
            for i, nam in enumerate(self.model.states.state_var_names):
                if type(nam) is str:
                    val = System.Bexmoc.read_cont_sys(nam)
                else:
                    val = nam()
                
                states.append(val[0] * self.model.modifs.state_factors[i] + 
                self.model.modifs.state_offsets[i])

        return states

    def get_outputs(self):

        outputs = []

        if self.model.states.state_var_names is not None:
            for i, nam in enumerate(self.model.states.output_names):
                val = System.Bexmoc.read_cont_sys(nam)
                outputs.append(val[0] * self.model.modifs.output_factors[i] + 
                self.model.modifs.output_offsets[i])

        return outputs

    def send_commands(self):

        cur_time = SystemTime.Time.get_time()

        print(f"Difference: {cur_time - self.last_write}")
        print(f"Samp Time: {self.model.times.samp_time}")

        if (cur_time - self.last_write) > self.model.times.samp_time:
            self.last_write = cur_time
            
            if type(self.fin_command) is list:
                com = self.fin_command[0]
            else:
                com = self.fin_command

            if self.model.states.command_names is not None:
                for nam in self.model.states.command_names:
                   System.Bexmoc.write_cont_sys(nam, com)
