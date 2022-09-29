clearvars; close all; clc;

% % Fat-Tailed Distro

rng(22)

%% Small Sample
N = 50;
pd = makedist('Generalized Pareto',2,5,1);
x = random(pd,N,1);

E = zeros(20000,3);
for k=1:20000
    E(k,1) = histent(x,k);
    E(k,2) = qent(x,k);
end
% parfor k=1:N-1
%     E(k,3) = knn1D(x,k);
% end
KNN = knn1D(x,4);


fig = figure('units','centimeters','position',[30,10,11,8]);

plot(E(1:50,1),'-b','MarkerSize',2,'LineWidth',1.25)
hold on
plot(E(1:50,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.25)
plot(KNN*ones(N,1),'--r','MarkerSize',2,'LineWidth',1.25)
%plot(E(1:end-1,3),'-r','MarkerSize',2,'LineWidth',1.5)
grid on
xlim([0 50])
xticks([0 10 20 30 40 50])
ylim([0 5.5])
yticks([0 1 2 3 4 5])
xlabel('k','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title("Pareto Distribution",'interpreter', 'latex')
legend('Histogram','Quantile','$H_4^{NN}$','Location','southeast','interpreter', 'latex')
set(gca,"FontSize",11)
pbaspect([1.1 1 1])

%% Dataset
fig = figure('units','centimeters','position',[30,10,3,8]);

% plot(zeros(size(x)),x,'.k','MarkerSize',10);
ptr = scatter(zeros(size(x)),x,'ok','MarkerFaceColor','k','MarkerEdgeColor','none');
ptr.MarkerFaceAlpha = 0.2;
ax = gca;
ax.YAxisLocation = 'right';
ylabel('Dataset','interpreter', 'latex')
xlim([-0.5 0.5])
xticks([])
box off
% yticks([0 600 1200])
pbaspect([1 8 1])
set(gca,"FontSize",11)


%% Inset

fig = figure('units','centimeters','position',[30,10,3,2]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.5)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.5)
plot(KNN*ones(20000,1),'--r','MarkerSize',2,'LineWidth',1.25)
xlim([0 20000])
xticks([0 20000])
% yticks([0 1 2])
set(gca,"FontSize",7)
set(gcf, 'color', 'none');   
% set(gca, 'color', 'none');
pbaspect([1.5 1 1])



