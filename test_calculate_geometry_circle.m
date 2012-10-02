function test_calculate_geometry_circle

epsilon=1e-10;

numpointslist=[10 200 114];
alist=[10 90e-3];
for numpoints = numpointslist
  for a = alist
    geom.NumPoints=numpoints;
    geom.a=a;
    geom.b=geom.a;
  
    geom=calculate_geometry(geom);
    
    Rcheck=a;
    mcheck=0;
    
    assert(almostequal(Rcheck, geom.R, epsilon), ...
           ['R did not equal a for numpoints =' ...
            num2str(numpoints) ' and a = ' num2str(a)]);

    assert(almostequal(mcheck, geom.m, epsilon), ...
           ['m did not equal 0 for numpoints =' ...
            num2str(numpoints) ' and a = ' num2str(a)]);
    
    assert(almostequal(geom.theta, geom.beta, epsilon), ...
           'theta and beta should be equal for a circle');
    
    radius = sqrt(real(geom.ellipse).^2 + imag(geom.ellipse).^2);

    assert(almostequal(radius,geom.a,epsilon), ...
           ['radius did not equal a for numpoints =' ...
            num2str(numpoints) ' and a = ' num2str(a)]);
    assert(almostequal(radius,geom.b,epsilon), ...
           ['radius did not equal b for numpoints =' ...
            num2str(numpoints) ' and a = ' num2str(a)]);
    
    normalx=cos(geom.theta);
    normaly=sin(geom.theta);
    normalcheck=(normalx+i*normaly);
    
    assert(almostequal(normalcheck, geom.normal,epsilon),...
           ['normals did not match for numpoints = '...
            num2str(numpoints) ' and a = ' num2str(a)]);
                          
  end
end



