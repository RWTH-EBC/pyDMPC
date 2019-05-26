# -*- coding: utf-8 -*-
"""
Created on Sun May 26 13:01:49 2019

@author: mba
"""

import System

def main():

    hall = System.System()
    
    try:

        hall.prep_cont_sys()

    except:
        hall.close_mod()
        hall.close_cont_sys()
        
    hall.close_mod()
    hall.close_cont_sys()
    print("Success")
    
if __name__=="__main__": main()