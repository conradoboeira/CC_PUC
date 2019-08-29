import numpy as np
import matplotlib.pyplot as plt
from numpy.polynomial import Polynomial as P

import os
os.environ['QT_PLUGIN_PATH'] = '/opt/anaconda3/lib'

def mra(roots):
    maior = 0
    for r in roots:
        if isinstance(r, complex):
            if abs(r.real) > maior: maior = abs(r.real)
        else:
            if r > maior: maior = r
    return maior


def root_plot(pol):
    p = strl_pol(pol)
    roots = p.roots()
    print('Numero de raizes: ' + str(len(roots)))
    print("Raizes: "+"".join(str(e)+ " " for e in roots))
    
    mraiz = mra(roots)
    x = np.linspace(-mraiz -1, mraiz+1, 100)
    plt.plot(x, [0 for i in x],'k')
    plt.plot(x, p(x))

    reals = []
    imagi = []
    for r in roots:
        if isinstance(r, complex): imagi.append(r)
        else: reals.append(r)

    plt.plot(reals, [p(x) for x in reals], 'bo')
    
    for c in imagi:
        plt.plot(c.real,c.imag, 'ro')
    
    plt.title(p_print(pol))
    plt.grid()
    plt.show()

def mfopen(name):
    with open(name, 'r') as files:
        res = []
        for l in files:
            v = l.strip().split(';')
            res.append(v)
        files.close()
        return res

def strl_pol(s): return P([float(x) for x in s])

def p_print(p):
    pstr = ""
    for x in range(len(p)-1, -1, -1):
        if(x == 0): pstr += str(p[x]) + " "
        elif(x == 1): pstr += str(p[x]) + "x "
        else: 
            if p[x].startswith('-') or x == len(p) -1: pstr += "{}x^{} ".format(p[x],x)
            else: pstr += "+{}x^{} ".format(p[x],x)
    return pstr

def main():
    arq = 'polinomios.txt'
    polis = mfopen(arq)
     
    for p in polis:
        pol = p_print(p)
        print("Polinomio: " + pol)
        root_plot(p)

if __name__ == '__main__':
    main()

