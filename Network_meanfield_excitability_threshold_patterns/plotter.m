clear all, close all, clc;

dataPath = './Data/';
% dataPath = './TCWithHead_sigma_0.2/';

files = dir([dataPath 'history*.mat']);

blue = [0 0.4470 0.7410];
red  = [0.8500 0.3250 0.0980];
darkred = [0.6350 0.0780 0.1840];
grey  = [0.6 0.6 0.6];
green = [0.4660 0.6740 0.1880];

nE = 200; nI = 200;
idE = 1:nE; idI = nE+[1:nI]; idZ = nE+nI+1;
tStep = .0025;

numTraces = 0;
idTrace = randi(nE,numTraces,1);

% chunks = length(files)-50:length(files);
chunks = 1:length(files);


figure, hold on;
if numTraces > 0
  for k = chunks

    sol = load([dataPath files(k).name]);

    for l = 1:numTraces
      % scat = scatter(sol.UHist(:,nE+idTrace(l)),...
      scat = scatter(sol.UHist(:,nE+nI+1),...
		      sol.UHist(:,idTrace(l)),...
		      10,...
		      'filled','MarkerFaceColor',grey,'MarkerEdgeColor',grey);
      scat.MarkerFaceAlpha = .1;
      scat.MarkerEdgeAlpha = .1;
    end
    drawnow;

  end
end
for k = chunks

  sol = load([dataPath files(k).name]);
  % plot(sol.UAvg(:,2),sol.UAvg(:,1),'LineWidth',2,'Color',blue); 
  plot(sol.UAvg(:,3),sol.UAvg(:,1),'LineWidth',1,'Color','black');
  axis([-6.5 -5.0 0 1.9]);
  drawnow;
  % pause(0.5);
end
box on;
% xlim([0 4.5]);
ylabel('uE'); zlabel('z');


hold off;



figure, hold on;

lchunk = length(sol.UAvg(:,1));

if numTraces > 0
  for k = chunks

    sol = load([dataPath files(k).name]);

    for l = 1:numTraces
      % scat = scatter(sol.UHist(:,nE+idTrace(l)),...
      scat = scatter(sol.UHist(:,nE+nI+1),...
		      sol.UHist(:,idTrace(l)),...
		      10,...
		      'filled','MarkerFaceColor',grey,'MarkerEdgeColor',grey);
      scat.MarkerFaceAlpha = .1;
      scat.MarkerEdgeAlpha = .1;
    end
    drawnow;

  end
end
for k = chunks

  sol = load([dataPath files(k).name]);
  % plot(sol.UAvg(:,2),sol.UAvg(:,1),'LineWidth',2,'Color',blue); 
  plot(linspace((k-1)*lchunk*tStep, (k-1)*lchunk*tStep + lchunk*tStep, lchunk),sol.UAvg(:,1),'LineWidth',1,'Color','black');
  axis([0 80 0 1.9])
  drawnow;
  % pause(0.5);
end
box on;
% xlim([0 4.5]);
ylabel('uE'); zlabel('t');


hold off;
