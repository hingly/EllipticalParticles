function c = read_txt(filename)
  % read lines from FILENAME and return then in a cell array
  assert(exist(filename, 'file')==2, 'FILENAME must exist')
  
  c = {};

  f = fopen(filename);
  while ~feof(f)
    s = fscanf(f, '%s', 1);
    if length(s) > 0
      c = {c{:}, s};
    end
  end
  fclose(f);
