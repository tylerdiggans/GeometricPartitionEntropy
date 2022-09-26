clearvars; close all; clc;

% % Fat-Tailed Distro

rng(22)

%% Small Sample
N = 50;
pd = makedist('Generalized Pareto',2,5,1);
x = random(pd,N,1);

E = zeros(N,2);
for k=1:N
    E(k,1) = histent(x,k);
    E(k,2) = qent(x,k);
end

fig = figure('units','centimeters','position',[30,15,11,8]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.25)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.25)
grid on
yticks([0 0.5 1 1.5 2])
xlabel('Number of Partitions/States','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title("Pareto Distribution",'interpreter', 'latex')
legend('Histogram','Quantile','Location','southeast','interpreter', 'latex')
set(gca,"FontSize",11)
pbaspect([1.1 1 1])

%% Dataset
fig = figure('units','centimeters','position',[30,15,3,8]);

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

%% Large Sample
% N = 5000;
% xpd = makedist('Generalized Pareto',2,5,1);
% x = random(pd,N,1);
% 
% E = zeros(N,2);
% for k=1:N
%     E(k,1) = histent(x,k);
%     E(k,2) = qent(x,k);
% end

fig = figure('units','centimeters','position',[30,15,3,2]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.25)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.25)
xlim([0 N])
xticks([0 N])
% yticks([0 1 2])
set(gca,"FontSize",7)
set(gcf, 'color', 'none');   
% set(gca, 'color', 'none');
pbaspect([1.5 1 1])


