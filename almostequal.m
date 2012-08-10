function a = almostequal(b, c, epsilon)
a = norm(b-c) < epsilon;