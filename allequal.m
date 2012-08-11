function a = allequal(b, c, epsilon)
d=length(b);
for ii=1:d
  e(ii) = (b(ii)-c(ii)) < epsilon;
  if e(ii) == 0
    a=0;
  end
end

