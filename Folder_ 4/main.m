clear; clc; close all;

% Load file safely
data = load('assignmentMathImagingRecon_chestCT.mat');
fields = fieldnames(data);
f = double(data.(fields{1}));

% Downsample to 64×64 (VERY IMPORTANT for speed)
f = imresize(f, [64 64]);

[N, ~] = size(f);
x_true = f(:);


%% Imaging geometry
angles = 0:1:179;
numAngles = length(angles);
numDetectors = N;

%% Construct system matrix A manually
fprintf('Constructing system matrix A...\n');
[A] = constructSystemMatrix(N, angles);

%% Generate noiseless projections
b_clean = A * x_true;

%% Add 5% Gaussian noise
sigma = 0.05 * (max(b_clean) - min(b_clean));
b_noisy = b_clean + sigma * randn(size(b_clean));

%% ART parameters
maxIter = 2;                     % number of full passes
ordering = 1:size(A,1);           % sequential ordering

%% Plot RRMSE vs iteration for different lambda
figure; hold on;

for lambda = 0.1:0.1:1
    
    [x_est, rrmse_hist] = myART(A, b_noisy, x_true, lambda, ordering, maxIter);
    plot(rrmse_hist);
end

xlabel('Iteration');
ylabel('RRMSE');
title('RRMSE vs Iteration for Different \lambda');
legend('0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0');
grid on;
