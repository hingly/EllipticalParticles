function test_write_txt()

c = {'1', '2', '3'};
temp = tmpnam;
write_txt(temp, c);
test_c = load('-ascii', temp);
delete(temp);
assert(all(test_c == [1, 2, 3]'), 'File write didn''t work');


