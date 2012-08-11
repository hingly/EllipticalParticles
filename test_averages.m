function test_averages

epsilon=1e-10;

% --- dispxy is the displacement of the points on the interface in x,y coords, vector length NumPoints
% --- Tcohxy is the cohesive traction in x,y coords, vector length NumPoints
% --- geom is a structure containing geometric data

numpointslist=[13 200 111];
a=10;
blist=[0.1 0.5 1 2 5 8];
scalelist=[1 1e-3];


for numpoints = numpointslist
  for b = blist
    for scale = scalelist
      geom.NumPoints = numpoints;
      geom.b = b*scale;
      geom.a = a*scale;
      geom=calculate_geometry(geom);

      dispxy=geom.ellipse;
      Tcohxy=zeros(1,geom.NumPoints);

      [sigmap, epsint] = averages(dispxy, Tcohxy, geom);

      epsintcheck = [1 1 0];
      assert(almostequal(epsint,epsintcheck,epsilon),'failed at epsint');

      sigmapcheck=zeros(1,3);
      assert(almostequal(sigmap,sigmapcheck,epsilon),'failed at sigmap');
      
    end
  end
end
