import Init
import time

class Time:
    
    sys_time = 0
    time_incr = Init.time_incr
    contr_sys_typ = Init.contr_sys_typ
    
    def __init__(self):
        pass
        
    @classmethod
    def get_time(cls):
            
        if cls.contr_sys_typ != "Modelica":
            cls.sys_time = time.time()
            
        return cls.sys_time
    
    @classmethod
    def set_time(cls, time_incr = None):
        
        if time_incr is None:
            cls.sys_time += cls.time_incr
        else:
            cls.sys_time += time_incr