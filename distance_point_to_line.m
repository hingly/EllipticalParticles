function d = distance_point_to_line(pt, v1, v2)

%In this function, pt, v1, and v2 are the three-dimensional
% coordinates of the point, one vertex on the line, and a second
% vertex on the line, respectively. The following example illustrates
% how this function would be called:
%v1 = [0,0,0];
%v2 = [3,0,0];
%pt = [0,5,0];
%distance = point_to_line(pt,v1,v2)

%http://www.mathworks.com/support/solutions/en/data/1-1BYSR/index.html?product=ML&solution=1-1BYSR
  if length(pt)~=3
    pt=[pt 0];
  end
  
  if length(v1)~=3
    v1=[v1 0];
  end
  
  if length(v2)~=3
    v2=[v2 0];
  end
  
  assert(length(pt)==3, 'pt must be entered as 2 or 3 dimensional');
  assert(length(v1)==3, 'v1 must be entered as 2 or 3 dimensional');
  assert(length(v2)==3, 'v2 must be entered as 2 or 3 dimensional');
  
  
  
  a = v1 - v2;
  b = pt - v2;
  d = norm(cross(a,b)) / norm(a);