##################################################################
# System class that can generate subsystem agents
##################################################################

import Subsystem
import ControlledSystem
import Modeling
import Init

class System:

    contr_sys = None
    contr_sys_typ = Init.contr_sys_typ
    
    def __init__(self):
        self.prep_mod()
        self.amo_subsys = len(Init.sys_id)
        self.subsystems = self.gen_subsys()
        

    def gen_subsys(self):
        subsystems = []
        
        for i in range(self.amo_subsys):
            subsystems.append(Subsystem.Subsystem(i))
            
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
    
    @classmethod
    def read_cont_sys(cls, datapoint):
        return cls.contr_sys.read(datapoint)
    
    @classmethod
    def write_cont_sys(cls, datapoint, value):
        return cls.contr_sys.write(datapoint, value)
    
    @classmethod
    def proceed(cls, cur_time, incr):
        if cls.contr_sys_typ == "Modelica":
            cls.contr_sys.proceed(cur_time, incr)
