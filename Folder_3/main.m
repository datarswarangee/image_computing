clc; clear; close all;

%% Load datasets
load('chestCT.mat');      % assume variable chestCT
load('myPhantom.mat');    % assume variable myPhantom

datasets = {chestCT, myPhantom};
names = {'Chest CT','My Phantom'};

for d = 1:2
    
    f = datasets{d};
    f = double(f);
    N = size(f,1);
    
    theta_all = 0:180;
    RRMSE_vals = zeros(length(theta_all),1);
    
    for k = 1:length(theta_all)
        
        theta_start = theta_all(k);
        theta_range = theta_start : theta_start+150;
        
        % keep angles within 0–359
        theta_range = mod(theta_range,360);
        
        % compute radon transform
        [R,xp] = radon(f,theta_range);
        
        % filtered backprojection using Ram-Lak
        rec = iradon(R,theta_range,'linear','Ram-Lak',1,N);
        
        % compute RRMSE
        RRMSE_vals(k) = RRMSE(f,rec);
    end
    
    %% Plot RRMSE vs theta
    figure;
    plot(theta_all,RRMSE_vals,'LineWidth',2);
    xlabel('\theta start (degrees)');
    ylabel('RRMSE');
    title(['RRMSE vs Starting Angle - ' names{d}]);
    
    %% Find minimum RRMSE
    [min_err,idx] = min(RRMSE_vals);
    best_theta = theta_all(idx);
    
    disp(['Dataset: ' names{d}]);
    disp(['Best starting angle: ' num2str(best_theta)]);
    disp(['Minimum RRMSE: ' num2str(min_err)]);
    
    %% Reconstruct best case
    best_range = best_theta : best_theta+150;
    best_range = mod(best_range,360);
    
    [R_best,~] = radon(f,best_range);
    rec_best = iradon(R_best,best_range,'linear','Ram-Lak',1,N);
    
    figure;
    subplot(1,2,1);
    imagesc(f); colormap gray; axis image;
    title(['Ground Truth - ' names{d}]);
    
    subplot(1,2,2);
    imagesc(rec_best); colormap gray; axis image;
    title(['Best Reconstruction, \theta = ' num2str(best_theta)]);
    
end
