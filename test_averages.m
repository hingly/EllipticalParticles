function test_averages

epsilon=1e-10;

% --- dispxy is the displacement of the points on the interface in x,y coords, vector length NumPoints
% --- Tcohxy is the cohesive traction in x,y coords, vector length NumPoints
% --- geom is a structure containing geometric data

% Note: we know the integration fails for odd numpoints
% (for numpoints less than 1501 with epsilon=1e-10).
numpointslist=[200 14 112];
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

      %-----------------------
      % Case 1: Identity
      %----------------------
      
      dispxy=geom.ellipse;
      Tcohxy=geom.normal;

      [sigmap, epsint] = averages(dispxy, Tcohxy, geom);

      % With dispxy=x, epsint must return identity
      epsintcheck = [1 1 0];
      assert(almostequal(epsint,epsintcheck,epsilon),'failed at epsint');

      % With Tcohxy=normal, sigmap must return identity
      sigmapcheck=[1 1 0];
      assert(almostequal(sigmap,sigmapcheck,epsilon),'failed at sigmap');
      
      %----------------------
      % Case 2: Zero
      %----------------------
      
      dispxy=ones(1,geom.NumPoints);
      dispxy=(1+i*1)*dispxy;
      Tcohxy=ones(1,geom.NumPoints);
      Tcohxy=(1+i*1)*Tcohxy;
      
      [sigmap, epsint] = averages(dispxy, Tcohxy, geom);
      
      % With dispxy=1, epsint must return zero
      epsintcheck=[0 0 0];
      assert(almostequal(epsint,epsintcheck,epsilon),'failed at epsint');
       
      % With Tcohxy=1, sigmap must return zero
      sigmapcheck=[0 0 0];
      %assert(almostequal(sigmap,sigmapcheck,epsilon),'failed at sigmap');
     
      
      
      
    end
  end
end
