function runcases(directory)

testfiles = dir([directory '/' '*.json']);

for f = testfiles'
  fullfilename = [directory '/' f.name];
  % Make directories for outputs and step data
  ellipse2011(fullfilename);
end