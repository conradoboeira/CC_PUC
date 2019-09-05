import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import newton 

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'

def r1():
    def func(x):
        return (x**x) - 100
    def derivada(x):
        return (x**x) * (np.log(x)+1)
    root= newton(func, x0=3, fprime=derivada)
    print('r1: {}'.format(root))

def r2():
    def func(x):
        return (np.e**x) - 4*np.cos(x)
    def derivada(x):
        return (np.e**x) - 4*np.sin(x)
    root = newton(func, x0=10, fprime=derivada)
    print('r2: {}'.format(root))
    

def main():
    feitas = 2
    for i in range(1,feitas+1):
        func = 'r'+str(i)
        globals()[func]()

if __name__ == '__main__':
    main()
