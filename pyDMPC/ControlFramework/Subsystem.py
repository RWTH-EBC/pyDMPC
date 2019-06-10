import Init
import Modeling 
import System
import Time

class Subsystem:
    
    """This class represents the the agents that are assigned to the subsystems.
    The agents can predict the behavior of their subsystems and store the 
    current costs, coupling variables and states.

    Parameters
    ----------

    Attributes
    ----------
    subsystems : Subsystem objects
        The subsystem control agents
    
    amo_subsys : int
        The total amount of subsystems
    
    """
    
    def __init__(self, sys_id):
        self.sys_id = sys_id
        print(sys_id)
        self.name = Init.name[sys_id]
        self.model_type = Init.model_type[sys_id]
        self.model = self.prepare_model()
        self.ups_neigh = Init.ups_neigh[sys_id]
        self.downs_neigh = Init.downs_neigh[sys_id]
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
            
    def prepare_model(self):
        if self.model_type == "Modelica":
            model = Modeling.ModelicaMod(self.sys_id)
            model.translate()
        elif self.model_type == "Scikit":
            model = Modeling.SciMod(self.sys_id)
            model.load_mod()
        elif self.model_type == "Linear":
            model = Modeling.LinMod(self.sys_id)
        else:
            model = Modeling.FuzMod(self.sys_id)
        return model
    
    def predict(self, inputs, commands):
        
        state_vars = []
        
        if self.model.states.state_var_names != []:
            for i,nam in enumerate(self.model.states.state_var_names):
                print("State variable names: " + str(nam))
                state_vars.append(System.Bexmoc.read_cont_sys(nam))
        
        if inputs != "external":
            if type(inputs) is not list:
                inputs = [inputs]
        
        self.model.states.inputs = inputs
        #self.model.states.state_vars = state_vars
        self.model.states.commands = commands
        
        self.model.predict() 
        #print("predict: " + str(self.model.states.outputs))
        
        return self.model.states.outputs
    
    def optimize(self):
        
        cur_time = Time.Time.get_time()
        
        if (cur_time - self.last_opt) > self.model.times.opt_time:
            self.last_opt = cur_time
            
            self.interp_minimize()
            
    def interp_minimize(self):
        
        from scipy import interpolate as it
            
        opt_costs = []
        opt_outputs =  []
        opt_command = []
        
        states = self.get_state_vars()
        if states != []:
            self.model.states.state_vars = states[0]
        
        if self.model.states.input_variables[0] != "external":
            if self.inputs == []:
                inputs = self.get_inputs()
                inputs = inputs[0]
            else:
                inputs = self.inputs
        else:
            inputs = [-1.0]
            
           
        for inp in inputs:

            outputs = []
            costs = []
            
            for com in self.commands:
                results = self.predict(inp, [com])
                outputs.append(results)
                costs.append(self.calc_cost(com, results[-1][-1]))
            
            min_ind = costs.index(min(costs))
            print("costs: " + str(costs))
            print("index: " + str(min_ind))
            
            opt_costs.append(costs[min_ind])
            temp = outputs[min_ind]
            opt_outputs.append(temp[0][-1])
            opt_command.append(self.commands[min_ind])
        
        if len(inputs) >= 2:                
            self.cost_send = it.interp1d(inputs, opt_costs, 
                                       fill_value = "extrapolate")
            self.coup_vars_send = it.interp1d(inputs, opt_outputs, 
                                         fill_value = "extrapolate")
            self.command_send = it.interp1d(inputs, opt_command,
                                         fill_value = "extrapolate")
        else:
            self.cost_send = opt_costs[0]
            self.coup_vars_send = opt_outputs[0]
            self.command_send = opt_command[0]
                
    def calc_cost(self, command, outputs):
        import scipy.interpolate
        
        cost = self.cost_fac[0] * command
        
        #print("cost_fac[0]: " + str(self.cost_fac[0]))
        #print("command: " + str(command))
        
        if self.cost_rec != []:
            if type(self.cost_rec) is scipy.interpolate.interpolate.interp1d:
                cost += self.cost_fac[1] * self.cost_rec(outputs)
            else:
                cost += self.cost_fac[1] * self.cost_rec
            
        #print("cost_fac[1]: " + str(self.cost_fac[1]))    
        #print("cost_rec: " + str(self.cost_rec))
        
        if self.model.states.set_points != []:
            cost += (self.cost_fac[2] * (outputs - 
                                 self.model.states.set_points[0])**2)
            
        print("cost: " + str(cost))
        print("outputs: " + str(outputs))
        
        #print("cost_fac[2]: " + str(self.cost_fac[2]))
            
        #print("outputs: " + str(outputs))
        #print("model.states.set_points[0]: " + 
        #     str(self.model.states.set_points[0]))
            
        return cost
    
    def interp(self, iter_real):
        import scipy.interpolate

        if iter_real == "iter":
            inp = self.coup_vars_rec
        else:
            inp = self.model.states.inputs
        
        if self.command_send != []:
            if type(self.command_send) is scipy.interpolate.interpolate.interp1d:
                self.fin_command = self.command_send(inp[0])
            else:
                self.fin_command = self.command_send
                print("Final command: " + str(self.fin_command))
              
        if self.coup_vars_send != []:
            if type(self.coup_vars_send) is scipy.interpolate.interpolate.interp1d:
                self.fin_coup_vars = self.coup_vars_send(inp[0])
            else:
                self.fin_coup_vars = self.coup_vars_send
                
                
    def get_inputs(self):
        
        cur_time = Time.Time.get_time()
        print("Time: " + str(cur_time))
        print("Sample time: " + str(self.model.times.samp_time))
        
        inputs = []
        print("Input variables: "+ str(self.model.states.input_variables))
    
        if self.model.states.input_variables is not None:
            for nam in self.model.states.input_names:
                print("check")
                inputs.append(System.Bexmoc.read_cont_sys(nam))
                print("Inputs" + str(inputs))
        
        return inputs
    
    def get_state_vars(self):
        
        cur_time = Time.Time.get_time()
        
        states = []
        
        if self.model.states.state_var_names is not None:
            for nam in self.model.states.state_var_names:
                states.append(System.Bexmoc.read_cont_sys(nam))
                
        return states
            
    def send_commands(self):
        
        cur_time = Time.Time.get_time()
        
        if (cur_time - self.last_write) > self.model.times.samp_time:
            self.last_write = cur_time
        
            if self.model.states.command_names is not None:
                for nam in self.model.states.command_names:
                   System.Bexmoc.write_cont_sys(nam, self.fin_command) 
        
        
    
