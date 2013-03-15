function p = product(varargin)
% return matrix with cartesian product of input arguments
% similar to Python's itertools.product

ii = nargin:-1:1;

[A{ii}] = ndgrid(varargin{ii});
p = reshape(cat(nargin+1, A{:}), [], nargin);
