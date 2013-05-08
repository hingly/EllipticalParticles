function data = collect_data(directory)

testfiles = dir([directory '/' 'strain*.json']);

for f = testfiles'
  fullfilename = [directory '/' f.name];
  data(end+1) = loadjson(fullfilename);
end


