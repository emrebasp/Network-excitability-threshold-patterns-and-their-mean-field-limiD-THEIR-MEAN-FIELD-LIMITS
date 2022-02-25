%% Cleaning
clear all, close all, clc;

%% Number of neurons
nE = 10000; nI = 10000;
idE = 1:nE; idI = nE+[1:nI]; idZ = nE+nI+1;

%% Initial condition and seed
sol = load('initialConditionPeriodicOrbit_k_1.4.mat');
u0 = sol.u; p = sol.p;

rng('default');
sigmaE = p(14); sigmaI = p(15);
xi0 = [normrnd(0,sigmaE^2/2,[nE,1]); normrnd(0,sigmaI^2/2,[nI,1]) ];

%% Time simulation
stepperList.t0       = 0;
stepperList.timeStep = 0.001;
stepperList.nSteps   = 100000;
stepperList.saveHist = true;
stepperList.nSave    = 10;
stepperList.nPrint   = 1000;
stepperList.dataFile = 'history.mat';

%% Run
[t,UFinal,xiFinal] = EulerOU(u0,xi0,p,[nE nI],stepperList);

sol = load('history.mat');
figure;
plot(sol.UAvg(:,3),sol.UAvg(:,1));

