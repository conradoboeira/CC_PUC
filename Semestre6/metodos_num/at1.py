import numpy as np
import matplotlib.pyplot as plt

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'

eixo_x = np.arange(0,2*np.pi,0.1)
eixo_y_sen = np.sin(eixo_x)
eixo_y_cos = np.cos(eixo_x)

plt.plot(eixo_x, eixo_y_sen)
plt.plot(eixo_x, eixo_y_cos)
plt.show()
