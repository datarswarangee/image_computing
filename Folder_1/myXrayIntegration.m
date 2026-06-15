function integral = myXrayIntegration(f, X, Y, t, theta, delta_s)

% Define s range based on image diagonal
maxS = sqrt(2)*(size(f,1)/2);
s = -maxS:delta_s:maxS;

% Parametric line equation
x_line = t*cosd(theta) - s*sind(theta);
y_line = t*sind(theta) + s*cosd(theta);

% Interpolation (linear)
values = interp2(X, Y, f, x_line, y_line, 'linear', 0);

% Numerical integration
integral = sum(values)*delta_s;

end
