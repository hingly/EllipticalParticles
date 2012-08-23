function test_points_to_lines
  
  a = 0.1;
  b = 1;
  c = 1;
  % Definition of lines
  linexs = [0 a (a+b)/2 (a+b)/4 (a+b)/2 1 1.2];
  lineys = [0 c c/2 c/4 c/2 0 0];
  
  % Check vertices
  xs = [0 a (a+b)/2 (a+b)/4 (a+b)/2 1 1.2];
  ys = [0 c c/2 c/4 c/2 0 0];
  distances = points_to_lines(xs, ys, linexs, lineys);
  assert(almostequal(distances,0,1e-10), ...
         'Vertices are claiming not to be on lines');
  
  % Check if I give no points
  xs = [];
  ys = [];
  distances = points_to_lines(xs, ys, linexs, lineys);
  assert(isempty(distances), ...
      'Should return null set');
 
  % Check if I give one point on line
  xs = [a/2];
  ys = [c/2];
  distances = points_to_lines(xs, ys, linexs, lineys);
  assert(almostequal(distances,0,1e-10), ...
         'Point is not on line');
   
  % Points not on lines
  xs = [0 a];
  ys = [-1 c/2];
  distances = points_to_lines(xs, ys, linexs, lineys);
  assert(~almostequal(distances,0,1e-10), ...
         'Points should say they are not on lines');
  
  
