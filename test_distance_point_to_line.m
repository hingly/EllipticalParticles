function test_distance_point_to_line
  
  epsilon=0.1;
  
  % Point on line
  
  d = distance_point_to_line([2.1,2], [0,0], [1,1]);
  assert(almostequal(d,0,epsilon), ...
         'Point on radial line is giving non-zero distance');
  
  d = distance_point_to_line([2,-1.1], [0,1], [1,0]);
  assert(almostequal(d,0,epsilon), ...
         'Point on negative line is giving non-zero distance');
 
  d = distance_point_to_line([1.15,25], [1.1,0], [1.1,1]);
  assert(almostequal(d,0,epsilon), ...
         'Point on horizontal line is giving non-zero distance');  
  
  d = distance_point_to_line([-3,-1.1], [0,-1.2], [7,-1.2]);
  assert(almostequal(d,0,epsilon), ...
         'Point on vertical line is giving non-zero distance');  
  
  %Point not on line
  d = distance_point_to_line([3,2], [0,0], [1,1]);
  assert(~almostequal(d,0,epsilon), ...
         'Point not on radial line is giving zero distance');
  
  d = distance_point_to_line([2,0], [0,1], [1,0]);
  assert(~almostequal(d,0,epsilon), ...
         'Point not on negative line is giving non-zero distance');
 
  d = distance_point_to_line([-1,0], [1.1,0], [1.1,1]);
  assert(~almostequal(d,0,epsilon), ...
         'Point not on horizontal line is giving non-zero distance');  
   
  d = distance_point_to_line([-3,0], [0,-1.2], [7,-1.2]);
  assert(~almostequal(d,0,epsilon), ...
         'Point not on vertical line is giving non-zero distance');  
 
  

  
