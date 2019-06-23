import Subsystem
import ControlledSystem
import Modeling
import Init
import Time

class System:
    """This class represents the overall control system that creates the agents
    that are assigned to the subsystems.

    Parameters
    ----------

    Attributes
    ----------
    subsystems : Subsystem objects
        The subsystem control agents
    
    amo_subsys : int
        The total amount of subsystems
    
    """

    contr_sys = None
    contr_sys_typ = Init.contr_sys_typ
    
    def __init__(self):
        self.wkdir = Init.glob_res_path + "\\" + Init.name_wkdir
        self.prep_mod()
        self.prep_wkdir()
        self.amo_subsys = len(Init.sys_id)
        self.subsystems = self.gen_subsys()
        self.sys_time = Time.Time()

        
    #def set_time(self):
    #    Time.Time.set_time()
        
    def prep_wkdir(self):
        import os
        os.mkdir(self.wkdir)
        os.chdir(self.wkdir)

    def gen_subsys(self):
        import os
        subsystems = []
        
        for i in range(self.amo_subsys):
            subsystems.append(Subsystem.Subsystem(i))
            
        for sys in subsystems:
            os.mkdir(self.wkdir + "\\" + sys.name)
            
        return subsystems
    
    def prep_mod(self):
        
        for i,typ in enumerate(Init.model_type):
            if typ == "Modelica": 
                Modeling.ModelicaMod.make_dymola()
                print('Dymola established')
                break
            
    def close_mod(self):
        
        for i,typ in enumerate(Init.model_type):
            if typ == "Modelica": 
                Modeling.ModelicaMod.del_dymola()
                break
            
    def find_times(self):
        """ This method finds the minimum sample rate and the minimum 
        optimization interval of all subsystems """
        
        opt_inter = []
        samp_inter = []
        
        for i,sub in enumerate(self.subsystems):
            opt_inter.append(sub.model.times.opt_time)
            samp_inter.append(sub.model.times.samp_time)
            
        min_opt_inter = min(opt_inter)
        min_samp_inter = min(samp_inter)
        
        return [min_opt_inter, min_samp_inter]
        
    
    @classmethod
    def prep_cont_sys(cls):
        if cls.contr_sys_typ == "PLC":
            cls.contr_sys = ControlledSystem.PLCSys()
        elif cls.contr_sys_typ == "Modelica":
            cls.contr_sys = ControlledSystem.ModelicaSys()
            
    @classmethod
    def close_cont_sys(cls):
        if cls.contr_sys_typ == "PLC":
            cls.contr_sys.close()
        if cls.contr_sys_typ == "Modelica":
            cls.contr_sys.close()
    
    @classmethod
    def read_cont_sys(cls, datapoint):
        return cls.contr_sys.read(datapoint)
    
    @classmethod
    def write_cont_sys(cls, datapoint, value):
        print("datapoint: " + str(datapoint))
        print("value: " + str(value))
        return cls.contr_sys.write(datapoint, value)
    
    @classmethod
    def proceed(cls, cur_time, incr):
        if cls.contr_sys_typ == "Modelica":
            cls.contr_sys.proceed(cur_time, incr)
            
    def broadcast(self, subsystem = None):
        if subsystem is None:
            subsystem = self.subsystems
            
        for i,sub in enumerate(subsystem):
            if sub.ups_neigh is not None:
                self.subsystems[sub.ups_neigh].cost_rec = (
                        sub.cost_send)
                print("Broadcast" + str(sub.cost_send))
            if sub.downs_neigh is not None:
                self.subsystems[sub.downs_neigh].coup_vars_rec = (
                        sub.coup_vars_send)
                print("Broadcast" + str(sub.coup_vars_send))

        
class Bexmoc(System):
    
    def __init__(self):
        super().__init__()
        
    def initialize(self):
        for i,sub in enumerate(self.subsystems):
            if Bexmoc.contr_sys_typ == "Modelica":
                sub.get_inputs()
                

    def execute(self):
        
        for i,sub in enumerate(self.subsystems):
            sub.optimize(interp=True)
            self.broadcast([sub])
        
        for i,sub in enumerate(self.subsystems):
            sub.get_inputs()
            sub.interp(iter_real = "real")
            sub.send_commands()
            
        if Bexmoc.contr_sys_typ == "Modelica":
            cur_time = Time.Time.get_time()
            
            Bexmoc.proceed(cur_time, Time.Time.time_incr)
            tim = Time.Time.set_time()
            print("Time: " + str(tim))
    
    def iterate(self):
        for i,sub in enumerate(self.subsystems):
            
            sub.get_inputs()
            inputs = sub.model.states.inputs[0]
            
            if i == 0:
                print(inputs[0])
                print(sub.model.states.set_points[0])
                if inputs[0] < sub.model.states.set_points[0]:
                    sub.model.states.inputs = [
                            min(inputs[0], 
                                sub.model.states.set_points[0] - 0.5)]
                else:
                    sub.model.states.inputs = [
                            max(inputs[0], 
                                sub.model.states.set_points[0] + 0.5)]
            else:
                sub.model.states.inputs = [inputs[0]]
                    
            sub.inputs = [sub.model.states.set_points[0], 
                          sub.model.states.inputs[0]]
            
            sub.inputs.sort()
            sub.optimize(interp = False)
        
        self.broadcast()
        

        for ino in range(0,4,1):
            for i,sub in enumerate(self.subsystems):
                if i == 0:
                    sub.get_inputs()
                    inputs = sub.model.states.inputs[0]
                    sub.inputs = [inputs[0] - 0.1, 
                                  inputs[0] + 0.1]
                else:
                    if (self.subsystems[0].inputs[0] <
                        self.subsystems[0].model.states.set_points[0]):
                        print(sub.coup_vars_rec[0])
                        sub.inputs = [
                                min(sub.coup_vars_rec[0], 
                                    sub.model.states.set_points[0] - 0.5)]
                    else:
                        print(i)
                        print(sub.coup_vars_rec[0])
                        sub.inputs = [
                                min(sub.coup_vars_rec[1], 
                                    sub.model.states.set_points[0] + 0.5)]
                        
                sub.inputs.sort()
                sub.optimize(interp = False)
        
            self.broadcast()

        
        for i,sub in enumerate(self.subsystems):
            sub.interp(iter_real = "iter")
            sub.send_commands()
            
    def terminate(self):
        Bexmoc.close_cont_sys()
        
 