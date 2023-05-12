function [E, q] = qent(x,k)
% Computes the geometric quantile partition entropy for a sample x using k
% macrostates
qp = linspace(0,1,k+1)';
q = quantile(x(:), qp);      % Compute k+1 quantiles including end points
l = q(2:end)-q(1:end-1);     % Compute lengths
p = l./sum(l);               % Compute ignorance density
p(isnan(p)) = [];
p(~p) = [];

E = -dot(p,log2(p));         % Shannon Entropy of that density
end

