%% Cleaning
clear all, close all, clc;
!rm -rf Data && mkdir Data;

%% Number of neurons
nOfNeurons = input('Enter the number of neurons for each population: ');
nE = nOfNeurons; nI = nOfNeurons;
idE = 1:nE; idI = nE+[1:nI]; idZ = nE+nI+1;

%% Initial conditions and the parameter set for the torus

coffee = 0;
while ~coffee
  typeIndex = input('Chooose torus type --> 1 for headless, 2 for with head, 3 for headless mixed-type, 4 for mixed-type with head: ');
  if ~ismember(typeIndex, [1, 2, 3, 4])
    fprintf('Error! Must enter a valid number (1,2,3 or 4).\n');
    coffee = 0;
  else
    fprintf('You entered: %d\n', typeIndex);  
    coffee = 1;
  end
end

 % Set the initial conditions

if typeIndex == 1 || typeIndex == 2
  % Initial conditions for classical torus types
  u0 = 0.4251189385238183 * ones(nE+nI+1,1); 
  u0(nE+1:end) = 0.7867928556889544;
  u0(end)= -5.438424304728502 ; 
elseif typeIndex == 3 || typeIndex == 4
  % Initial conditions for mixed torus types
  u0 = 1.531292166717386 * ones(nE+nI+1,1); 
  u0(nE+1:end) = 2.231666931670675;
  u0(end)= -5.568154300986497;
end

% Set the corresponding parameter set

if typeIndex==1
  parameters = load('parametersHeadless.mat');   % parameters for headless torus
elseif typeIndex==2
  parameters = load('parametersWithHead.mat'); % parameters for torus with head
elseif typeIndex==3  
  parameters = load('parametersHeadlessMixed.mat');   % parameters for mixed type headless torus
elseif typeIndex==4  
  parameters = load('parametersMixedWithHead.mat');   % parameters for mixed type torus with head
end

p = parameters.par;

%% Time simulation
stepperList.t0       = 0;
stepperList.timeStep = .00025;
% stepperList.timeStep = .00025;
stepperList.nSteps   = 10000;
stepperList.saveHist = true;
stepperList.nSave    = 500;
stepperList.nPrint   = 5000;
stepperList.thetaP = 0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% For higher noise particle examples %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default values for p(14) and p(15): 1.02
% p(14) = 2.5; p(15) = 2.5;
p(14) = 2.5; p(15) = 2.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initial noise
rng('default');
sigmaE = p(14); sigmaI = p(15); % Rename parameters: standard deviation of the noise terms of both population

theta = stepperList.thetaP; % Rename parameter: drift coefficient in the Ornstein-Uhlenbeck process

xi0 = [normrnd(0,sigmaE/sqrt(2*theta),[nE,1]); normrnd(0,sigmaI/sqrt(2*theta),[nI,1]) ];


%% Run
for k = 1:6000
  stepperList.dataFile = sprintf('./Data/history_%07i.mat',k);
  [tEnd,uEnd,xiEnd] = EulerOU(u0,xi0,p,[nE nI],stepperList);
  stepperList.t0  = tEnd;
  xi0 = xiEnd;
  u0  = uEnd;
end
