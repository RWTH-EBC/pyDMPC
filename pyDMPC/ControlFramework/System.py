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
    
    Class attributes
    ----------
    contr_sys : ControlledSystem
        The controlled system object
    contr_sys_typ : string
        The type of the controlled system

    Attributes
    ----------
    wkdir : string
        The current work directory
    amo_subsys : int
        The total amount of subsystems
    subsystems : Subsystem objects
        The subsystem control agents
    sys_time : float
        The current time of the system
    
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
        
    def prep_wkdir(self):
        """Prepares the working directory for the current experiment
        """
        
        import os
        os.mkdir(self.wkdir)
        os.chdir(self.wkdir)

    def gen_subsys(self):
        """Generates the subsystems/agent.
    
        Parameters
        ----------
    
        Returns
        ----------
        subsystems : list of Subsystem objects
            The created subsystem objects
        """
        import os
        subsystems = []
        
        for i in range(self.amo_subsys):
            subsystems.append(Subsystem.Subsystem(i))
            
        for sys in subsystems:
            os.mkdir(self.wkdir + "\\" + sys.name)
            
        return subsystems
    
    def prep_mod(self):
        """Checks if the model type of any of the subsystems is Modelica and
        in that case establishes the Dymola environment.
        """
        
        for i,typ in enumerate(Init.model_type):
            if typ == "Modelica": 
                Modeling.ModelicaMod.make_dymola()
                print('Dymola established')
                break
            
    def close_mod(self):
        """Checks if the model type of any of the subsystems is Modelica and
        in that case destroys the Dymola environment.
        """
        for i,typ in enumerate(Init.model_type):
            if typ == "Modelica": 
                Modeling.ModelicaMod.del_dymola()
                break
            
    def find_times(self):
        """ This method finds the minimum sample rate and the minimum 
        optimization interval of all subsystems 
        
        Returns
        ----------
        subsystems : list of floats
            The found minimum optimization and sampling times of all subsystems
        """
        
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
        """Creates a controlled system object, which is either a Modelica 
        simulation or a pyads PLC object
        """
        if cls.contr_sys_typ == "PLC":
            cls.contr_sys = ControlledSystem.PLCSys()
        elif cls.contr_sys_typ == "Modelica":
            cls.contr_sys = ControlledSystem.ModelicaSys()
            
    @classmethod
    def close_cont_sys(cls):
        """Terminates the Modelica simulation or closes the connection to the 
        pyads PLC, respectively. 
        """
        if cls.contr_sys_typ == "PLC":
            cls.contr_sys.close()
        if cls.contr_sys_typ == "Modelica":
            cls.contr_sys.close()
    
    @classmethod
    def read_cont_sys(cls, datapoint):
        """ This method reads the value of a certain data point in the 
        controlled system.
        
        Parameters
        ----------
        datapoint : string
            The considered data point identifier
        
        Returns
        ----------
        value : float
            The the value of the data point 
        """
        
        return cls.contr_sys.read(datapoint)
    
    @classmethod
    def write_cont_sys(cls, datapoint, value):
        """ This method writes a value of a certain data point in the 
        controlled system.
        
        Parameters
        ----------
        datapoint : string
            The considered data point identifier

        value : float
            The the value of the data point to be written
        """
        
        print("datapoint: " + str(datapoint))
        print("value: " + str(value))
        cls.contr_sys.write(datapoint, value)
    
    @classmethod
    def proceed(cls, cur_time, incr):
        """ This method makes a step in the controlled system if it is a 
        Modelica simulation
        
        Parameters
        ----------
        cur_time : float
            The ccurrent time
        
        incr : The time increment = step size
        """

        if cls.contr_sys_typ == "Modelica":
            cls.contr_sys.proceed(cur_time, incr)
            
    def broadcast(self, sys_list = None):
        """ This method broadcasts the values of relevant variables among
        neighboring subsystems/agents.

        """
        if sys_list == None:
            sys_list = range(len(self.subsystems))
            
        for i in sys_list:
            if self.subsystems[i].ups_neigh is not None:
                cost = [self.subsystems[i].cost_send]
                if self.subsystems[i].par_neigh is not None:
                    for j in self.subsystems[i].par_neigh:
                        cost.append(self.subsystems[j].cost_send)
                else:
                    j = 0
                
                self.subsystems[self.subsystems[i].ups_neigh].cost_rec = cost
                
            else:
                j = 0                    

            if self.subsystems[i].downs_neigh is not None:
                for k in self.subsystems[i].downs_neigh:
                    print(k)
                    print(self.subsystems[k])
                    self.subsystems[k].coup_vars_rec = self.subsystems[i].coup_vars_send
            
            i += j


        
class Bexmoc(System):
    
    def __init__(self):
        super().__init__()
        
    def initialize(self):
        for i,sub in enumerate(self.subsystems):
            if Bexmoc.contr_sys_typ == "Modelica":
                sub.get_inputs()
                

    def execute(self):
        
        for i in range(len(self.subsystems)):
            self.subsystems[i].optimize(interp=True)
            if self.subsystems[i].par_neigh is not None:
                for j in self.subsystems[i].par_neigh:
                    self.subsystems[j].optimize(interp=True)
                self.broadcast([i] + self.subsystems[i].par_neigh)
            else:
                print(f"Broadcasting: {i}")
                self.broadcast([i])
                    
        
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
        
 