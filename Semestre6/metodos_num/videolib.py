from collections import namedtuple
import subprocess
import matplotlib.pyplot as plt
import matplotlib.image as mpimage
import numpy as np
import os
import sys


# Tupla com os parametros de cada conjunto de teste.
Videoset = namedtuple('Videoset', ['path', 'frames', 'extension'])

# Videos de teste disponibilizados.
video_sets = {
    'Eagle': Videoset('Eagle', 50, 'jpg'),
    'OldTownCross': Videoset('OldTownCross', 500, 'jpg'),
    'Riverbed': Videoset('Riverbed', 250, 'jpg'),
    'Stefan': Videoset('Stefan', 300, 'jpg'),
    'Tennis': Videoset('Tennis', 150, 'jpg'),
}


def get_frame_grayscale(frame):
    '''Retorna um quadro de video, em formato RGB, convertido para escala de cinzas.

    Args:
        frame (numpy.ndarray): O frame de video em formato RGB.

    Returns:
        numpy.ndarray: O frame passado como argumento, convertido para escala de cinza.
    '''
    frame_yuv = rgb_to_yuv(frame)
    return get_channel_yuv(frame_yuv, 'y')


def get_channel_yuv(frame, channel):
    '''Retorna o canal especificado do quadro em formato YUV.

    Args:
        frame (numpy.ndarray): O quadro de video em formato YUV.
        channel (str): O identificador do canal. Valores aceitos sao: 'y', 'u' or 'v'.

    Raises:
        Exception: Se o canal especificado for invalido.

    Returns:
        numpy.ndarray: O array 2D do canal especificado.
    '''
    if channel not in ['y', 'u', 'v']:
        raise Exception('Unknown channel for YUV frame: {}'.format(channel))

    if channel == 'y':
        return frame[:, :, 0]
    elif channel == 'u':
        return frame[:, :, 1]
    else:
        return frame[:, :, 2]


def plot_yuv_frame(frame):
    '''Plota o quadro formatado no padrao YUV.

    Args:
        frame (numpy.ndarray): O array 3D correspondente ao quadro em formato YUV.
    '''
    frame = frame.astype('uint8')
    fig, axs = plt.subplots(nrows=1, ncols=3)
    axs[0].imshow(frame[:, :, 0], cmap='gray')
    axs[1].imshow(frame[:, :, 1], cmap='gray')
    axs[2].imshow(frame[:, :, 2], cmap='gray')
    axs[0].set_title('(Y) Luminance')
    axs[1].set_title('(U) Blue Chrominance')
    axs[2].set_title('(V) Red Chrominance')
    axs[0].axis('off')
    axs[1].axis('off')
    axs[2].axis('off')
    plt.show()
    plt.close()


def plot_rgb_frame(frame):
    '''Plota o quadro formatado no padrao RGB.

    Args:
        frame (numpy.ndarray): O array 3D correspondente ao quadro em formato RGB.
    '''
    frame = frame.astype('uint8')
    fig, axs = plt.subplots(nrows=2, ncols=2)
    axs[0, 0].imshow(frame)
    axs[0, 1].imshow(frame[:, :, 0], cmap='Reds')
    axs[1, 0].imshow(frame[:, :, 1], cmap='Greens')
    axs[1, 1].imshow(frame[:, :, 2], cmap='Blues')
    axs[0, 0].set_title('Original')
    axs[0, 1].set_title('(R)ed')
    axs[1, 0].set_title('(G)reen')
    axs[1, 1].set_title('(B)lue')
    axs[0, 0].axis('off')
    axs[0, 1].axis('off')
    axs[1, 0].axis('off')
    axs[1, 1].axis('off')
    plt.show()
    plt.close()


def yuv_to_rgb(frame):
    '''Converte um quadro no formato YUV para o formato RGB, utilizando o padrao de conversao BT.709.

    Args:
        frame (numpy.ndarray): O objeto ndarray 3D no formato (linhas, colunas, canais YUV).

    Returns:
        numpy.ndarray: Um objeto ndarray 3D com formato (linhas, colunas, canais RGB).
    '''
    r = 1 * frame[:, :, 0] + 0 * frame[:, :, 1] + 1.28033 * frame[:, :, 2]
    g = 1 * frame[:, :, 0] - 0.21482 * frame[:, :, 1] - 0.38059 * frame[:, :, 2]
    b = 1 * frame[:, :, 0] + 2.12798 * frame[:, :, 1] + 0 * frame[:, :, 2]
    return np.dstack((r, g, b)).astype('int')


