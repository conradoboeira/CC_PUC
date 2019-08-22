from scipy.optimize import fsolve
import math
from sympy.solvers import solve

def myfunc(x):
    return math.sin(x) - math.cos(x) <= 0.5

print(solve(myfunc))
