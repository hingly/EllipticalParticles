function test_read_txt()

c = {'1', '2as', '3'};

temp = tmpnam;
write_txt(temp, c);
readc = read_txt(temp);
delete(temp);

assert(all(cellfun(@(a, b) strcmp(a, b), c, readc)),...
       'Wrote to a file but didn''t read back the same')
