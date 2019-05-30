# -*- coding: utf-8 -*-
"""
Created on Sun May 26 21:12:29 2019

@author: mba
"""

import Init

class PLCSys:
    

    
    def __init__(self):
        import pyads
        self.plc_typ = pyads.PLCTYPE_REAL
        self.ads_id = Init.ads_id
        self.ads_port = Init.ads_port
        self.plc_typ = pyads.PLCTYPE_REAL
    
    def connect(self):
        import pyads
        self.contr_sys = pyads.Connection(self.ads_id, self.ads_port)
        self.contr_sys.open()
        
    def close(self):
        self.contr_sys.close()
        
    def read(self, datapoint):
        return self.contr_sys.read_by_name(datapoint, self.plc_typ)
       
    def write(self, datapoint, value):
        self.contr_sys.write_by_name(datapoint, value, self.plc_typ) 
    
class ModelicaSys:
    
    def __init__(self):
        self.orig_fmu_path = Init.orig_fmu_path
        self.dest_fmu_path = Init.dest_fmu_path
        self.get_fmu()

    def get_fmu(self):
        
        import shutil
        from pyfmi import load_fmu
        
        shutil.copyfile(self.orig_fmu_path, self.dest_fmu_path)
        self.contr_sys = load_fmu(self.dest_fmu_path)
        self.contr_sys.initialize()

    def read(self, datapoint):
        import numpy as np
        return np.asscalar(self.contr_sys.get(datapoint))

    def write(self, datapoint, value):
        self.contr_sys.set(datapoint, value)

    def proceed(self, cur_time, incr):
        self.contr_sys.do_step(cur_time, incr)