function a = lessthanequal(b, c)

if length(b) ~= length(c)
    error('nonconformant arguments');
else
    a = all(b <= c);
end
