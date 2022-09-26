clearvars; close all; clc;

% % Gaussian Mixture

rng(7)

%% Larger Sample
N = 500;
x = [normrnd(0,5,250,1); normrnd(50,20,150,1); normrnd(-30,10,100,1)];

E = zeros(N,2);
for k=1:N
    E(k,1) = histent(x,k);
    E(k,2) = qent(x,k);
end

fig = figure('units','centimeters','position',[20,12,11,8]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.25)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.25)
grid on
xlabel('Number of Partitions/States','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title("Gaussian-Mixture",'interpreter', 'latex')
legend('Histogram','Quantile','Location','southeast','interpreter', 'latex')
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

E = zeros(N,2);
for k=1:N
    E(k,1) = histent(x,k);
    E(k,2) = qent(x,k);
end

fig = figure('units','centimeters','position',[20,12,11,8]);

plot(E(:,1),'-b','MarkerSize',2,'LineWidth',1.25)
hold on
plot(E(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.25)
grid on
xlabel('Number of Partitions/States','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title("Gaussian-Mixture",'interpreter', 'latex')
legend('Histogram','Quantile','Location','southeast','interpreter', 'latex')
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




