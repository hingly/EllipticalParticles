function test_calculate_geometry_ellipse

epsilon=1e-10;

numpointslist=[10 200 114];
geom.a=10;
blist=[0.1 0.5 1 2 5 8];
Rcheck=[5.05 5.25 5.5 6 7.5 9];
mcheck=[99/101 19/21 9/11 2/3 1/3 1/9];

for numpoints = numpointslist
  for kk = 1:size(blist)
    geom.NumPoints = numpoints;
    geom.b = blist(kk);
    geom=calculate_geometry(geom);
       
    assert(almostequal(Rcheck(kk),geom.R,epsilon));
    assert(almostequal(mcheck(kk),geom.m,epsilon));  
    radius = (real(geom.ellipse)./geom.a).^2 + (imag(geom.ellipse)./geom.b).^2;
    
    assert(almostequal(radius,1,epsilon),...
           ['ellipseradius did not equal 1 for numpoints =' ...
            num2str(numpoints) ' a = ' num2str(geom.a) ' and b = ' num2str(geom.b)])
    
    normalx=geom.b*cos(geom.theta);
    normaly=geom.a*sin(geom.theta);
    normsize=sqrt(normalx.^2+normaly.^2);
    normalcheck=(normalx+i*normaly)./normsize;
    
    assert(almostequal(normalcheck, geom.normal,epsilon),...
           ['normals did not match for numpoints = '...
            num2str(numpoints) ' and a = ' num2str(geom.a)]);
  end                       
end

