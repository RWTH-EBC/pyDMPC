import Init
import numpy as np

class States:
    """This class holds all the states relevant for the models.

    Parameters
    ----------
    sys_id: int
        The unique identifier of a subsystem as specified in the Init

    Attributes
    ----------
    inputs : list of floats
        The inputs into a subsystem model
    input_names : list of strings
        The names of the inputs. These are the identifiers for logging and for
        the Modelica models
    outputs : list of floats
        The outputs of a subsystem model
    model_output_names : list of strings
        The names of the outputs. These are the identifiers for logging and for
        the Modelica models
    set_points : list of floats
        The set points relevant to the subsystem
    set_point_names : list of strings
        The names of the set points. These are the identifiers for logging
    state_vars : list of floats
        The state variables of a subsystem.
    state_var_names : list of strings
        The names of the state variables. These are the identifiers for logging
        and for the Modelica models
    commands : list of floats
    command_names : The names of the commands. These are the identifiers for
        logging and for the Modelica models
    """

    def __init__(self, sys_id):
        self.inputs = []
        self.input_names = Init.input_names[sys_id]
        self.input_variables = Init.input_variables[sys_id]
        self.outputs = []
        self.outputs_his = []
        self.model_output_names = Init.model_output_names[sys_id]
        self.output_names = Init.output_names[sys_id]
        self.set_points = Init.set_points[sys_id]
        self.state_vars = []
        self.state_var_names = Init.state_var_names[sys_id]
        self.model_state_var_names = Init.model_state_var_names[sys_id]
        print("init: " + str(self.state_var_names))
        self.commands = []
        self.command_names = Init.command_names[sys_id]
        self.command_variables = Init.command_variables[sys_id]

class Times:
    """This class holds all the times relevant for the models.

    Parameters
    ----------
    sys_id: int
        The unique identifier of a subsystem as specified in the Init

    Attributes
    ----------
    start : float
        The start time of the model, typically 0
    stop : float
        The stop time of the model, start - stop = prediction horizon
    incr : float
        The increment of the model, only applicable to Modelica models
    opt_time : float
        The interval (referring to the global system time), in which the
        subsystem is optimized
    samp_time : float
        The interval, in which a subsystem communicates with the controlled
        system
    """

    def __init__(self, sys_id):
        self.start = Init.start[sys_id]
        self.stop = Init.stop[sys_id]
        self.incr = Init.incr[sys_id]
        self.opt_time = Init.opt_time[sys_id]
        self.samp_time = Init.samp_time[sys_id]

class Paths:
    """This class holds all the paths relevant for the models.

    Parameters
    ----------
    sys_id: int
        The unique identifier of a subsystem as specified in the Init

    Attributes
    ----------
    lib_paths : string
        The paths where the Modelica libraries are stored
    res_path : string
        The path where the results are to be stored
    dym_path : string
        The path where the files required for the Python-Dymola interface
        are stored (.egg)
    mod_path : string
        The path to the model in the Modelica-specific package structure
    """

    def __init__(self, sys_id):
        self.lib_paths = Init.lib_paths[sys_id]
        self.res_path = Init.res_path[sys_id] + "\\" + Init.name[sys_id]
        self.dym_path = Init.dym_path[sys_id]
        self.mod_path = Init.mod_path[sys_id]

class Modifs:
    """This class holds modifier factors for linear models.

    Parameters
    ----------
    sys_id: int
        The unique identifier of a subsystem as specified in the Init

    Attributes
    ----------
    factors : list of floats
        The modifier factors for the linear model. The first element
        transforms the system input, the second the control input
    """

    def __init__(self, sys_id):
        self.state_factors = Init.state_factors[sys_id]
        self.state_offsets = Init.state_offsets[sys_id]
        self.input_factors = Init.input_factors[sys_id]
        self.input_offsets = Init.input_offsets[sys_id]
        self.output_factors = Init.output_factors[sys_id]
        self.output_offsets = Init.output_offsets[sys_id]
        self.linear_model_factors = Init.linear_model_factors[sys_id]
        self.linear_model_offsets =Init.linear_model_offsets[sys_id]


