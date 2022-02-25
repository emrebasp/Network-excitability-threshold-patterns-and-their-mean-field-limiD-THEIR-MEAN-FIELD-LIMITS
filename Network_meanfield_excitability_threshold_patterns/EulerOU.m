function [tFinal,UFinal,xiFinal] = EulerOU(U0,xi0,p,n,stepperList)

  t0       = stepperList.t0;
  h        = stepperList.timeStep;
  nSteps   = stepperList.nSteps;
  saveHist = stepperList.saveHist;
  nSave    = stepperList.nSave;
  nPrint   = stepperList.nPrint;
  dataFile = stepperList.dataFile;
  theta  = stepperList.thetaP;


  %% Reproducibility
  % rng('default');

  %% Component indices
  nE  = n(1); nI = n(2); 
  idE = 1:nE; idI = nE+[1:nI]; idZ = nE+nI+1;
  xiE = xi0(idE); xiI = xi0(idI);

  %% Rename parameters
  sigmaE = p(14);
  sigmaI = p(15);
 

  %% Prepare output
  nOut = floor(nSteps/nSave);
  t = zeros(nOut+1,1); UAvg = zeros(nOut+1,3); UHist = zeros(nOut+1,nE+nI+1);

  %% Saving counter
  iSave = 1;

  %% Initalisation output data
  t(iSave) = t0; U = U0;
  UHist(iSave,:) = U';
  UAvg(iSave,:) = [mean(U(idE)), mean(U(idI)), U(idZ)];

  %% Time steps
  for i = 1:nSteps

    %% Generate increments
    vE =  normrnd(0,sigmaE/sqrt(2*theta),[nE,1]);
    vI =  normrnd(0,sigmaI/sqrt(2*theta),[nI,1]);    

    xiE = vE;
    xiI = vI;
    
    %% Euler step
    U = U + h*( NetworkStochastic(U,p,n,xiE,xiI) );

    if mod(i,nPrint) == 0
      %% Book keeping
      disp(sprintf('t = %f',t0+i*h));
    end

    %% Store if required
    if saveHist && mod(i,nSave) == 0

      iSave = iSave +1; t(iSave) = t0 + i*h;
      UHist(iSave,:) = U';
      UAvg(iSave,:) = [mean(U(idE)), mean(U(idI)), U(idZ)];

    end

  end

  %% Store final values
  tFinal = t(end); UFinal = U; xiFinal = [xiE; xiI]; 

  %% Save if required
  if saveHist
    disp('Saving...');
    save(dataFile,'t','UHist','UAvg',...
                  'p','nE','nI',...
		  'tFinal','UFinal','xiFinal');
  end

  disp('Completed');

end
