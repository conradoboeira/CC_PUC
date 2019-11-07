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

# Devolve uma matriz que corresponde a soma de cada bloco de tamanho size
def sum_matrix(frame, size, step):
    min_x = 0
    min_y = 0
    frame_shape = frame.shape
    frame_x = frame_shape[1]
    frame_y = frame_shape[0]
    matrix = []
    for j in range(int(frame_y/size)):
        min_x = 0
        line = []
        for i in range(int(frame_x/size)):
            max_x = min_x + size
            max_y = min_y + size

            block = frame[min_y:max_y, min_x:max_x]
            block_sum = np.sum(block)
            line.append(block_sum)

            min_x += step 
        
        matrix.append(line)
        min_y += step

    return matrix

# Procura bloco de tamanho size com a soma mais proxima
# da soma do bloco original (dentro de um intervalo definido)
# e retorna o vetor de movimento
def find_mov_vector(x, y, frame, size, block_sum,original_block):
    min_x = max(0, x -size)
    min_y = max(0, y -size)
    frame_shape = frame.shape
    frame_x = frame_shape[1]
    frame_y = frame_shape[0]
    max_x = min(frame_x-size, x+size)
    max_y = min(frame_y-size, y+size)

    central_block = frame[y:y+size, x:x+size]
    smallest_diff = np.sum(np.abs(original_block - central_block))
    smallest_pt = (x,y)

    for p_y in range(min_y, max_y):
        for p_x in range(min_x, max_x):
            block = frame[p_y:(p_y+size), p_x:(p_x+size)]
            diff = np.sum(np.abs(original_block - block))
            if(diff < smallest_diff):
                smallest_diff = diff
                smallest_pt = (p_x,p_y)

    vector = (smallest_pt[0]-x, smallest_pt[1]-y)
    return vector



# funcao para gerar a interpolacao de frames baseado nos vetores de movimento
def motion_interpol(video):
    # Carrega frames do video
    videoset = video_sets[video]
    frame_count = 0
    frames = vd.load_frames(videoset, total_frames=(videoset[1]-2))
    for frame1, frame2 in frames:

        frame1_gray = vd.get_frame_grayscale(frame1)
        frame2_gray = vd.get_frame_grayscale(frame2)
        
        # Calcula matriz de soma
        matrix = np.array(sum_matrix(frame1_gray,16,16))

        # Calcula para cada bloco o vetor de movimento e salva ele em
        # motion_matrix
        motion_matrix = []
        for j in range(matrix.shape[0]):
            line = []
            for i in range(matrix.shape[1]):
                pos_x = i*16
                pos_y = j*16
                vector = find_mov_vector(pos_x,pos_y, frame2_gray, 16,
                        matrix[j][i], frame1_gray[pos_y:pos_y+16,pos_x:pos_x+16])
                line.append(vector)
            motion_matrix.append(line)
        motion_matrix = np.array(motion_matrix)


        # Cria um frame a ser inserido que inicialmente corresponde
        # a interpolacao entre a transicao de pixels
        canvas = 0.5*frame1 + 0.5*frame2
        canvas = canvas.astype(np.int)
       
        # Desloca os pixels do frame1 e os sobescreve no frame intermediario
        for j in range(motion_matrix.shape[0]):
            for i in range(motion_matrix.shape[1]):
                pos_x = i*16
                pos_y = j*16
                dst_x = pos_x + int(motion_matrix[j][i][0]*0.5)
                dst_y = pos_y + int(motion_matrix[j][i][1]*0.5)
                canvas[dst_y:dst_y+16, dst_x:dst_x+16] = frame1[pos_y:pos_y+16,pos_x:pos_x+16]
       
     
        frame_count = vd.save_frame(frame_count, frame1) 
        frame_count = vd.save_frame(frame_count,canvas)
        
        # Escreve o numero de frames vistos na tela para que seja possivel
        # acompahar a execucao
        print(int(frame_count/2))

def main():
    # Variavel chumbada para o nome do video. Para testar com outros so trocar
    # ela
    video = 'Tennis'
    motion_interpol(video)
    vd.write_video('output', 'video_interpolado', 60)

if __name__ == '__main__':
	main()
