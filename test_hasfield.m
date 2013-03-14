function test_hasfield

structure = struct('a', 1, 'b', 2);

assert(hasfield(structure, 'a'));
assert(~hasfield(structure, 'c'));