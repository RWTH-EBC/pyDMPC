from sklearn.neural_network import MLPClassifier, MLPRegressor
from sklearn.preprocessing import StandardScaler
import numpy as np
from pyfmi import load_fmu
import random
from joblib import dump, load
from matplotlib import pyplot as plt

def main():

    module = "cooler"
    command = []        # The manipulated variable in the model
    T_cur = []          # The current inflow temperature

    """ Lists for the training data """
    y_train = []


    """ Random inflow temperatures for training """
    T = [275]

    for k in range(49):
        T.append(random.uniform(275, 320.0))

    T.append(320)

    """ Simulate the FMU to generate the training data """
    sync_rate = 60  # Synchronisation rate of the FMU

    # Load exisiting FMU
    model = load_fmu(f"C:\TEMP\Dymola\{module}.fmu")

    """ Initialize the FMU """
    model.set('valveOpening',0)
    model.set('inflowTemp',275)
    model.initialize()
    model.do_step(0, sync_rate)
    time_step = sync_rate

    """ Actual training sequence """
    for k in range(50):
        for t in range(60):
            """Write random values to the controlled variables"""
            if t%120 == 0:
                command.append(random.uniform(0.0,100.0))
            else:
                command.append(command[-1])

            model.set('valveOpening',command[-1])

            """ Write the inflow temperature """
            if t <= 60:
                T_cur.append(T[k]+(T[k+1]-T[k])/60*t)
            else:
                T_cur.append(T_cur[-1])

            model.set('inflowTemp',T_cur[-1])

            model.do_step(time_step, sync_rate)

            """ Get the values calculated in the FMU """
            val = model.get("supplyTemp")
            y_train.append(float(val))

            val = model.get("hexele1masT")
            print(val)

            time_step += sync_rate

    """ Stack the lists with the relevant training data """
    X_train = np.stack((command,T_cur),axis=1)

    """ Scale the training data """
    scaler = StandardScaler()
    X_train = scaler.fit_transform(X_train)
    print(X_train)

    """ Start the regression """
    MLPModel = MLPRegressor(hidden_layer_sizes=(3 ), activation='logistic', solver='lbfgs', alpha=0.0001, batch_size ="auto",
                        learning_rate= 'constant', learning_rate_init=0.001, power_t=0.5, max_iter=2000, shuffle=True, random_state=None,
                        tol=0.0001, verbose=True, warm_start=False, momentum=0.9, nesterovs_momentum=True, early_stopping=False,
                        validation_fraction=0.1, beta_1=0.9, beta_2=0.999, epsilon=1e-08)

    MLPModel.fit(X_train, y_train)

    y_predict = MLPModel.predict(X_train)

    plt.plot(y_train)
    plt.plot(y_predict)
    plt.show()

    """ Save the model and the scaler for later use """
    dump(MLPModel, f"C:\TEMP\Dymola\{module}.joblib")
    dump(scaler, f"C:\TEMP\Dymola\{module}_scaler.joblib")

if __name__=="__main__": main()
