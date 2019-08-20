import numpy as np
import matplotlib.pyplot as plt
from itertools import permutations
from itertools import product

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'

def valores_gen(lst, size):
    lst = list(product(lst,repeat=size))
    resp = []
    for l in lst:
        if(not l[0] == 0 or sum(l) == 0):
            resp.append(l)

    return resp

def lst_to_string(lst):
    resp = ""
    for c in lst:
        resp = resp + str(c)
    return resp

def F(b,n,e1,e2):
    mantissas = valores_gen(range(b), n)
    print("({}; 0,{}) = 0".format(b,lst_to_string(mantissas[0]))) 
    resultado = [0]
    for m in mantissas:
        if(sum(m) == 0): continue
        for exp in range(e1, e2+1):
            cp = exp-1
            num = 0
            for i in range(n):
                base = b*m[i]
                if(base > 0): num += base**cp
                cp -= 1
            resultado.append(num)
            print("({}; 0,{}; {}) = {}".format(b,lst_to_string(m),exp,num)) 

    return resultado



def main():
    b = int(input('b:'))
    n = int(input('n:'))
    e1 = int(input('e1:'))
    e2 = int(input('e2:'))
    nums = F(b,n,e1,e2)
    eixo_x = nums + [-x for x in nums if x > 0]
    eixo_y = [0 for i in range(len(eixo_x))]
    plt.plot(eixo_x,eixo_y,'bo')
    plt.grid()
    plt.show()

if __name__ == '__main__':
    main()

