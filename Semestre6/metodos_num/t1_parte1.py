import numpy as np
import matplotlib.pyplot as plt
from scipy import interpolate
from collections import namedtuple
import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'
import videolib as vd 

import sys


# Tupla com os parametros de cada conjunto de teste.
Videoset = namedtuple('Videoset', ['path', 'frames', 'extension'])

# Videos de teste disponibilizados.
video_sets = {
    'OldTownCross': Videoset('OldTownCross', 500, 'jpg'),
    'Riverbed': Videoset('Riverbed', 250, 'jpg'),
    'Stefan': Videoset('Stefan', 300, 'jpg'),
    'Tennis': Videoset('Tennis', 150, 'jpg'),
}

def first_interpol():
    videoset = video_sets['OldTownCross']
    frame_count = 0
    for frame1, frame2 in vd.load_frames(videoset, total_frames=498):
        print(frame_count)
        frame_count = vd.save_frame(frame_count, frame1)
        for i in np.linspace(0, 1, num = 4)[1:-1]:
            print(frame_count)
            interpol_frame = np.multiply(frame1, i) + np.multiply(frame2, 1-i)
            frame_count = vd.save_frame(frame_count, interpol_frame)
    
    vd.write_video('output', 'video', 75)

