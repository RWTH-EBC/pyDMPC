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
        from fmpy import read_model_description, extract
        from fmpy.fmi2 import FMU2Slave
        
        shutil.copyfile(self.orig_fmu_path, self.dest_fmu_path)
        
        # read the model description
        self.model_description = read_model_description(self.dest_fmu_path)

        # collect the value references
        self.vrs = {}
        for variable in self.model_description.modelVariables:
            self.vrs[variable.name] = variable.valueReference
        
        print(variable)
            
        # extract the FMU
        self.unzipdir = extract(self.dest_fmu_path)

        self.contr_sys = FMU2Slave(guid=self.model_description.guid,
                unzipDirectory=self.unzipdir,
                modelIdentifier=
                self.model_description.coSimulation.modelIdentifier,
                instanceName='instance1')
        
        print(self.contr_sys)
            
        self.contr_sys.instantiate()
        self.contr_sys.setupExperiment(startTime=0.0)
        self.contr_sys.enterInitializationMode()
        self.contr_sys.exitInitializationMode()

    def read(self, datapoint):
        name = self.vrs[datapoint]
        value = self.contr_sys.getReal([name])
        print(value)
        return value

    def write(self, datapoint, value):
        name = self.vrs[datapoint]
        self.contr_sys.setReal([name], [value])

    def proceed(self, cur_time, incr):
        print("Time: " + str(cur_time))
        print("Increment: " + str(incr))
        self.contr_sys.doStep(currentCommunicationPoint = cur_time, 
                               communicationStepSize = incr)
        
    def close(self):
        import shutil
        self.contr_sys.terminate()
        self.contr_sys.freeInstance()
        shutil.rmtree(self.unzipdir)