##################################################################
# Subsystem class that includes all the control agents' abilities
##################################################################

import Init
import Modeling 
import System

class Variation:
    
    def __init__(self, sys_id):
        self.min_var = Init.min_var[sys_id]
        self.max_var = Init.max_var[sys_id]
        self.inc_var = Init.inc_var[sys_id]

class Subsystem:
    
    def __init__(self, sys_id):
        self.sys_id = sys_id
        print(sys_id)
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
        self.vars = Variation(sys_id)
        self.cost_fac = Init.cost_fac[sys_id]
            
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
        
        if self.model.states.state_var_names is not None:
            for i,nam in enumerate(self.model.states.state_var_names):
                state_vars.append(System.System.read_cont_sys(nam))
            
        self.model.states.inputs = inputs
        self.model.states.state_vars = state_vars
        self.model.states.commands = commands
        
        self.model.predict() 
        
        return self.model.states.outputs
    
    def optimize(self):
        from scipy import interpolate as it
        inputs = range(self.vars.min_var, self.vars.max_var, self.vars.inc_var)
        command = range(0,10,5)
        
        opt_costs = []
        opt_outputs =  []
        opt_command = []
           
        for inp in inputs:

            outputs = []
            costs = []
            
            for com in command:
                results = self.predict(inp, com)
                outputs.append(results)
                costs.append(self.calc_cost(results, com, inp))
            
            min_ind = costs.index(min(costs))
            
            opt_costs.append(costs[min_ind])
            opt_outputs.append(outputs[min_ind])
            opt_command.append(command[min_ind])
            
        self.cost_send = it.interp1d(inputs, opt_costs, 
                                   fill_value = "extrapolate")
        self.coup_vars_send = it.interp1d(inputs, opt_outputs, 
                                     fill_value = "extrapolate")
        self.command_send = it.interp1d(inputs, opt_command,
                                     fill_value = "extrapolate")
                
    def calc_cost(self, own_cost, command, outputs):
        cost = self.cost_fac[0] * command
        
        if self.cost_rec != []:
            cost += self.cost_fac[1] * self.cost_rec(outputs)
        
        if self.model.states.set_points is not None:
            cost += (self.cost_fac[2] * (outputs - 
                                 self.model.states.set_points)**2)
            
        return cost
    
    def interp(self):
        self.fin_command = self.command_send(self.coup_vars_rec)
        self.fin_coup_vars = self.coup_vars_send(self.coup_vars_rec)
                
            
        
        
    
