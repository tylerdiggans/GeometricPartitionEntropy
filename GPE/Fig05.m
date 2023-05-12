clearvars; close all; clc;

rng(1)
k = 25;
Nspan = [5 10 15 20 k:k:20*k];

for run=1:1000
    for ptr=1:length(Nspan)
        N = Nspan(ptr);
        x = rand;
        for nn=1:N
            x = [x; 4*x(end).*(1-x(end))];
        end

        [E, Edges] = histent(x, k);
        L = discretize(x,Edges);
        W = zeros(k);
        for i=1:length(L)-1
            W(L(i),L(i+1)) = W(L(i),L(i+1))+1;
        end
        WH = W;
        W = zeros(size(W));
        [E, Edges] = qent(x, k);
        L = discretize(x,Edges);
        W = zeros(k);
        for i=1:length(L)-1
            W(L(i),L(i+1)) = W(L(i),L(i+1))+1;
        end
        WQ = W;
        dh = sum(~~WH,2);
        dq = sum(~~WQ,2);
        DH(ptr,1,run) = min(dh);
        DH(ptr,2,run) = max(dh);
        DQ(ptr,1,run) = min(dq);
        DQ(ptr,2,run) = max(dq);
    end
end
DH = mean(DH,3);
DQ = mean(DQ,3);

fig = figure('units','centimeters','position',[30,15,5,8]);
plot(Nspan'/k,DH(:,2),'-b','LineWidth',2)
hold on
plot(Nspan'/k,DQ(:,2),'-','Color','#EDB120','MarkerSize',2,'LineWidth',2)
xlabel('$N/k$','interpreter', 'latex')
title('Maximum Degree','interpreter', 'latex')
legend('Histogram','Quantile','Location','southeast','interpreter', 'latex')
grid on
set(gca,"FontSize",9)
pbaspect([1 1 1])
% set(gcf, 'color', 'none');
% set(gca, 'color', 'none');
% xlim([1 10])

fig = figure('units','centimeters','position',[30,15,5,8]);
plot(Nspan'/k,DH(:,1),'-b','LineWidth',2)
hold on
plot(Nspan'/k,DQ(:,1),'-','Color','#EDB120','MarkerSize',2,'LineWidth',2)
xlabel('$N/k$','interpreter', 'latex')
title('Minimum Degree','interpreter', 'latex')
legend('Histogram','Quantile','Location','southeast','interpreter', 'latex')
grid on
set(gca,"FontSize",9)
pbaspect([1 1 1])
% set(gcf, 'color', 'none');
% set(gca, 'color', 'none');
% xlim([1 10])

