function a = allequal(b, c, epsilon, mask)

if ~exist('mask', 'var')
  mask = true(size(b));
end


if length(b) ~= length(c)
    error('nonconformant arguments');
else
    a = all(abs(b(mask)-c(mask)) < epsilon);
end