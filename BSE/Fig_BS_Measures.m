clearvars; close all;
rng(1);

N = 10000;
pd2 = makedist('Uniform');%,'sigma',5)
pd3 = makedist('Beta','a',0.5,'b',0.5);
pd4 = makedist('Beta','a',2,'b',2);
pd5 = makedist('Beta','a',1,'b',20);
pd6 = makedist('Normal','mu',0.5,'sigma',0.1); pd6 = truncate(pd6,0,1);
pd7 = makedist('Normal','mu',0.25,'sigma',0.05); pd7 = truncate(pd7,0,1);
pd8 = makedist('Normal','mu',0.75,'sigma',0.05); pd8 = truncate(pd8,0,1);
pd9 = makedist('Normal','mu',0.5,'sigma',0.0001); pd9 = truncate(pd9,0,1);

% Draw Samples
d1 = linspace(0, 1, N); d1 = d1';   d2 = sort(pd2.random(N,1)); 
d3 = sort(pd3.random(N,1));         d4 = sort(pd4.random(N,1)); 
d5 = sort(pd5.random(N,1));         d6 = sort(pd6.random(N,1)); 
%Mixture of Gaussians
d7 = sort([pd7.random(3*N/4,1); pd8.random(N/4,1)]);
%% Spike and Slab
d8 = sort([pd2.random(3*N/4,1); 0.5*ones(N/4,1)]);
%d9 = sort([pd2.random(3*N/4,1);pd9.random(N/4,1)]);
%d10 = sort([pd2.random(N/4,1); 0.5*ones(3*N/4,1)]);

% MATLAB COLORS
colors = ["#0072BD","#D95319","#EDB120","#7E2F8E","#77AC30",...
    "#4DBEEE", "#A2142F",'k','r','g'];           
step = 250;
NN = N/step;
BSRE = zeros(NN,8); BSGA = zeros(NN,8); BSIE = zeros(NN,8);
for m=1:8
    d = eval(strcat('d',string(m)));
    mind = 0; maxd=1;    
    K = length(d);
    for k=step:step:K
        % histogram bins
        [p, edges] = histcounts(d,linspace(mind,maxd,k+1));
        p1 = p./sum(p);
        q1 = diff(edges)/(maxd-mind);
        q1 = q1/sum(q1);
        % quantile bins
        quants = linspace(0,1,k+1);
        V = [mind quantile(d,quants(1,2:end-1)) maxd];
        q2 = abs(diff(V))/(maxd-mind);          % abs for error in deltas
        p2 = histcounts(d,V);
        p2 = p2./sum(p2);    
        pq = (p1+q2)/2;
        % B-S measures
        ixq = ~q2; ixp = ~p2; ix = or(ixp,ixq);
        p2_=p2; p2_(ix)=[]; q2_=q2; q2_(ix)= [];        
        cnt = k/step;
        BSGA(cnt,m) = dot(q2_,log(q2_))-dot(q2_,log(p2_));
        pq_ = pq;  pq_(ixq) = []; q2(ixq)=[];
        BSIE(cnt,m) = dot(q2,log(q2))-dot(q2,log(pq_));
        % remove empty bins for remaining measures
        ix = ~p1;
        p1(ix) = [];    q1(ix) = [];    pq(ix) = [];
        BSIE(cnt,m) = 1- (BSIE(cnt,m) + dot(p1,log(p1))-dot(p1,log(pq)))/(2*log(2));        
        BSRE(cnt,m) = dot(p1,log(p1))-dot(p1,log(q1));
    end
    figure(1);
    plot(step:step:K,BSGA(:,m),'-o', 'Color', colors(m),'MarkerFaceColor',...
        colors(m)); hold on;
    set(gca,'fontsize',32) 
    figure(2);
    plot(step:step:K, BSRE(:,m),'-o',	'Color', colors(m),'MarkerFaceColor',...
        colors(m)); hold on
    set(gca,'fontsize',32) 
    %ylim([0 2.75])
    %yticks(0:0.5:2.5)


    figure(3);
    plot(step:step:K, BSIE(:,m),'-o',	'Color', colors(m),'MarkerFaceColor',...
        colors(m)); hold on
    set(gca,'fontsize',32) 

    figure(4);
    [f,x] = ecdf(d);
    if m==1
        plot(x,f,'--','Color', colors(m), 'Linewidth',4); hold on
        set(gca,'fontsize',32) 
    else
        plot(x,f,'-','Color', colors(m), 'Linewidth',2.5); hold on
        set(gca,'fontsize',32) 
    end
    figure(5);

    if m<8
        scatter(0.1*m*ones(N,1), d, 400, 'o','filled','MarkerFaceColor', colors(m),...
        'MarkerFaceAlpha',0.05); 
    else
        d = d(d~=0.5);
        scatter(0.1*m*ones(length(d),1), d, 400, 'o','filled','MarkerFaceColor', colors(m),...
            'MarkerFaceAlpha',0.005); 
        scatter(0.1*m, 0.5, 400, 'o','filled','MarkerFaceColor', colors(m)); 
    end
    hold on
    xlim([0 0.9])
    xticks([])
    ylim([0 1])
    yticks([0.0 1.0])
    ylabel('Data Sets')
    set(gca,'fontsize',36) 
    set(gca,'YAxisLocation','right')
