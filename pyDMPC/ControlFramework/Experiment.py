import System
import Time
import Init

def main():

    # Generate a system for the experiment
    Time.Time.contr_sys_type = "Modelica"
    sys = System.Bexmoc(interp = False)

    System.Bexmoc.prep_cont_sys()

    # Minimum sample interval in seconds
    min_samp_inter = Init.time_incr

    sys.initialize()

    try:
        try:
            for cur_time in range(0, 86400 , min_samp_inter):
                sys.execute()
                print(f"Time: {cur_time}")
        
            System.Bexmoc.close_mod()
            System.Bexmoc.close_cont_sys()
            print("Success")

        except Exception as e:
            sys.terminate()
            print(getattr(e, 'message', repr(e)))

    except KeyboardInterrupt:
        sys.terminate()
        print('Interrupted')

if __name__=="__main__": main()
