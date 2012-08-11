function a = allequal(b, c, epsilon)
if length(b) ~= length(c)
    error('nonconformant arguments');
else
    a = all(abs(b-c) < epsilon);
end