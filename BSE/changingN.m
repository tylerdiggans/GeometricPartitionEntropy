close all

rng(1);

pd2 = makedist('Uniform');%,'sigma',5)
pd3 = makedist('Beta','a',0.5,'b',0.5);
pd4 = makedist('Beta','a',2,'b',2);
pd5 = makedist('Beta','a',1,'b',20);
pd6 = makedist('Normal','mu',0.5,'sigma',0.1); pd6 = truncate(pd6,0,1);
pd7 = makedist('Normal','mu',0.25,'sigma',0.05); pd7 = truncate(pd7,0,1);
pd8 = makedist('Normal','mu',0.75,'sigma',0.05); pd8 = truncate(pd8,0,1);

% % Draw Samples
% N = 100000;
% D1 = linspace(0, 1, N);     D2 = sort(pd2.random(N,1)); 
% D3 = sort(pd3.random(N,1)); D4 = sort(pd4.random(N,1)); 
% D5 = sort(pd5.random(N,1)); D6 = sort(pd6.random(N,1));
% D7 = sort([pd7.random(3*N/4,1); pd8.random(N/4,1)]);
% 
% %% Spike and Slab
% D8 = sort([pd2.random(3*N/4,1);0.5*ones(N/4,1)]);
% % MATLAB COLORS
colors = ["#0072BD","#D95319","#EDB120","#7E2F8E","#77AC30",...
    "#4DBEEE", "#A2142F",'k','r','g'];                   

Inputs = [40, 100,500,1000,5000,10000,20000,50000,100000];

BSGA = zeros(length(Inputs),8); 
BSRE = zeros(length(Inputs),8); 
BSIE = zeros(length(Inputs),8);

for n=1:length(Inputs)
    % Draw Samples
    NN = Inputs(n);             
    d1 = linspace(0, 1, NN);     d2 = sort(pd2.random(NN,1)); 
    d3 = sort(pd3.random(NN,1)); d4 = sort(pd4.random(NN,1)); 
    d5 = sort(pd5.random(NN,1)); d6 = sort(pd6.random(NN,1));
    d7 = sort([pd7.random(3*NN/4,1); pd8.random(NN/4,1)]);
%% Spike and Slab
    d8 = sort([pd2.random(3*NN/4,1);0.5*ones(NN/4,1)]);
%     d1 = linspace(0,1, NN);      d2 = datasample(D2,NN);
%     d3 = datasample(D3,NN);       d4 = datasample(D4,NN);
%     d5 = datasample(D5,NN);       d6 = datasample(D6,NN);
%     d7 = datasample(D7,NN);       d8 = datasample(D8,NN);
    for m=1:8
        d = eval(strcat('d',string(m)));
        mind = 0; maxd=1;
        % histogram bins
        [p, edges] = histcounts(d,linspace(mind,maxd,NN+1));
        p1 = p./sum(p);
        q1 = diff(edges)/(maxd-mind);
        q1 = q1/sum(q1);
        % quantile bins
        quants = linspace(0,1,NN+1);
        V = [mind quantile(d,quants(1,2:end-1)) maxd];
        q2 = abs(diff(V))/(maxd-mind);          % abs for error in deltas
        p2 = histcounts(d,V);
        p2 = p2./sum(p2);    
        pq = (p1+q2)/2;
        % B-S measures
        ixq = ~q2; ixp = ~p2; ix = or(ixp,ixq);
        p2_=p2; p2_(ix)=[]; q2_=q2; q2_(ix)= [];        
        BSGA(n,m) = dot(q2_,log(q2_))-dot(q2_,log(p2_));
        pq_ = pq;  pq_(ixq) = []; q2(ixq)=[];
        BSIE(n,m) = dot(q2,log(q2))-dot(q2,log(pq_));
        % remove empty bins for remaining measures
        ix = ~p1;
        p1(ix) = [];    q1(ix) = [];    pq(ix) = [];
        BSIE(n,m) = 1- (BSIE(n,m) + dot(p1,log(p1))-dot(p1,log(pq)))/(2*log(2));        
        BSRE(n,m) = dot(p1,log(p1))-dot(p1,log(q1));
    end
