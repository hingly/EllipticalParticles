function teststructproduct()

s = structproduct(struct(), 'a.b', [1, 2], 'b', [4, 5]);

assert(length(s) == 4);
assert(s(1).a.b = 1);
assert(s(1).b = 4);
assert(s(2).a.b = 1);
assert(s(2).b = 5);
assert(s(3).a.b = 2);
assert(s(3).b = 1);
assert(s(4).a.b = 2);
assert(s(4).b = 5);