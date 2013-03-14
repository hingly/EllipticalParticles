function r = hasfield(structure, fieldname)
% HASFIELD return true if STRUCTURE has field FIELDNAME
if isstruct(structure)
  r = any(strcmp(fieldnames(structure), fieldname));
else
  error('STRUCTURE must be a structure')
end