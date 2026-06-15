function e = RRMSE(A,B)
e = sqrt(sum((A(:)-B(:)).^2)) / sqrt(sum(A(:).^2));
end
