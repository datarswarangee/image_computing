function [x, rrmse_hist] = myART(A, b, x_true, lambda, ordering, maxIter)

[M, N] = size(A);

x = zeros(N,1);
rowNormSq = sum(A.^2,2);

rrmse_hist = zeros(maxIter,1);

for iter = 1:maxIter
    
    for k = 1:M
        
        m = ordering(k);
        
        if rowNormSq(m) > 0
            residual = b(m) - A(m,:) * x;
            x = x + lambda * residual / rowNormSq(m) * A(m,:)';
        end
        
    end
    
    rrmse_hist(iter) = norm(x - x_true) / norm(x_true);
end

end