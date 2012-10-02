function test_calculate_imposed_stress

% Input data
epsilon = 1e-10;
loads.SigmaBar1 = 1;
Ratiolist = [0 0.5 1 2 -0.5 -1 -2];


% Case when AppliedLoadAngle = 0 or pi
anglelist = [0 pi];

for loads.AppliedLoadAngle = anglelist
  for loads.SigmaBarRatio = Ratiolist
    
    loads = calculate_imposed_stress(loads);
    
    Sigbarxy_check = [1 loads.SigmaBarRatio 0];
    assert(allequal(Sigbarxy_check, loads.SigBar_xy, epsilon), ...
           ['loads.SigBar_xy is incorrect for omega = '  ...
            num2str(loads.AppliedLoadAngle) ...
            ' and ratio = ' num2str(loads.SigmaBarRatio)]); 

    assert(allequal(loads.StressRatio_22, loads.SigmaBarRatio, epsilon), ...
           ['loads.StressRatio_22 is incorrect for omega = '  ...
            num2str(loads.AppliedLoadAngle) ...
            ' and ratio = ' num2str(loads.SigmaBarRatio)]); 
    
    assert(allequal(loads.StressRatio_12, 0, epsilon), ...
           ['loads.StressRatio_12 is incorrect for omega = '  ...
            num2str(loads.AppliedLoadAngle) ...
            ' and ratio = ' num2str(loads.SigmaBarRatio)]); 
  end  
end


% Case when AppliedLoadAngle = pi/2 or -pi/2

anglelist = [pi/2 -pi/2];

for loads.AppliedLoadAngle = anglelist
  for loads.SigmaBarRatio = Ratiolist
    
    loads = calculate_imposed_stress(loads);
    
    Sigbarxy_check = [loads.SigmaBarRatio 1 0];
    assert(allequal(Sigbarxy_check, loads.SigBar_xy, epsilon), ...
           ['loads.SigBar_xy is incorrect for omega = 0 and ratio = ' ...
            num2str(loads.SigmaBarRatio)]);

    if loads.SigmaBarRatio > epsilon
      assert(allequal(loads.StressRatio_22, 1/loads.SigmaBarRatio, epsilon), ...
             ['loads.StressRatio_22 is incorrect for omega = '  ...
              num2str(loads.AppliedLoadAngle) ...
              ' and ratio = ' num2str(loads.SigmaBarRatio)]);  
      
      assert(allequal(loads.StressRatio_12, 0, epsilon), ...
             ['loads.StressRatio_12 is incorrect for omega = '  ...
              num2str(loads.AppliedLoadAngle) ...
              ' and ratio = ' num2str(loads.SigmaBarRatio)]); 
    else
      assert(allequal(loads.StressRatio_12_22, 0, epsilon), ...
             ['loads.StressRatio_12_22 is incorrect for omega = '  ...
              num2str(loads.AppliedLoadAngle) ...
              ' and ratio = ' num2str(loads.SigmaBarRatio)]); 
    end
  end 
end



% Case when AppliedLoadAngle = pi/4 or -3*pi/4

anglelist = [pi/4 -3*pi/4];

for loads.AppliedLoadAngle = anglelist
  for loads.SigmaBarRatio = Ratiolist
    
    loads = calculate_imposed_stress(loads);

    
    % This is not finished!  Still need checks for this case!
    
    Sigbarxy_check = [loads.SigmaBarRatio 1 0];
    assert(allequal(Sigbarxy_check, loads.SigBar_xy, epsilon), ...
           ['loads.SigBar_xy is incorrect for omega = 0 and ratio = ' ...
            num2str(loads.SigmaBarRatio)]);

    if loads.SigmaBarRatio > epsilon
      assert(allequal(loads.StressRatio_22, 1/loads.SigmaBarRatio, epsilon), ...
             ['loads.StressRatio_22 is incorrect for omega = '  ...
              num2str(loads.AppliedLoadAngle) ...
              ' and ratio = ' num2str(loads.SigmaBarRatio)]);  
      
      assert(allequal(loads.StressRatio_12, 0, epsilon), ...
             ['loads.StressRatio_12 is incorrect for omega = '  ...
              num2str(loads.AppliedLoadAngle) ...
              ' and ratio = ' num2str(loads.SigmaBarRatio)]); 
    else
      assert(allequal(loads.StressRatio_12_22, 0, epsilon), ...
             ['loads.StressRatio_12_22 is incorrect for omega = '  ...
              num2str(loads.AppliedLoadAngle) ...
              ' and ratio = ' num2str(loads.SigmaBarRatio)]); 
    end
  end 
end





