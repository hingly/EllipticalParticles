function testproduct()

a = product([1, 2], [3, 4]);

assert(allequal(a(:)', [1, 1, 2, 2, 3, 4, 3, 4], 0.01));