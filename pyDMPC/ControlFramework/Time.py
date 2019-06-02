# -*- coding: utf-8 -*-
"""
Created on Thu May 30 14:57:50 2019

@author: mba
"""

import Init

class Time:
    
    sys_time = 0
    time_incr = Init.time_incr
    contr_sys_typ = "Modelica"
    
    def __init__(self):
        pass
        
    @classmethod
    def get_time(cls):
        
        import time
            
        if cls.contr_sys_typ != "Modelica":
            cls.sys_time = time.time()
            
        return cls.sys_time
    
    @classmethod
    def set_time(cls, time_incr = None):
        
        if time_incr is None:
            cls.sys_time += cls.time_incr
        else:
            cls.sys_time += time_incr