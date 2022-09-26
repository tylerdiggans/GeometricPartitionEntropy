clearvars; close all; clc;

load LogisticMapData2
x = reshape(x,[],100);
[N, Runs] = size(x);
k = 25;
R = linspace(0.25, 10, 1000)';

for j=1:Runs
for i=1:length(R)
    n = ceil(k*R(i));
    H(i,j) = histent(x(1:n,j),k);
    Q(i,j) = qent(x(1:n,j),k);
end
end

fig = figure('units','centimeters','position',[30,15,10,7]);

plot(R,mean(H,2),'-b','MarkerSize',2,'LineWidth',1.5)
hold on
plot(R,mean(Q,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',1.5)
grid on
xlabel('$N_i / k$','interpreter', 'latex')
ylabel('Entropy','interpreter', 'latex')
title(strcat("Logistic Map using k=",num2str(k)),'interpreter', 'latex')
legend('Histogram','Quantile','Location','southeast','interpreter', 'latex')
xlim([0 10])
xticks([0 1:10])
set(gca,"FontSize",11)