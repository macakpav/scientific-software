import numpy as np
import matplotlib.pyplot as pyplot

import ctypes
from numpy.ctypeslib import ndpointer
lib = ctypes.cdll.LoadLibrary("./eigenv_wrapper.so")

fun = lib.cpp_eig
fun.restype = int
fun.argtypes = [ndpointer(ctypes.c_double, flags="C_CONTIGUOUS"), \
                ctypes.c_int, ndpointer(ctypes.c_double, flags="C_CONTIGUOUS"), ndpointer(ctypes.c_double, flags="C_CONTIGUOUS")]

def wrapper_eigenv(matrix,eigvr,eigvi):
    assert np.size(eigvr) == np.size(eigvi)
    assert np.size(matrix,0) == np.size(matrix,1)
    assert np.size(eigvr) == np.size(matrix,0)

    fun(matrix, eigvr.size, eigvr, eigvi)

matrix_size = 10
matrix = np.random.randn(matrix_size, matrix_size) #Default = row-major order
#matrix = np.zeros([matrix_size,matrix_size]) #Zeros - eigvals should be all zeros as well
#matrix = np.eye(matrix_size) #Identity matrix - eigvals are ones

#Symmetric matrix - purely real eigenvalues
# matrix = np.random.randn(matrix_size, matrix_size) 
# matrix = np.matmul(np.transpose(matrix),matrix)

real_part = np.zeros([matrix_size])
imag_part = np.zeros([matrix_size])
wrapper_eigenv(matrix,real_part,imag_part)

pyplot.scatter(real_part, imag_part)
pyplot.show()