%  % Make the horizontal data distributions
%     figure(5);
%     if m~=8
%         scatter(d, 0.1*m*ones(N,1), 400, 'o','filled','MarkerFaceColor', colors(m),...
%         'MarkerFaceAlpha',0.05); 
%     else
%         d = d(d~=0.5);
%         scatter(d, 0.1*m*ones(length(d),1), 400, 'o','filled','MarkerFaceColor', colors(m),...
%             'MarkerFaceAlpha',0.005); 
%         scatter(0.5, 0.1*m, 400, 'o','filled','MarkerFaceColor', colors(m)); 
%     end
% %    scatter(d, 0.1*m*ones(N,1), 150, 'o','filled','Color', colors(m)); 
%     hold on
%     ylim([0 1])
%     yticks([])
%     xlim([0 1])
%     xticks([0.0 1.0])
%     xlabel('Data Sets')
%     set(gca,'fontsize',24) 

%     figure(6);
%     plot(step:step:K, DSE,'-o',	'Color', colors(m),'MarkerFaceColor',...
%         colors(m)); hold on
%     set(gca,'fontsize',32) 
%     figure(7);
%     plot(step:step:K, GPE,'-o',	'Color', colors(m),'MarkerFaceColor',...
%         colors(m)); hold on
%     set(gca,'fontsize',32) 

end

figure(1)
% legend('$\mathcal{EP}$','$\mathcal{U}[0,1]$','$Beta(\frac{1}{2},\frac{1}{2})$',...
%     '$Beta(2,2)$','$Beta(1,20)$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\mathcal{G}\mathcal{M}$',...
%     '$\mathcal{S}\mathcal{S}$','interpreter','latex','location','eastoutside','fontsize',20);
title({'Boltzmann-Shannon','Geometric Aggregation'},'interpreter','latex')
xlabel('Partition Size $K$','interpreter','latex');
ylabel('$D_{KL}({\bf q}||{\bf p})$','interpreter','latex');
%axis('square')
hFig = figure(1);
set(hFig,'position', [100 100 700 700]); 

figure(2); 
% legend('$\mathcal{EP}$','$\mathcal{U}[0,1]$','$Beta(\frac{1}{2},\frac{1}{2})$',...
%     '$Beta(2,2)$','$Beta(1,20)$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\mathcal{G}\mathcal{M}$',...
%     '$\mathcal{S}\mathcal{S}$','interpreter','latex','location','eastoutside','fontsize',20);
title({'Boltzmann-Shannon', 'Relative Entropy'},'interpreter','latex')
xlabel('Partition Size $K$','interpreter','latex');
ylabel('$D_{KL}({\bf p}||{\bf q})$','interpreter','latex');
ylim([0 2.5])
%axis('square')
hFig = figure(2);
set(hFig,'position', [100 100 700 700]); 

figure(3); 
legend('$\mathcal{EP}$','$\mathcal{U}[0,1]$','$Beta(\frac{1}{2},\frac{1}{2})$',...
    '$Beta(2,2)$','$Beta(1,20)$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\mathcal{G}\mathcal{M}$',...
    '$\mathcal{S}\mathcal{S}$','interpreter','latex','location','eastoutside','fontsize',20);
title({'Boltzmann-Shannon', 'Interaction Entropy'},'interpreter','latex')
xlabel('Partition Size $K$','interpreter','latex');
ylabel('$1-\frac{JSD({\bf p}||{\bf q})}{\log(2)}$','interpreter','latex');
ylim([0 1])
yticks(0:0.5:1)
%axis('square')
hFig = figure(3);
set(hFig,'position', [100 100 700 700]); 
% 
figure(4); 
legend('$\mathcal{EP}$','$\mathcal{U}[0,1]$','$Beta(\frac{1}{2},\frac{1}{2})$',...
    '$Beta(2,2)$','$Beta(1,20)$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\mathcal{GM}$',...
    '$\mathcal{S}\mathcal{S}$','interpreter','latex','fontsize',20);
ylim([0 1])
title('Empirical CDFs','interpreter','latex')
ylabel('$Prob(X\leq x)$','interpreter','latex')
yticks([0 1])
xlabel('$x$','interpreter','latex')
hFig = figure(4);
set(hFig,'position', [500 100 700 700]); 

figure(5);

hFig = figure(5);
set(hFig,'position', [1236,129,1000,225]); 


% figure(6); 
% legend('$\mathcal{U}[0,1]$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\beta(\frac{1}{2},\frac{1}{2})$',...
%     '$\beta(2,2)$','$\beta(5,1)$','$\beta(1,20)$','Mix',...
%     'Spike/Slab','interpreter','latex','Orientation','horizontal','NumColumns',2,'fontsize',18)
% title({'Differential Shannon Entropy','(Histogram Estimate)'},'interpreter','latex')
% xlabel('Number of bins $K$','interpreter','latex');
% ylabel('$H_{DSE}({\bf p})$','interpreter','latex');
% %ylim([0 1])
% %yticks([0 0.25 0.5 0.75 1])
% %axis('square')
% hFig = figure(6);
% set(hFig,'position', [100 100 700 700]); 
% 
% figure(7); 
% legend('$\mathcal{U}[0,1]$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\beta(\frac{1}{2},\frac{1}{2})$',...
%     '$\beta(2,2)$','$\beta(5,1)$','$\beta(1,20)$','Mix',...
%     'Spike/Slab','interpreter','latex','Orientation','horizontal','NumColumns',2,'fontsize',18)
% title({'Geometric Partition Entropy', '(Quantile Estimate)'},'interpreter','latex')
% xlabel('Number of bins $K$','interpreter','latex');
% ylabel('$H_{GPE}({\bf q})$','interpreter','latex');
% %ylim([0 1])
% %yticks([0 0.25 0.5 0.75 1])
% %axis('square')
% hFig = figure(7);
% set(hFig,'position', [100 100 700 700]); 




