# -*- coding: utf-8 -*-
"""
Created on Sun May 26 13:01:49 2019

@author: mba
"""

import System
import time
import Time

def main():
    

    # Generate a system for the experiment
    Time.Time.contr_sys_type = "Modelica"
    hall = System.Bexmoc()

    System.Bexmoc.prep_cont_sys()
    
    # Minimum sample interval in seconds
    min_samp_inter = 10
    
    hall.initialize()
    
    for cur_time in range(0, 86400 , min_samp_inter):
        start_time = time.time()
        hall.execute()
        time.sleep(max(0, min_samp_inter - time.time() + start_time))
        
        
    System.Bexmoc.close_mod()
    System.Bexmoc.close_cont_sys()
    print("Success")
"""            
        except Exception as e:
            hall.terminate()
            print(getattr(e, 'message', repr(e)))
            
    except KeyboardInterrupt:
        hall.terminate()
        print('Interrupted')
"""   
if __name__=="__main__": main()