clearvars; close all; clc;

rng(3)

%% Short Term
N = 5000;
pd = makedist('Normal','mu',0,'sigma',1);
x = random(pd,N,1);

E = zeros(N,3);
for k=1:N
    E(k,1) = histent(x,k);
    E(k,2) = qent(x,k);
end
% parfor k=1:N-1
%     E(k,3) = knn1D(x,k);
% end
KNN = knn1D(x,4);

fig = figure('units','centimeters','position',[30,10,11,8]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.5)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.5)
plot(KNN*ones(N,1),'--r','MarkerSize',2,'LineWidth',1.25)
%plot(E(1:end-1,3),'-r','MarkerSize',2,'LineWidth',1.5)
grid on
xlim([0 5000])
xticks([0 1000 2000 3000 4000 5000])
ylim([0 12])
yticks([0 3 6 9 12])
xlabel('k','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title("Normal Distribution ($\mu=0, \sigma=1$)",'interpreter', 'latex')
legend('Histogram','Quantile','$H_4^{NN}$','Location','southeast','interpreter', 'latex')
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