class Model:

    """The super class for all model classes

    Parameters
    ----------
    sys_id: int
        The unique identifier of a subsystem as specified in the Init

    Attributes
    ----------
    model_type : string
        The type of the model
    states : States
    times : Times
    paths : Paths
    """

    def __init__(self, sys_id):
        self.model_type = Init.model_type[sys_id]
        self.states = States(sys_id)
        self.times = Times(sys_id)
        self.paths = Paths(sys_id)
        self.modifs = Modifs(sys_id)


class ModelicaMod(Model):

    dymola = None
    lib_paths = Init.glob_lib_paths
    dym_path = Init.glob_dym_path

    def __init__(self, sys_id):
        super().__init__(sys_id)

    @classmethod
    def make_dymola(cls):

        import sys
        import os

        if cls.dymola == None:
            # Work-around for the environment variable
            sys.path.insert(0, os.path.join(cls.dym_path))
            # Import Dymola Package
            print(cls.dym_path)
            global dymola
            from dymola.dymola_interface import DymolaInterface
            # Start the interface
            cls.dymola = DymolaInterface()

        for i,path in enumerate(cls.lib_paths):
            print(path)
            check = cls.dymola.openModel(os.path.join(path,'package.mo'))
            print('Opening successful ' + str(check))

    @classmethod
    def del_dymola(cls):
        if cls.dymola is not None:
            cls.dymola.close()
            cls.dymola = None

    def translate(self):
        ModelicaMod.dymola.cd(self.paths.res_path)
        print(self.paths.res_path)
        check = ModelicaMod.dymola.translateModel(self.paths.mod_path)
        print("Translation successful " + str(check))

    def simulate(self):
        ModelicaMod.dymola.cd(self.paths.res_path)
        
        command_variables = [f"decisionVariables.table[{i+1},2]" 
                             for i in range(1)]
        
        time_variables = [f"decisionVariables.table[{i+1},1]"
                          for i in range(1)]
        
        times = [i*600 for i in range(1)]

        if self.states.input_variables[0] == "external":
            initialNames = (self.states.command_variables  +
                            self.states.model_state_var_names + time_variables)
            initialValues = (self.states.commands + self.states.state_vars + times)
        else:
            initialValues = (self.states.commands + self.states.inputs +
                             self.states.state_vars + times)

            initialNames = (command_variables +
                            self.states.input_variables +
                            self.states.model_state_var_names + time_variables)
            print(initialNames)
            print(initialValues)


        for k in range(3):
            try:
                print(ModelicaMod.dymola.simulateExtendedModel(
                    problem=self.paths.mod_path,
                    startTime=self.times.start,
                    stopTime=self.times.stop,
                    outputInterval=self.times.incr,
                    method="Dassl",
                    tolerance=0.001,
                    resultFile= self.paths.res_path + r'\dsres',
                    finalNames = self.states.output_names,
                    initialNames = initialNames,
                    initialValues = initialValues))

                print("Simulation successful")
                break

            except:
                if k < 3:
                    print('Repeating simulation attempt')
                else:
                    print('Final simulation error')

    def get_outputs(self):
        self.states.outputs = []

        if self.states.model_output_names is not None:
            for nam in self.states.model_output_names:
                self.states.outputs.append(self.get_results(nam))

    def get_results(self, name):
        from modelicares import SimRes
        import os
        # Get the simulation result
        sim = SimRes(os.path.join(self.paths.res_path, 'dsres.mat'))

        arr = sim[name].values()
        results = arr.tolist()

        return results

    def predict(self):
        self.simulate()
        self.get_outputs()

