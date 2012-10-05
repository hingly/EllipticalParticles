function structure = set_recursive(structure, value)

% This subroutine clears all variables in a structure
for i = fieldnames(structure)'
  % if this field is itself a structure, recurse
  if isstruct(structure.(i{1})) 
    structure.(i{1}) = set_recursive(structure.(i{1}), value);
  elseif islogical(structure.(i{1}))
    structure.(i{1})(:) = false;
  else
    structure.(i{1})(:) = value;
  end
end





