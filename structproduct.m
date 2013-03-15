function s = structproduct(varargin)
% STRUCTPRODUCT return a structure array with varying elements
% arguments are field1, values1, field2, values2, etc
% Result is outer product of all values assigned to combination of fields.

% Author: Carl Sandrock 

N = length(varargin);

assert(N>0, "Called with no arguments")
assert(mod(N, 2) == 0, "Every structure field must have values");

names = varargin(1, 1:2:end);
valuecombinations = product(varargin{1, 2:2:end});

s = [];
smallstruct = struct();

for values = valuecombinations'
    for i = 1:N/2
        field_cell = strread(names{i}, '%s', 'delimiter', '.');
        smallstruct = subsasgn(smallstruct, ...
                               struct('type', '.', 'subs', field_cell),...
                               values(i));
    end
    s = [s smallstruct];
end