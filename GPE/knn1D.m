function E = knn1D(x,k)
% Computes the knn entropy estimate for a 1D sample x
% 
N = length(x); x = sort(x);
p = zeros(size(x));
for i=1:N
    neighbors = mink(abs(x-x(i)),k+1);  % k+1 because includes x(i)-x(i)
    p(i) = neighbors(end);              % find kth NN
end
E = 1/N*sum(log(p)) + log(2) + log(N) - psi(k);
end
