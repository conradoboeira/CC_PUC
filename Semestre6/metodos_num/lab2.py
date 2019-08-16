import numpy as np
import matplotlib.pyplot as mp
from itertools import permutations

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'

def valores_gen(lst, size):
    return list(permutations(lst,size))

def F(b,n,e1,e2):
   lst = []
   lst.append('0,' + '0'*n)
   s = '0.1' + '0'*(n-1)
   #lst.append(s)
   for i in range(n-1):
       for j in range(b):
           l = list(s)
           l[i] = j
           lst.append(str(l))


def main():
    b = int(input('b:'))
    n = int(input('n:'))
    e1 = int(input('e1:'))
    e2 = int(input('e2:'))
    #lst_nums = F(b,n,e1,e2)
    #print(lst_nums)
    print(valores_gen([0,1], n))

if __name__ == '__main__':
    main()

