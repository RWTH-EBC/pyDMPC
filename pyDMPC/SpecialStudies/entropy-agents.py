from joblib import load
import numpy as np

# Weight factors
a_1 = 1
a_2 = 1 
a_3 = 1

# Working directory
wkdir = r"C:\TEMP\Dymola"


def agent_1():
    # Load the classifier: returns trajectory class
    clf = load(wkdir + r"\heater-clf.joblib")

    # Load the cost of each class
    cost_clf = load(wkdir + r"\cost-clf.joblib")
    av_clf = load(wkdir + r"\av-clf.joblib")
    prob_dic = {1:0.1,2:0.3,3:0.1,4:0.5}

    return clf, prob_dic, cost_clf, av_clf

def agent_2(input, probs):
    
    # Standard sequences used for this case study
    seq = [[0,0],[100,100],[45,35],[60,50],[30,20],[50,50],[20,20]]
    min_cost = []

    # Load the subsystem model and the corresponding scaler
    MLPModel = load(wkdir + r"\heater.joblib")
    scaler = load(wkdir + r"\heater_scaler.joblib")

    # Get all the information from the other agent
    clf, prob_dic, cost_clf, av_clf = agent_1()

    
    for l,w in enumerate(input):
        cost = []
        kl = []
        for k,u in enumerate(seq):
            count_c = 0
            command = []
            Temp = []
            x_train =[]
            v = []
            tim_con = 10

            for t in range(70):

                if t < 10:
                    com = 0
                elif t < 40:
                    com = u[0]
                else:
                    com = u[1]

                Temp.append(w)

                if t > 0:
                    if abs(com-command[-1])>0.001:
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

            x_train = np.stack((command, Temp), axis=1)

            x_train = np.array(x_train)

            scaled_instances = scaler.transform(x_train)
            temp = MLPModel.predict(scaled_instances)

            entr = 0

            for t in range(10,70,1):
                dif = temp[t] - temp[t-1]
                v.append(dif)
                Twout = 273+ 50 - 0.5*1000*(temp[t]-w)/0.25/4180
                entr += abs(0.5*1000*np.log((273 + w)/(273 + temp[t])) +
                0.25*4180*np.log((273 + 50)/(Twout)))

            entr = entr/60

            av = 0
            for t in range(60,70,1):
                av += temp[t]

            av = av/10

            values = [val for k,val in enumerate(v)]


            x_test = [values]

            # Find the correct class 
            cl = clf.predict(x_test)

            x_test = [[av, cl[0]]]

            # Cost of the downstream subsystem
            c1 = np.interp(av,av_clf[cl[0]-1],cost_clf[cl[0]-1])

            # KL-divergence
            kl.append(a_3*probs[l]*np.log(probs[l]/prob_dic[float(cl)]))

            # Cost in the subsystem itself
            cost.append(a_1*c1 + a_2*entr + 
                        a_3*probs[l]*np.log(probs[l]/prob_dic[float(cl)]))
        
        # Find the minimal cost
        min_cost.append(min(cost))
        pos = np.argmin(cost)

        print(kl[pos])
        print(min(cost))
        print(min(cost)-kl[pos])

    return min_cost

def main():
    agent_2([30],[1])

if __name__=="__main__": main()
