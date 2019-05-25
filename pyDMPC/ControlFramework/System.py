##################################################################
# System class that can generate subsystem agents
##################################################################

import Subsystem as SubSys
import Init

class System:

    def __init__(self):
        self._name = Init.name_system
        self._measurements_IDs = Init.measurements_IDs
        self._amount_consumer = Init.amount_consumer
        self._amount_generator = Init.amount_generator
        self._algorithm = Init.algorithm
        self._obj_function = Init.obj_function


    def GenerateSubSys(self):
        subsystems = []
        num_SubSys = Init.amount_consumer+Init.amount_generator
        for i in range(0,(num_SubSys)):
            if Init.sim_time_global is not None:
                Init.sim_time.insert(0, Init.sim_time_global)
            if Init.init_DecVars_global is not None:
                Init.init_DecVars.insert(0, Init.init_DecVars_global)
            if Init.num_BCs_global is not None:
                Init.num_BCs.insert(0, Init.num_BCs_global)
            if Init.num_VarsOut_global is not None:
                Init.num_VarsOut.insert(0, Init.num_VarsOut_global)
            if Init.bounds_DVs_global is not None:
                Init.bounds_DVs.insert(0, Init.bounds_DVs_global)
            if Init.names_BCs_global is not None:
                Init.names_BCs.insert(0, Init.names_BCs_global)
            if Init.output_vars_global is not None:
                Init.output_vars.insert(0, Init.output_vars_global)
            subsystems.append(SubSys.Subsystem(i))
        subsystems.sort(key = lambda x: x.position)
        for i,subsys in enumerate(subsystems):
            if i != Init.amount_subsystems-1:
                neighbour_name = subsystems[subsys.position+subsys.holon]._name
            else:
                neighbour_name = None
            subsystems[i].GetNeighbour(neighbour_name)
            print("System: " + str(subsystems[i]._name) + ", Neighbor: " + str(neighbour_name))

        return subsystems
