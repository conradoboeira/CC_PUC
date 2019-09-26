import numpy as np
import matplotlib.pyplot as plt
from scipy import interpolate

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'


t1 = (np.array([-2,-1,1]),np.array([-11, 5, 0.75]))

spl1 = interpolate.CubicSpline(t1[0],t1[1])
spl12 = interpolate.make_interp_spline(t1[0],t1[1], k=2)
x = np.arange(-3,2,0.1)

#plt.plot(x,[spl12(i) for i in x], color='blue')
#plt.plot(t1[0], t1[1], 'ro')

#plt.show()


x = np.arange(-2*np.pi, 2*np.pi + np.pi/2, np.pi/2)
y = np.sin(x)

sp1 = interpolate.make_interp_spline(x,y,k=1)
sp2 = interpolate.make_interp_spline(x,y,k=2)
sp3 = interpolate.make_interp_spline(x,y,k=3)

x_true =  np.arange(-2*np.pi, 2*np.pi + np.pi/2, np.pi/16)
y_true = np.sin(x_true)

plt.plot(x_true, y_true, color='blue')
plt.plot(x_true, sp1(x_true), color='green')
plt.plot(x_true, sp2(x_true), color='yellow')
plt.plot(x_true, sp3(x_true), color='red')

plt.show()
