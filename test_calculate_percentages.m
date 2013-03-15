function test_calculate_percentages


epsilon = 1e-10;

% Create necessary data structures
mlist = [0 0.2 0.5 1];
Rlist = [1 10 0.1];

for geom.m = mlist
  for geom.R = Rlist
    material.lambda_e = 0.01;

    geom.NumPoints = 5;

    geom.theta = linspace(0,2*pi, geom.NumPoints+1);
    geom.theta = geom.theta(1:geom.NumPoints);

    displacement.total = [1+i; -1;  -i; 2-i; 0];
    cohesive.loading = [1; 1; 0; 1; 0];
    cohesive.lambda_max = [0.001; 1.2; 0; 0.3; 0.5];

    percentage = calculate_percentages(geom, material, cohesive, ...
                                       displacement);
    
    undamage_compare = 2/5*100;
    damage_compare = 2/5*100;
    fail_compare = 1/5*100;
    unloading_compare = 2/5*100;
    compression_compare = 1/5*100;
    
    assert(allequal(percentage.undamaged(1), undamage_compare, epsilon), ...
           'Undamaged percentage is incorrect');
    
    assert(allequal(percentage.damaged(1), damage_compare, epsilon), ...
           'Damaged percentage is incorrect');

    assert(allequal(percentage.failed(1), fail_compare, epsilon), ...
           'Failed percentage is incorrect');

    assert(allequal(percentage.unloading(1), unloading_compare, epsilon), ...
           'Unloading percentage is incorrect');

    assert(allequal(percentage.compression(1), compression_compare, epsilon), ...
           'Compression percentage is incorrect');
    
    if geom.m == 0
      for f = fieldnames(percentage)
        item = percentage.(f{1});
        assert(allequal(item(1), item(2), epsilon), ...
               ['For a circle, percentage of interpolation points and ' ...
                'percentage of total length do not match']);
      end
    end
  
    
  end
end


  
  