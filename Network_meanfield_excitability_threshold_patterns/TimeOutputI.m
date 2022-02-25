% Plot time output of the inhibitory population

function status = TimeOutputI(t,u,flag,plotSol,x,p,parent,idx) 
  
%   arrange = u(idx(:,1));
%   u(idx(:,1)) = u(idx(:,2));
%   u(idx(:,2)) = u(idx(:,3));
%   u(idx(:,3)) = [];
%   idx = idx(:,2:3);

  nx = size(idx,1);
  
  if isempty(flag)
    disp(['t = ' num2str(max(t))]);
    if plotSol
      % PlotSolution(x,u(:,end),p,parent,idx,false);
      u = [u(:,end); FiringRateE(u(idx(:,1),end),u(idx(:,2),end),u(idx(:,3),end),p(3),p(5),p(9),p(11))];
      PlotSolution(x,u,p,parent,[idx(:, [2 3]) [2*nx+1:3*nx]'],false);
      drawnow;
    end
  end
  status = 0;

end