end
% U = [0.2868 1.2386 0.2396 0.7091 1.6149 2.8077 1.0039 0.6385;
%     0.2034 1.5832 0.4514 0.4741 1.5829 3.2173 1.4566 0.4966;
%     0.2394 2.0104 0.3683 0.4446 1.9266 4.2038 2.0024 0.5014;
%     0.2237 2.0978 0.4024 0.4622 1.9376 4.2824 2.2097 0.5168;
%     0.2301 2.6871 0.3667 0.4576 2.1644 4.9831 2.7047 0.5146;
%     0.2344 2.7070 0.3786 0.4345 2.1740 5.1114 2.6165 0.5156;
%     0.2273 2.8921 0.3757 0.4417 2.1778 5.2346 2.8672 0.5193;
%     0.2291 2.8444 0.3778 0.4423 2.4261 5.9086 2.9058 0.5167;
%     0.2297 2.8287 0.3760 0.4348 2.3313 6.2131 3.0385 0.5190];
% RE = [0.6199 1.0460 0.6546 0.8795 1.3431 2.0141 1.1199 1.1015;
%     0.5562 1.1992 0.8692 0.7271 1.1276 2.0141 1.2907 1.2285;
%     0.5434 1.2182 0.7007 0.7074 1.1633 1.9716 1.3461 1.5715;
%     0.5510 1.1731 0.8236 0.6897 1.2022 1.9497 1.3040 1.7211;
%     0.5728 1.1856 0.7879 0.6650 1.1300 1.9268 1.3165 2.1267;
%     0.5844 1.1789 0.7940 0.6572 1.1289 1.9465 1.3063 2.2940;
%     0.5682 1.1852 0.8020 0.6521 1.1495 1.9387 1.3055 2.4704;
%     0.5723 1.1842 0.7969 0.6587 1.1508 1.9429 1.3049 2.6957;
%     0.5729 1.1788 0.7964 0.6574 1.1474 1.9420 1.3071 2.8695];
% REDO
% IE = [0.6986 0.4785 0.7392 0.5764 0.4071 0.3369 0.5530 0.5402;
%     0.7651 0.4599 0.6126 0.6562 0.4517 0.3401 0.5210 0.6198;
%     0.7864 0.4543 0.6844 0.6836 0.4426 0.3416 0.4904 0.6365;
%     0.7932 0.4553 0.6508 0.6830 0.4421 0.3422 0.4994 0.6303;
%     0.7906 0.4504 0.6795 0.7024 0.4565 0.3418 0.4890 0.6427;
%     0.7803 0.4519 0.6734 0.7028 0.4565 0.3407 0.4978 0.6389;
%     0.7891 0.4514 0.6733 0.7048 0.4521 0.3418 0.4946 0.6378;
%     0.7866 0.4530 0.6732 0.7048 0.4500 0.3416 0.4960 0.6418;
%     0.7873 0.4539 0.6740 0.7062 0.4511 0.3418 0.4953 0.6423];

colors = ["#0072BD","#D95319","#EDB120","#7E2F8E","#77AC30",...
    "#4DBEEE", "#A2142F",'k'];   
for m=1:8
    figure(1);
    semilogx([40, 100,500,1000,5000,10000,20000,50000,100000],BSGA(:,m),'Color',colors(m),'LineWidth',3); hold on

    figure(2);
    semilogx([40, 100,500,1000,5000,10000,20000,50000,100000],BSRE(:,m),'Color',colors(m),'LineWidth',3); hold on

    figure(3);
    semilogx([40,100,500,1000,5000,10000,20000,50000,100000],BSIE(:,m),'Color',colors(m),'LineWidth',3); hold on
end
figure(1);
title({'Boltzmann-Shannon', 'Geometric Aggregation'},'interpreter','latex')
xlabel('Sample size ($N$)','interpreter','latex')
ylabel('$BS_{GA}(X_N)$','interpreter','latex')
legend('$\mathcal{EP}$','$\mathcal{U}[0,1]$','$Beta(\frac{1}{2},\frac{1}{2})$',...
    '$Beta(2,2)$','$Beta(1,20)$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\mathcal{G}\mathcal{M}$',...
    '$\mathcal{S}\mathcal{S}$','interpreter','latex','Orientation','horizontal','fontsize',20)
set(gca,'fontsize',24) 
ylim([0 7.5])
yticks(0:7)
xticks([100,1000,10000,100000])
hFig = figure(1);
set(hFig,'position', [100 100 480 800]); 

figure(2);
title({'Boltzmann-Shannon', 'Relative Entropy'},'interpreter','latex')
xlabel('Sample size ($N$)','interpreter','latex')
ylabel('$BS_{RE}(X_N)$','interpreter','latex')
legend('$\mathcal{EP}$','$\mathcal{U}[0,1]$','$Beta(\frac{1}{2},\frac{1}{2})$',...
    '$Beta(2,2)$','$Beta(1,20)$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\mathcal{G}\mathcal{M}$',...
    '$\mathcal{S}\mathcal{S}$','interpreter','latex','Orientation','horizontal','NumColumns',2,'fontsize',20)
set(gca,'fontsize',24) 
ylim([0 3])
yticks(0:3)
xticks([100,1000,10000,100000])
hFig = figure(2);
set(hFig,'position', [600 100 480 800]); 

figure(3);
title({'Boltzmann-Shannon','Interaction Entropy'},'interpreter','latex')
xlabel('Sample size ($N$)','interpreter','latex')
ylabel('$BS_{IE}(X_N)$','interpreter','latex')
legend('$\mathcal{EP}$','$\mathcal{U}[0,1]$','$Beta(\frac{1}{2},\frac{1}{2})$',...
    '$Beta(2,2)$','$Beta(1,20)$','$\mathcal{N}(\frac{1}{2},\frac{1}{10})$','$\mathcal{G}\mathcal{M}$',...
    '$\mathcal{S}\mathcal{S}$','interpreter','latex','Orientation','horizontal','NumColumns',2,'fontsize',20)
ylim([0 1])
yticks([0 1])
xticks([100,1000,10000,100000])
set(gca,'fontsize',24) 
hFig = figure(3);
set(hFig,'position', [1100 100 480 800]); 