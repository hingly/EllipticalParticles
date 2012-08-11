function test_calculate_geometry_ellipse

epsilon=1e-10;

numpointslist=[13 200 111];
alist=[10 90e-3];
for numpoints = numpointslist
  for a = alist
    geom.NumPoints=numpoints;
    geom.a=a;
    geom.b=geom.a;
  
    geom=calculate_geometry(geom);

    assert(almostequal(geom.theta, geom.beta, epsilon),...
           'theta and beta should be equal for a circle');
    
    assert(almostequal(geom.theta, geom.alpha, epsilon), ...
           'theta and alpha should be equal for a circle');
    
    radius = sqrt(geom.ellipse(1,:).^2 + geom.ellipse(2,:).^2);

    assert(almostequal(radius,geom.a,epsilon),...
           ['radius did not equal a for numpoints =' ...
            num2str(numpoints) ' and a = ' num2str(a)])
    assert(almostequal(radius,geom.b,epsilon),...
           ['radius did not equal b for numpoints =' ...
            num2str(numpoints) ' and a = ' num2str(a)])
    
    normalx=geom.b*cos(geom.theta);
    normaly=geom.a*sin(geom.theta);
    normsize=sqrt(normalx.^2+normaly.^2);
    normalcheck=(normalx+i*normaly)./normsize;
    
    assert(almostequal(normalcheck, geom.normal,epsilon),...
           ['normals did not match for numpoints = '...
            num2str(numpoints) ' and a = ' num2str(a)]);
                          
  end
end

