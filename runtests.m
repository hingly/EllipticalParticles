function runtests

allfiles = dir('*.m');
startswith = @(long, short) strncmp(long, short, length(short));
inlist = @(str, list) cellfun(@(s) any(strcmp(s, list)), str);
blacklist = read_txt('do_not_test.txt');
names = {allfiles.name};
nontestfiles = allfiles(~startswith(names, 'test_') & ...
                        ~inlist(names, blacklist));

filetests = 0;
tests = 0;
notests = 0;
failed = 0;
passed = 0;

for f = nontestfiles'
    shortname = f.name(1:end-2);
    printf('-- %s', f.name)
    testfiles = allfiles(startswith({allfiles.name}, ['test_' shortname]));
    if isempty(testfiles)
        notests = notests + 1;
        printf(' No tests!\n')
    else
        printf(':\n')
        filetests = filetests + 1;
        for test = reshape(testfiles, 1, length(testfiles))
            tests = tests + 1;
            printf('  %s... ', test.name)
            try
                eval(test.name(1:end-2));
                disp('succeeded.')
                passed = passed + 1;
            catch
                disp('failed!')
                disp(lasterr)
                failed = failed + 1;
            end    
        end
    end
    disp('')
end

fprintf('Out of %i files, %i had tests.\n', ...
        length(nontestfiles), filetests);
fprintf('%i out of the %i total tests run, succeeded (%.0f %%)\n',...
        passed, tests, passed/tests*100);