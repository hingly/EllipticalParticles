function write_txt(filename, c)
% write a cell array's contents to a file

assert(iscell(c), 'C must be a cell array');
assert(ischar(filename), 'FILENAME must be a string');
assert(isvector(c), 'C must be a one-dimensional cell array');

f = fopen(filename, 'w');
for i = 1:length(c)
  fprintf(f, '%s\n', c{i});
end

fclose(f);