import numpy as np
import matplotlib.pyplot as plt
from scipy import interpolate
from collections import namedtuple
import videolib as vd 

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'

# Tupla com os parametros de cada conjunto de teste.
Videoset = namedtuple('Videoset', ['path', 'frames', 'extension'])

# Videos de teste disponibilizados.
video_sets = {
    'OldTownCross': Videoset('OldTownCross', 500, 'jpg'),
    'Riverbed': Videoset('Riverbed', 250, 'jpg'),
    'Stefan': Videoset('Stefan', 300, 'jpg'),
    'Tennis': Videoset('Tennis', 150, 'jpg'),
}

def test():
    videoset = video_sets['OldTownCross']
    # Iteramos sobre os quadros da sequencia de teste, sempre obtendo um par de quadros.
    # A carga dos quadros sempre ocorre no formato RGB.
    for frame1, frame2 in vd.load_frames(videoset, total_frames=1):
        # Para ver a representacao RGB de um quadro.
        vd.plot_rgb_frame(frame1)

        # Convertendo o quadro para formato YUV.
        frame1_yuv = vd.rgb_to_yuv(frame1)

        # Para ver a representacao YUV de um quadro.
        vd.plot_yuv_frame(frame1_yuv)

def main():
    videoset = video_sets['OldTownCross']
    num_of_interpolated_frames = 2
    interpol_step = 1.0/(num_of_interpolated_frames +1)
    frame_count = 0
    for frame1, frame2 in vd.load_frames(videoset, total_frames=20):
        print(frame_count)
        frame_count = vd.save_frame(frame_count, frame1)
        for i in np.arange(interpol_step, 1, interpol_step):
            print(frame_count)
            interpol_frame = np.multiply(frame1, i) + np.multiply(frame2, 1-i)
            frame_count = vd.save_frame(frame_count, interpol_frame)

if __name__ == '__main__':
	main()
