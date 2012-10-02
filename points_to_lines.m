function outdistances = points_to_lines(xs, ys, linexs, lineys)
  assert(length(xs) == length(ys),...
         'xs and ys are not the same length');
  assert(length(linexs) == length(lineys),...
         'linexs and lineys are not the same length');
  assert(length(linexs) >= 2, ...
         'linexs and lineys are not long enough to define a line');
  
  
  distances = inf(size(xs));
  
  for i = 1:length(xs)
    for jj = 1:length(lineys)-1
      distances(i) = min(distances(i), ...
                         distance_point_to_line([xs(i) ys(i)], ...
                                                [linexs(jj) lineys(jj)], ...
                                                [linexs(jj+1) lineys(jj+1)]));
    end
  end
  
  if nargout > 0
    outdistances = distances;
  else
    plot(xs, ys, 'x', linexs, lineys, '-');
  end

  
  
