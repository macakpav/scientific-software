#This is Python code

import numpy
import ctypes
from numpy.ctypeslib import ndpointer
lib = ctypes.cdll.LoadLibrary("./cpp_example.so")
fun = lib.cpp_vec_cpy
fun.restype = int
fun.argtypes = [ndpointer(ctypes.c_double, flags="C_CONTIGUOUS"), \
                ctypes.c_int, ndpointer(ctypes.c_double, flags="C_CONTIGUOUS")]
def wrapper_vec_cpy(x,y):
    assert x.size == y.size
    fun(x, x.size, y)

vsize=20
x = numpy.ones(vsize)
y = numpy.zeros(vsize)
wrapper_vec_cpy(x, y)    
print(y)