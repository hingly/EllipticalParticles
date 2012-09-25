function a = almostequal(b, c, epsilon, mask)

if ~exist('mask', 'var')
  mask = true(size(b));
end

a = norm(b(mask) - c(mask)) < epsilon;