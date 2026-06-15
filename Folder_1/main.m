clc; clear; close all;

%% Generate Shepp-Logan Phantom
N = 128;
f = phantom(N);      % f(x,y)

% Define coordinate system centered at origin
x = linspace(-(N-1)/2,(N-1)/2,N);
y = linspace(-(N-1)/2,(N-1)/2,N);
[X,Y] = meshgrid(x,y);

figure; imagesc(x,y,f); colormap gray; axis image;
title('Shepp-Logan Phantom f(x,y)');
xlabel('x'); ylabel('y');

%% Part (b) Radon Transform with Δs = 1
delta_s = 1;
t_vals = -90:5:90;
theta_vals = 0:5:175;

R1 = myXrayCTRadonTransform(f, X, Y, t_vals, theta_vals, delta_s);

figure;
imagesc(theta_vals, t_vals, R1);
colormap gray; colorbar;
title('Radon Transform (Δs = 1)');
xlabel('\theta (degrees)');
ylabel('t');

%% Part (c) Compare different Δs
R05 = myXrayCTRadonTransform(f, X, Y, t_vals, theta_vals, 0.5);
R1  = myXrayCTRadonTransform(f, X, Y, t_vals, theta_vals, 1);
R3  = myXrayCTRadonTransform(f, X, Y, t_vals, theta_vals, 3);

figure;
subplot(1,3,1); imagesc(theta_vals,t_vals,R05); colormap gray; axis image;
title('\Deltas = 0.5');

subplot(1,3,2); imagesc(theta_vals,t_vals,R1); colormap gray; axis image;
title('\Deltas = 1');

subplot(1,3,3); imagesc(theta_vals,t_vals,R3); colormap gray; axis image;
title('\Deltas = 3');

%% 1D plots at θ = 0 and θ = 90
theta0_index = find(theta_vals == 0);
theta90_index = find(theta_vals == 90);

figure;
subplot(1,2,1);
plot(t_vals,R05(:,theta0_index),'r', ...
     t_vals,R1(:,theta0_index),'g', ...
     t_vals,R3(:,theta0_index),'b');
title('Rf(t, 0°)');
legend('\Deltas=0.5','\Deltas=1','\Deltas=3');
xlabel('t'); ylabel('Radon value');

subplot(1,2,2);
plot(t_vals,R05(:,theta90_index),'r', ...
     t_vals,R1(:,theta90_index),'g', ...
     t_vals,R3(:,theta90_index),'b');
title('Rf(t, 90°)');
legend('\Deltas=0.5','\Deltas=1','\Deltas=3');
xlabel('t'); ylabel('Radon value');
