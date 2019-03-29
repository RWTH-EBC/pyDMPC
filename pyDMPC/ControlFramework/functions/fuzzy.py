def control(temp,delt):
    import numpy as np
    import skfuzzy.control as ctrl

    # Sparse universe makes calculations faster, without sacrifice accuracy.
    # Only the critical points are included here; making it higher resolution is
    # unnecessary.
    universe = np.linspace(-2, 2, 5)
    universe_temp = np.linspace(280, 310, 5)
    universe_out = np.linspace(280, 310, 5)

    # Create the three fuzzy variables - two inputs, one output
    temperature = ctrl.Antecedent(universe_temp, 'temperature')
    delta = ctrl.Antecedent(universe, 'delta')
    output = ctrl.Consequent(universe_out, 'output')

    # Here we use the convenience `automf` to populate the fuzzy variables with
    # terms. The optional kwarg `names=` lets us specify the names of our Terms.
    names = ['nb', 'ns', 'ze', 'ps', 'pb']
    temperature.automf(names=names)
    delta.automf(names=names)
    output.automf(names=names)

    """
    Define complex rules
    --------------------

    This system has a complicated, fully connected set of rules defined below.
    """
    rule0 = ctrl.Rule(antecedent=((temperature['nb'] & delta['nb']) |
                                  (temperature['ns'] & delta['nb']) |
                                  (temperature['nb'] & delta['ns'])),
                      consequent=output['nb'], label='rule nb')

    rule1 = ctrl.Rule(antecedent=((temperature['nb'] & delta['ze']) |
                                  (temperature['nb'] & delta['ps']) |
                                  (temperature['ns'] & delta['ns']) |
                                  (temperature['ns'] & delta['ze']) |
                                  (temperature['ze'] & delta['ns']) |
                                  (temperature['ze'] & delta['nb']) |
                                  (temperature['ps'] & delta['nb'])),
                      consequent=output['ns'], label='rule ns')

    rule2 = ctrl.Rule(antecedent=((temperature['nb'] & delta['pb']) |
                                  (temperature['ns'] & delta['ps']) |
                                  (temperature['ze'] & delta['ze']) |
                                  (temperature['ps'] & delta['ns']) |
                                  (temperature['pb'] & delta['nb'])),
                      consequent=output['ze'], label='rule ze')

    rule3 = ctrl.Rule(antecedent=((temperature['ns'] & delta['pb']) |
                                  (temperature['ze'] & delta['pb']) |
                                  (temperature['ze'] & delta['ps']) |
                                  (temperature['ps'] & delta['ps']) |
                                  (temperature['ps'] & delta['ze']) |
                                  (temperature['pb'] & delta['ze']) |
                                  (temperature['pb'] & delta['ns'])),
                      consequent=output['ps'], label='rule ps')

    rule4 = ctrl.Rule(antecedent=((temperature['ps'] & delta['pb']) |
                                  (temperature['pb'] & delta['pb']) |
                                  (temperature['pb'] & delta['ps'])),
                      consequent=output['pb'], label='rule pb')

    """
    Despite the lengthy ruleset, the new fuzzy control system framework will
    execute in milliseconds. Next we add these rules to a new ``ControlSystem``
    and define a ``ControlSystemSimulation`` to run it.
    """
    system = ctrl.ControlSystem(rules=[rule0, rule1, rule2, rule3, rule4])

    # Later we intend to run this system with a 21*21 set of inputs, so we allow
    # that many plus one unique runs before results are flushed.
    # Subsequent runs would return in 1/8 the time!
    sim = ctrl.ControlSystemSimulation(system, flush_after_run=1)

    sim.input['temperature'] = temp
    sim.input['delta'] = delt
    sim.compute()
    return sim.output['output']
