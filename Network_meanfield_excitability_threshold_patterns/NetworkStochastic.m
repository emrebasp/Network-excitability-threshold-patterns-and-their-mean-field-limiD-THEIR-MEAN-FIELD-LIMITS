function F = NetworkStochastic(u,p,n,xiE,xiI)

  %% Rename parameter
  k      = p(1);
  epsE   = p(2);   
  epsI   = p(3);   
  epsZ   = p(4);    
  JEE    = p(5);    
  JIE    = p(6);    
  JEI    = p(7);   
  JII    = p(8);   
  zI     = p(9);   
  gE     = p(10);
  gI     = p(11); 
  rhoE   = p(12);
  rhoI   = p(13);

  %% Split components
  nE  = n(1); nI = n(2); 
  idE = 1:nE; idI = nE+[1:nI]; idZ = nE+nI+1;
  uE  = u(idE); uI  = u(idI); z = u(idZ); 

  %% Ancillary functions
  SE = @(x) rhoE/2*(1+erf(gE*x/sqrt(2)));
  SI = @(x) rhoI/2*(1+erf(gI*x/sqrt(2)));

  %% Averages 
  uEAvg = sum(uE)/nE;
  uIAvg = sum(uI)/nI;

  %% Compoose right-hand side
  F = zeros(size(u));
  
  F(idE) = epsE* ( -uE + SE(JEE*uEAvg + JEI*uIAvg + z  + xiE) );
  F(idI) = epsI* ( -uI + SI(JIE*uEAvg + JII*uIAvg + zI + xiI) ); 
  F(idZ) = epsZ* ( k - uEAvg - uIAvg );

end
