function test_set_recursive

datapoints = 20;

full_structure.a = ones(1, datapoints);
full_structure.b = ones(3, datapoints);
full_structure.c.d = ones(1, 3);
full_structure.c.e = ones(3, 1);
full_structure.f = false(1, datapoints);


full_structure = set_recursive(full_structure, nan);


assert(all(isnan(full_structure.a(:))), ...
       'Not all datapoints in a were cleared')

assert(all(size(full_structure.a) == [1, datapoints]), ...
       'size of a has changed');

assert(all(isnan(full_structure.b(:))), ...
       'Not all datapoints in b were cleared')

assert(all(size(full_structure.b) == [3, datapoints]), ...
       'size of b has changed');

assert(all(isnan(full_structure.c.d(:))), ...
       'Not all datapoints in d were cleared')

assert(all(size(full_structure.c.d) == [1, 3]), ...
       'size of d has changed');

assert(all(isnan(full_structure.c.e(:))), ...
       'Not all datapoints in e were cleared')

assert(all(size(full_structure.c.e) == [3, 1]), ...
       'size of e has changed');

assert(all(not(full_structure.f(:))), ...
       'Not all datapoints in f were cleared')

assert(all(size(full_structure.f) == [1, datapoints]), ...
       'size of f has changed');