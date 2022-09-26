clearvars; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%See circulargraph-master for graphs
%  Some mild changes were made to the original 
%   to highlight isolated nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmap = copper(40);
cmap = cmap(7:31,:);

k = 25;

% Create Logistic Data
x = 0.1;
for nn=1:99
    x = [x; 4*x(end).*(1-x(end))];
end
[E, Edges] = histent(x, k);
Eh = Edges;
L = discretize(x,Edges);

W = zeros(k);
for i=1:length(L)-1
    W(L(i),L(i+1)) = W(L(i),L(i+1))+1;
end
WH = W;
circularGraph(WH, 'ColorMap', cmap)

pause

W = zeros(size(W));
[E, Edges] = qent(x, k);
Eq = Edges;
L = discretize(x,Edges);
W = zeros(k);
for i=1:length(L)-1
    W(L(i),L(i+1)) = W(L(i),L(i+1))+1;
end
WQ = W;
circularGraph(WQ, 'ColorMap', cmap)

save('ToPythonPlot_k=25.mat','WH','WQ')

%% Data Set
fig = figure('units','centimeters','position',[30,15,20,5]);

ptr = scatter(x,ones(size(x)),75,'ok','MarkerFaceColor','k','MarkerEdgeColor','none');
ptr.MarkerFaceAlpha = 0.2;
hold on
for i=1:length(Eh)
    plot([Eh(i) Eh(i)], [0.75 0.95],'Color','b','LineWidth',1.5)
    plot([Eq(i) Eq(i)], [1.05 1.25],'Color','#EDB120','LineWidth',1.5)
end
xlim([0 1])
xticks([0 1])
box off
%ylim([-0.5 0.5])
yticks([])
pbaspect([10 1 1])
legend({'Data Sample','Histogram','Quantile'},'Orientation','horizontal','interpreter', 'latex');
set(gca,"FontSize",16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%See python code for Fig04.py for matrices
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fig = figure('units','centimeters','position',[30,15,5,8]);
% 
% h = plot(digraph(WH),'Layout','circle');
% title("Histogram")
% 
% ix = find(~sum(WH,2));
% highlight(h,ix,'NodeColor','r')
% pbaspect([1 1 1])
% title("Histogram",'interpreter', 'latex')
% set(gcf, 'color', 'none');
% set(gca, 'color', 'none');
% set(gca,"FontSize",9)
% box off
% axis off
% 
% 
% fig = figure('units','centimeters','position',[30,15,5,8]);
% 
% plot(digraph(WQ),'Layout','circle')
% title("Quantile")
% 
% ix = find(~sum(WQ,2));
% highlight(h,ix,'NodeColor','r')
% pbaspect([1 1 1])
% title("Quantile",'interpreter', 'latex')
% set(gcf, 'color', 'none');
% set(gca, 'color', 'none');
% set(gca,"FontSize",9)
% box off
% axis off
% 
% 
% fig = figure('units','centimeters','position',[30,15,5,8]);
% 
% spy(WH,'hb',4)
% xlabel("")
% set(gca,"FontSize",9)
% % See Python Code
% 
% fig = figure('units','centimeters','position',[30,15,5,8]);
% 
% spy(WQ,'hb',4)
% xlabel("")
% set(gca,"FontSize",9)
% 
