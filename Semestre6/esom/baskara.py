import math

class Baskara:
    def __init__(self, a,b,c):
        self.a = a
        self.b = b
        self.c = c

        assert not a ==0, 'O valor de a deve ser diferente de 0'
        assert self.calcula_delta() >= 0

    def calcula_delta(self):
        a = self.a
        b = self.b
        c = self.c
        return b**2 - 4*a*c 

    def calcula_raiz(self):
        a = self.a
        b = self.b
        c = self.c
        delta = self.calcula_delta()

        resp1 = (-b + math.sqrt(delta)) / (2*a)
        resp2 = (-b - math.sqrt(delta)) / (2*a)
        
        resp = [resp1, resp2]
        
        assert len(resp) == 2
        assert (a*(resp[0]**2) + b*(resp[0]) + c) == 0
        assert (a*(resp[1]**2) + b*(resp[1]) + c) == 0
        
        return resp



b = Baskara(1,5,4)
print(b.calcula_raiz())
