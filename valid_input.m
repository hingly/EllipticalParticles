function r = valid_input(inputstructure)

r = true;

% NumModes can't be bigger than 1/2 * NumPoints
r = r & inputstructure.loads.NumModes <= inputstructure.geom.NumPoints/2;
