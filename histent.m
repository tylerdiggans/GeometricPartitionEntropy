function [E, Edges, P] = histent(x, k)
% Computes the histogram entropy estimate for sample x with k bins 
[h, Edges] = histcounts(x, k);
p = h./sum(h);
P = p';
p(~p) = [];
E = -dot(p,log2(p));        % Shannon Entropy of probability distro
end