class SciMod(Model):
    def __init__(self, sys_id):
        super().__init__(sys_id)

    def load_mod(self):
        from joblib import load
        self.model = load(self.paths.mod_path + r".joblib")
        self.scaler = load(self.paths.mod_path + r"_scaler.joblib")

    def write_inputs(self):
        commands_1 = self.states.commands[0]*np.ones(10)
        commands_2 = self.states.commands[1]*np.ones(50)
        commands = commands_1.tolist() + commands_2.tolist()
        inputs = self.states.inputs[0]*np.ones(60)
        inputs = inputs.tolist()

        inputs = np.stack(([commands] + [inputs]), axis=1)

        self.scal_inputs = self.scaler.transform(inputs)

    def predict(self):
        self.write_inputs()
        self.states.outputs = [self.model.predict(self.scal_inputs)]

class LinMod(Model):

    def __init__(self, sys_id):
        super().__init__(sys_id)
        self.modifs = Modifs(sys_id)

    def predict(self):
        self.states.outputs = [[self.modifs.linear_model_factors[0] * self.states.inputs[0] +
                               self.modifs.linear_model_factors[1] * self.states.commands[0] +
                               self.modifs.linear_model_offsets[0]]]


class FuzMod(Model):

    def __init__(self, sys_id):
        super().__init__(sys_id)

        import skfuzzy.control as ctrl

        # Define the universe
        universe = np.linspace(-5, 5, 5)
        universe_temp = np.linspace(17, 30, 5)
        universe_out = np.linspace(17, 30, 5)

        # Create the three fuzzy variables
        temperature = ctrl.Antecedent(universe_temp, 'temperature')
        delta = ctrl.Antecedent(universe, 'delta')
        output = ctrl.Consequent(universe_out, 'output')

        names = ['nb', 'ns', 'ze', 'ps', 'pb']
        temperature.automf(names=names)
        delta.automf(names=names)
        output.automf(names=names)

        """
        Define complex rules
        --------------------
        """
        rule0 = ctrl.Rule(antecedent=((temperature['nb'] & delta['nb']) |
                                    (temperature['ns'] & delta['nb']) |
                                    (temperature['ze'] & delta['nb']) |
                                    (temperature['nb'] & delta['ns'])),
                        consequent=output['nb'], label='rule nb')

        rule1 = ctrl.Rule(antecedent=((temperature['nb'] & delta['ze']) |
                                    (temperature['ns'] & delta['ns']) |
                                    (temperature['ns'] & delta['ze']) |
                                    (temperature['ze'] & delta['ns']) |
                                    (temperature['ze'] & delta['nb']) 
                                    ),
                        consequent=output['ns'], label='rule ns')

        rule2 = ctrl.Rule(antecedent=((temperature['ze'] & delta['ze']) |
                                    (temperature['ns'] & delta['ze']) |
                                    (temperature['ps'] & delta['ze']) 
                                    ),
                        consequent=output['ze'], label='rule ze')

        rule3 = ctrl.Rule(antecedent=((temperature['ze'] & delta['ps']) |
                                    (temperature['ps'] & delta['ps']) |
                                    (temperature['pb'] & delta['ze']) |
                                    (temperature['ns'] & delta['ps']) 
                                    ),
                        consequent=output['ps'], label='rule ps')

        rule4 = ctrl.Rule(antecedent=((temperature['ps'] & delta['pb']) |
                                    (temperature['pb'] & delta['pb']) |
                                    (temperature['pb'] & delta['ps']) |
                                    (temperature['ze'] & delta['pb']) 
                                    ),
                        consequent=output['pb'], label='rule pb')

        """
        Define a control system
        """
        system = ctrl.ControlSystem(rules=[rule0, rule1, rule2, rule3, rule4])

        self.sim = ctrl.ControlSystemSimulation(system, flush_after_run=1)

    def control(self, temp, delt):
        self.sim.input['temperature'] = temp
        self.sim.input['delta'] = delt
        self.sim.compute()
        return self.sim.output['output']

    def predict(self):
        self.states.outputs = [[self.states.inputs[0]]]
        self.states.set_points = [self.control(self.states.state_vars[0],
                                             self.states.state_vars[1])]
