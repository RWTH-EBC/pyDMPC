from sklearn.ensemble import RandomForestClassifier
from joblib import dump, load
import numpy as np

model = []
output = []

# Working directory
wkdir = r"C:\TEMP\Dymola"

def objf(u, w, v_set_h, v_set_c, ret):
    """
    inputs:
    u: control sequence
    w: inflow temperature
    v_set_h: heating set point temperature
    v_set_c: cooling set point temperature
    ret: Boolean to indicate if the functions should return
    c:
    """

    # Load the model of the heater and the corresponding scaler
    MLPModel = load(wkdir + r"\heater.joblib")
    scaler = load(wkdir + r"\heater_scaler.joblib")

    count_c = 0
    command = []
    Temp = []
    x_train =[]
    v = []
    tim_con = 10
    cost = []

    # Calculation time is 70 minutes, of which 10 are for initialization
    for t in range(70):
        # Select the correct command from the sequence
        if t < 10:
            com = 0
        elif t < 20:
            com = u[0]
        else:
            com = u[1]

        # Create an inflow temperature trajectory
        Temp.append(w)

        if t>0:
            # Check if the command has changed significantly
            if abs(com-command[-1])>0.001:
                # Let the command rise to the value from the control
                # sequence within the time tim_con
                if count_c < tim_con:
                    command.append(command[-1] + (com-command[-1])/(tim_con-count_c))
                    count_c += 0
                else:
                    command.append(com)
                    count_c = 1
            else:
                command.append(com)
        else:
            command.append(com)

    # Stack the command and the temperature, scale the array
    x_train = np.stack((command, Temp), axis=1)
    x_train = np.array(x_train)
    scaled_instances = scaler.transform(x_train)

    # Calculate the output from the heater subsystem. The heater model is
    # actually unknown but used here for reasons of simplicity. It should be
    # replaced with a different trajectory generator
    temp = MLPModel.predict(scaled_instances)

    for t in range(10,70,1):
        # Calculate the temperature difference in one time step
        dif = temp[t] - temp[t-1]

        # Check if the temperature exceeds the tolerance range
        if temp[t] > v_set_h - 0.5:
            qh = 0
            entr_h = 0
        else:
            # Compute the entropy production and the water temperature
            qh = max(0,0.25*1000*(v_set_h-(temp[t])))
            T_h_in = 50+273
            T_h_out = T_h_in - qh/4180/0.25
            entr_h = abs(0.5*1000*np.log((273+temp[t])/(273+v_set_h)) +
            0.25*4180*np.log(T_h_in/T_h_out))

        # Check if the temperature exceeds the tolerance range
        if temp[t] < v_set_c + 0.5:
            qc = 0
            entr_c = 0
        else:
            # Compute the entropy production and the water temperature
            qc = max(0,0.25*1000*((temp[t]-v_set_c)))
            T_c_in = 10+273
            T_c_out = T_c_in + qc/4180/0.25
            entr_c = abs(0.5*1000*np.log((273+temp[t])/(273+v_set_c)) +
            0.25*4180*np.log(T_c_in/T_c_out))

        # Entropy production in heating and cooling is the cost
        cost.append(entr_c + entr_h)
        print(entr_h)
        print(temp[t])
        v.append(dif)

    # Average the cost over the simulation time
    cost = sum(cost)/60
    print(cost)

    av = 0
    for t in range(60,70,1):
        av += temp[t]

    # Average the outflow temperature over the last ten minutes
    av = av/10

    if ret:
        return v, cost, av

# inflow temperature
w = 30  

# heating set point
v_set_h = [38]

# cooling set point
v_set_c = [33]

# training control sequence
u = [[0,0],[5,0],[2,2],[8,6],[3,7],[100,100],[92,88],[70,55],[67,53],[65,55],
     [50,40],[48,35],[53,39],[50,50],[20,20],[22,18],[35,30],[53,46]]

# training labels
y_train = [1,1,1,1,1,2,2,3,3,3,3,3,3,4,4,4,4,4]

x_train = []
x_train_cost = [[],[],[],[]]
y_train_cost = [[],[],[],[]]


for k in range(1):
    for l,val in enumerate(u):
        v, cost, av = objf(val, w, v_set_h[k], v_set_c[k], True)
        values = [val for k,val in enumerate(v)]

        x_train.append(values)
        x_train_cost[y_train[l]-1].append(av)
        y_train_cost[y_train[l]-1].append(cost)

print(y_train_cost)

clf = RandomForestClassifier(n_estimators=100, max_depth=2,random_state=0)
clf.fit(x_train, y_train)

dump(clf, wkdir + r"\heater-clf.joblib")
dump(y_train_cost, wkdir + r"\cost-clf.joblib")
dump(x_train_cost, wkdir + r"\av-clf.joblib")
