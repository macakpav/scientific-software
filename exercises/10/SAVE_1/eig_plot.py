import numpy as np
import matplotlib.pyplot as pyplot

matrix_size = 10
matrix = np.random.randn(matrix_size, matrix_size) #Default = row-major order

# print(np.size(matrix,0)) # Rows
# print(np.size(matrix,1)) # Columns

pyplot.scatter(matrix[0,:], matrix[1,:])
pyplot.show()