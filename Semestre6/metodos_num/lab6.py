import numpy as np
import matplotlib.pyplot as plt
from numpy.polynomial import Polynomial as P

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'

a = np.array([[1,0,0],[1,1,1],[1,2,4]])
b = np.array([6,-2,0])

x = np.linalg.solve(a,b)
p = P(x)
eixo_x = np.linspace(-5,5,100)
eixo_y = [p(x) for x in eixo_x]

plt.plot(eixo_x,eixo_y)
plt.grid()


dots_x = [0,1,2]
dots_y = [6,-2,0]
plt.plot(dots_x, dots_y, 'bo')
print(x)
plt.axvline(x=0, color='black')
plt.axhline(y=0, color='black')
plt.show()
