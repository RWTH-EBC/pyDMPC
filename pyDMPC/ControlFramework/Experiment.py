import System
import SystemTime
import Init
import time
import shutil

glob_start_time = SystemTime.Time.get_time()

def main():

    # Generate a system for the experiment
    SystemTime.Time.contr_sys_type = Init.contr_sys_typ
    sys = System.Bexmoc(interp = True)
    min_samp_inter = Init.time_incr

    System.Bexmoc.prep_cont_sys()

    sys.initialize()
    shutil.copyfile(f"{Init.glob_res_path}\\weather.mat", f"{Init.glob_res_path}\\{Init.name_wkdir}\\weather.mat")
    shutil.copyfile(f"{Init.glob_res_path}\\occupancy.mat", f"{Init.glob_res_path}\\{Init.name_wkdir}\\occupancy.mat")

    try:
        try:
            
            for _ in range(0, Init.end_time, min_samp_inter):
                start_time = SystemTime.Time.get_time()
                print(f"Time: {start_time}")
                
                sys.execute()
                stop_time = SystemTime.Time.get_time()
                
                print(min_samp_inter - stop_time + start_time)
                if Init.contr_sys_typ != "Modelica":
                    time.sleep(max(0, min_samp_inter - stop_time + start_time))         

            sys.close_mod()
            System.Bexmoc.close_cont_sys()
            print("Success")

        except Exception as e:
            sys.terminate()
            print(getattr(e, 'message', repr(e)))

    except KeyboardInterrupt:
        sys.terminate()
        print('Interrupted')

if __name__=="__main__": main()
