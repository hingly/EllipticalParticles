function runtests

testfiles = dir('test_*.m');

fprintf('Found %i test(s).\n', length(testfiles));

for test = testfiles'
  printf('Running %s... ', test.name)
  try
    eval(test.name(1:end-2));
    disp('succeeded.')
  catch
    disp('failed!')
    disp(lasterr)
  end
end