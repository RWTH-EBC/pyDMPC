# -*- coding: utf-8 -*-
"""
Created on Sun May 26 21:12:29 2019

@author: mba
"""

import Init

class PLCSys:
    
    import pyads    
    ads_id = Init.ads_id
    ads_port = Init.ads_port
    plc_typ = pyads.PLCTYPE_REAL
    
    def __init__(self):
        import pyads
        self.plc_typ = pyads.PLCTYPE_REAL
    
    @classmethod
    def connect(cls):
        import pyads
        cls.contr_sys = pyads.Connection(cls.ads_id, cls.ads_port)
        cls.contr_sys.open()
        
    @classmethod
    def close(cls):
        cls.contr_sys.close()
        
    @classmethod
    def read(cls, datapoint):
        return cls.contr_sys.read_by_name(datapoint, cls.plc_typ)
    
    @classmethod    
    def write(cls, datapoint, value):
        cls.contr_sys.write_by_name(datapoint, value, cls.plc_typ) 
    
class ModelicaSys:
    
    orig_fmu_path = Init.orig_fmu_path
    dest_fmu_path = Init.dest_fmu_path
    
    def __init__(self):
        pass

    @classmethod
    def get_fmu(cls):
        
        import shutil
        from pyfmi import load_fmu
        
        shutil.copyfile(cls.orig_fmu_path, cls.dest_fmu_path)
        cls.contr_sys = load_fmu(cls.dest_fmu_path)
        cls.contr_sys.initialize()
        
    @classmethod
    def read(cls, datapoint):
        import numpy as np
        return np.asscalar(cls.contr_sys.get(datapoint))
    
    @classmethod
    def write(cls, datapoint, value):
        cls.contr_sys.set(datapoint, value)
        
    @classmethod
    def proceed(cls, cur_time, incr):
        cls.contr_sys.do_step(cur_time, incr)