function c = read_txt(filename)
  % read lines from FILENAME and return then in a cell array
  c = {};
  f = fopen(filename);
  while ~feof(f)
    s = fscanf(f, '%s', 1);
    if length(s) > 0
      c = {c{:}, s};
    end
  end
  fclose(f);
