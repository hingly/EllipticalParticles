function a = almostequal(b, c, epsilon, mask)

if ~exist('mask', 'var')
  mask = true(size(b));
end

difference = b - c;
a = norm(difference(mask)) < epsilon;