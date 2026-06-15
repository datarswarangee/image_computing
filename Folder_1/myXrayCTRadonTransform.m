function R = myXrayCTRadonTransform(f, X, Y, t_vals, theta_vals, delta_s)

R = zeros(length(t_vals), length(theta_vals));

for i = 1:length(theta_vals)
    for j = 1:length(t_vals)
        R(j,i) = myXrayIntegration(f, X, Y, ...
                                   t_vals(j), ...
                                   theta_vals(i), ...
                                   delta_s);
    end
end

end
