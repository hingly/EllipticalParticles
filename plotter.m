function plotter


c1list = [50];
c2list = [100];
strainlist = [0.001 0.002 0.005 0.01];



strain = 0.01;
c1 = 50;
c2 = 100;
aspectratio = 5;

Numfiles = 201;
for ii = 1:Numfiles
  
  filename = strcat(['Guess/ellipse/uniaxial/guess_' num2str(ii) '_strain_' ...
                      num2str(strain*1000) '_c1_' num2str(c1) ...
                      '_c2_' num2str(c2) '_ar_' ...
                      num2str(aspectratio) '_postprocess.json']);
  
  
  data = loadjson(filename);
  data.post.scale = 10;
  ii
  if data.guess_test.exitflag == 1
    if ii == 1
      plot_geom(data);
    else
      plot_deformed(data);
    end
  end
end