def rgb_to_yuv(frame):
    '''Converte um quadro no formato RGB para o formato YUV, utilizando o padrao de conversao BT.709.

    Args:
        frame (numpy.ndarray): O objeto ndarray 3D no formato (linhas, colunas, canais RGB).

    Returns:
        numpy.ndarray: Um objeto ndarray 3D com formato (linhas, colunas, canais YUV).
    '''
    y = 0.2126 * frame[:, :, 0] + 0.7152 * frame[:, :, 1] + 0.072 * frame[:, :, 2]
    u = -0.09991 * frame[:, :, 0] - 0.33609 * frame[:, :, 1] + 0.436 * frame[:, :, 2]
    v = 0.615 * frame[:, :, 0] - 0.55861 * frame[:, :, 1] - 0.05639 * frame[:, :, 2]
    return np.dstack((y, u, v)).astype('int')


def load_frames(videoset, total_frames=-1):
    '''Cria um gerador para o video especificado por parametro. Retorna um par de quadros (o quadro atual, e o seguinte),
    sempre no formato RGB.

    Args:
        videoset (Videoset(Namedtuple)): As especificacoes do video.
        total_frames (int, optional): Especifica quantos frames devem ser carregados. Por padrao, -1, ou seja, todos.

    Returns:
        numpy.ndarray: O primeiro quadro.
        numpy.ndarray: O segundo quadro.
    '''
    if total_frames == -1:
        # Carrega todos os quadros do video, aos pares.
        frames_to_load = videoset.frames - 1
    else:
        # Carrega a quantidade especificada de quadros.
        assert total_frames > 0 and total_frames < videoset.frames - 1
        frames_to_load = total_frames

    for frame_num in range(frames_to_load):
        frame1_name = 'frame{}.{}'.format(frame_num + 1, videoset.extension)
        frame2_name = 'frame{}.{}'.format(frame_num + 2, videoset.extension)
        frame1_path = os.path.join(videoset.path, frame1_name)
        frame2_path = os.path.join(videoset.path, frame2_name)
        frame1 = mpimage.imread(frame1_path)
        frame2 = mpimage.imread(frame2_path)
        yield frame1.astype('int'), frame2.astype('int')


def save_frame(frame_idx, frame, output_dir='output'):
    '''Salva um quadro de video. Os nomes de saida utilizados utilizam o formato 'frame%d.jpg', onde o numero do quadro
    e especificado pelo parametro frame_idx.

    Args:
        frame_idx (int): O numero do quadro que sera concatenado ao nome do arquivo de saida.
        frame (numpy.ndarray): O quadro a ser salvo.
        output_dir (str, optional): O diretorio de saida para gravacao. Por padrao 'output'.

    Returns:
        int: O frame_idx utilizado incrementado em uma unidade.
    '''
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    frame_name = 'frame{}.jpg'.format(frame_idx)
    save_path = os.path.join(output_dir, frame_name)
    mpimage.imsave(save_path, frame.astype('uint8'))
    return frame_idx + 1


def write_video(frame_dir: str, output_video: str, frame_rate: int, start_frame=0, frame_format='frame%d.jpg', output_extension='mp4'):
    '''Grava uma sequencia de imagens utilizando ffmpeg, gerando um video em formato

    Args:
        frame_dir (str): Diretorio onde estao localizados os quadros do video.
        output_video (str): Nome do arquivo de video que sera gerado.
        frame_rate (int): Taxa de quadros por segundo para exibicao do video (normalmente 25 ou 30).
        start_frame (int, optional): Numero do primeiro quadro do video no diretorio especificado. Por padrao, 0.
        frame_format (str, optional): Padrao de nome utilizado para os quadros dos videos. Por padrao, 'frame%d.jpg'.
        output_extension (str, optional): Extensao do video que gerado. Por padrao, 'mp4'.
    '''
    print(os.path.join(frame_dir, frame_format))
    if sys.platform == 'win32':
        executable = 'ffmpeg.exe'
    else:
        executable = './ffmpeg'
    args = [
        executable,
        '-start_number',
        str(start_frame),
        '-framerate',
        str(frame_rate),
        '-i',
        os.path.join(frame_dir, frame_format),
        '-vcodec',
        'h264',
        '{}.{}'.format(output_video, output_extension),
        '-y'
    ]
    subprocess.run(args)


# Exemplo de utilizacao das principais funcoes.
if __name__ == '__main__':
    # Carrega as especificacoes de uma sequencia de teste (neste caso, 'Tennis').
    videoset = video_sets['Tennis']

    # Iteramos sobre os quadros da sequencia de teste, sempre obtendo um par de quadros.
    # A carga dos quadros sempre ocorre no formato RGB.
    for frame1, frame2 in load_frames(videoset, total_frames=1):
        # Para ver a representacao RGB de um quadro.
        plot_rgb_frame(frame1)

        # Convertendo o quadro para formato YUV.
        frame1_yuv = rgb_to_yuv(frame1)

        # Para ver a representacao YUV de um quadro.
        plot_yuv_frame(frame1_yuv)

        # Salvando um quadro
        save_frame(0, frame1)

        # Gerando o video
        write_video('OldTownCross_Output', 'test2', 75, 0, 'frame%d.jpg')
