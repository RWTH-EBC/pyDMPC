from sklearn.neural_network import MLPClassifier, MLPRegressor
from sklearn.preprocessing import StandardScaler
import numpy as np
from pyfmi import load_fmu
import random
from joblib import dump, load

def main():

    command = []        # The manipulated variable in the model
    T_cur = []          # The current inflow temperature
    T_prev = []         # The inflow temperature in the previous time step

    """ The metal temperatures in the previous time step"""
    T_met_prev_1 = []
    T_met_prev_2 = []
    T_met_prev_3 = []
    T_met_prev_4 = []

    """ Lists for the training data """
    y_train_1 = []
    y_train_2 = []
    y_train_3 = []
    y_train_4 = []
    y_train_5 = []

    """ Random inflow temperatures for training """
    T = [2]

    for k in range(49):
        T.append(random.uniform(2.0, 45.0))

    T.append(45)

    """ Simulate the FMU to generate the training data """
    sync_rate = 60  # Synchronisation rate of the FMU

    # Load exisiting FMU
    model = load_fmu(r"C:\TEMP\Dymola\ModelicaModels_SubsystemModels_DetailedModels_HumidifierML.fmu")

    """ Initialize the FMU """
    model.set('valveOpening',0)
    model.initialize()
    model.do_step(0, sync_rate)
    time_step = sync_rate

    """ Actual training sequence """
    for k in range(50):
        for t in range(100):
            """Write random values to the controlled variables"""
            if t%120 == 0:
                command.append(random.uniform(0.0,100.0))
            else:
                command.append(command[-1])

            model.set('valveOpening',command[-1])

            """ Write the inflow temperature """
            T_cur.append(T[k]+(T[k+1]-T[k])/1000*t)
            if t >= 1:
                T_prev.append(T_cur[-2])
            else:
                T_prev.append(T_cur[-1])

            model.set('inflowTemp',T_cur[-1])

            model.do_step(time_step, sync_rate)

            """ Get the values calculated in the FMU """
            val = model.get("supplyTemp")
            y_train_1.append(float(val))

            val = model.get("hexele1masT")
            print(val)
            y_train_2.append(float(val))
            val = model.get("hexele2masT")
            y_train_3.append(float(val))
            val = model.get("hexele3masT")
            y_train_4.append(float(val))
            val = model.get("hexele4masT")
            y_train_5.append(float(val))

            """ Due to the later application, the metal temperature can only
            be updated each 60 time steps """
            if t == 0 or t%60 == 0:
                T_met_prev_1.append(y_train_2[-1])
                T_met_prev_2.append(y_train_3[-1])
                T_met_prev_3.append(y_train_4[-1])
                T_met_prev_4.append(y_train_5[-1])
            else:
                T_met_prev_1.append(T_met_prev_1[-1])
                T_met_prev_2.append(T_met_prev_1[-1])
                T_met_prev_3.append(T_met_prev_1[-1])
                T_met_prev_4.append(T_met_prev_1[-1])

            time_step += sync_rate

    """ Stack the lists with the relevant training data """
    X_train = np.stack((command,T_cur,T_prev,T_met_prev_1,T_met_prev_2,T_met_prev_3,T_met_prev_4),axis=1)

    """ Scale the training data """
    scaler = StandardScaler()
    X_train = scaler.fit_transform(X_train)
    print(X_train)

    # Use only the supply temperature as predicted variable
    y_train = y_train_1

    """ Start the regression """
    MLPModel = MLPRegressor(hidden_layer_sizes=(3 ), activation='logistic', solver='lbfgs', alpha=0.0001, batch_size ="auto",
                        learning_rate= 'constant', learning_rate_init=0.001, power_t=0.5, max_iter=2000, shuffle=True, random_state=None,
                        tol=0.0001, verbose=True, warm_start=False, momentum=0.9, nesterovs_momentum=True, early_stopping=False,
                        validation_fraction=0.1, beta_1=0.9, beta_2=0.999, epsilon=1e-08)

    MLPModel.fit(X_train, y_train)

    """ Save the model and the scaler for later use """
    dump(MLPModel, r"C:\TEMP\Dymola\Steam_humidifier.joblib")
    dump(scaler, r"C:\TEMP\Dymola\Steam_humidifier_scaler.joblib")

if __name__=="__main__": main()
