function plotPartition(q, loc, col)

h = gca;
for i=1:length(q)
    plot(h, [q(i) q(i)],[loc-0.1 loc+0.1],'Color',col,'LineWidth',1.5)
end

end