##################################################################
# Subsystem class that includes all the control agents' abilities
##################################################################

import Init
import Modeling 

class Subsystem():
    
    def __init__(self, sys_id):
        self.sys_id = sys_id
        print(sys_id)
        self.model_type = Init.model_type[sys_id]
        self.model = self.prepare_model()
            
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
