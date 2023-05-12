clearvars; close all; clc;

% % Gaussian Mixture

rng(7)

%% Larger Sample
N = 500;
x = [normrnd(0,5,250,1); normrnd(50,20,150,1); normrnd(-30,10,100,1)];

E = zeros(N,3);
for k=1:N
    E(k,1) = histent(x,k);
    E(k,2) = qent(x,k);
end
% parfor k=1:N-1
%     E(k,3) = knn1D(x,k);
% end
KNN = knn1D(x,4);
 
fig = figure('units','centimeters','position',[20,12,11,8]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.5)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.5)
plot(KNN*ones(N,1),'--r','MarkerSize',2,'LineWidth',1.25)
%plot(E(1:end-1,3),'-r','MarkerSize',2,'LineWidth',1.5)
grid on
xlim([0 500])
xticks([0 100 200 300 400 500])
ylim([0 8])
yticks([0 2 4 6 8])
xlabel('k','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title("Gaussian-Mixture",'interpreter', 'latex')
legend('Histogram','Quantile','$H_4^{NN}$','Location','southeast','interpreter', 'latex')
set(gca,"FontSize",11)
pbaspect([1.1 1 1])

%% Dataset
fig = figure('units','centimeters','position',[20,12,3,8]);

% plot(zeros(size(x)),x,'.k','MarkerSize',10);
ptr = scatter(zeros(size(x)),x,'ok','MarkerFaceColor','k','MarkerEdgeColor','none');
ptr.MarkerFaceAlpha = 0.2;
ax = gca;
ax.YAxisLocation = 'right';
ylabel('Dataset','interpreter', 'latex')
xlim([-0.5 0.5])
xticks([])
box off
ylim([-75 125])
pbaspect([1 8 1])
set(gca,"FontSize",11)


%% Small Sample
N = 50;
x = [normrnd(0,5,20,1); normrnd(50,25,15,1); normrnd(-30,10,15,1)];

E = zeros(N,3);
for k=1:N
    E(k,1) = histent(x,k);
    E(k,2) = qent(x,k);
end

% parfor k=1:N-1
%     E(k,3) = knn1D(x,k);
% end
KNN = knn1D(x,4);

fig = figure('units','centimeters','position',[20,12,11,8]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.5)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.5)
plot(KNN*ones(N,1),'--r','MarkerSize',2,'LineWidth',1.25)
%plot(E(1:end-1,3),'-r','MarkerSize',2,'LineWidth',1.5)
grid on
xlim([0 50])
xticks([0 10 20 30 40 50])
ylim([0 5])
yticks([0 1 2 3 4 5])
xlabel('k','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title("Gaussian-Mixture",'interpreter', 'latex')
legend('Histogram','Quantile','$H_4^{NN}$','Location','southeast','interpreter', 'latex')
set(gca,"FontSize",11)
pbaspect([1.1 1 1])

%% Dataset
fig = figure('units','centimeters','position',[20,12,3,8]);

% plot(zeros(size(x)),x,'.k','MarkerSize',10);
ptr = scatter(zeros(size(x)),x,'ok','MarkerFaceColor','k','MarkerEdgeColor','none');
ptr.MarkerFaceAlpha = 0.2;
ax = gca;
ax.YAxisLocation = 'right';
ylabel('Dataset','interpreter', 'latex')
xlim([-0.5 0.5])
xticks([])
box off
ylim([-75 125])
pbaspect([1 8 1])
set(gca,"FontSize",11)
