clc; clear; close all;

%% Generate Shepp-Logan phantom
N = 128;
f = phantom(128);   % f(x,y)

x = linspace(-(N-1)/2,(N-1)/2,N);
y = linspace(-(N-1)/2,(N-1)/2,N);

figure; imagesc(x,y,f); colormap gray; axis image;
title('Shepp-Logan Phantom f(x,y)');

%% Radon transform
theta = 0:3:177;
[R,xp] = radon(f,theta);

figure;
imagesc(theta,xp,R); colormap gray; colorbar;
title('Radon Transform');

%% Compute maximum frequency
n = size(R,1);
w = linspace(-pi,pi,n)';
wmax = max(abs(w));

%% Filtering for L = wmax and L = wmax/2
L1 = wmax;
L2 = wmax/2;

filters = {'ramlak','shepp-logan','cosine'};

for k = 1:length(filters)

    Rf1 = myFilter(R,w,L1,filters{k});
    Rf2 = myFilter(R,w,L2,filters{k});

    rec1 = iradon(Rf1,theta,'linear','none',1,N);
    rec2 = iradon(Rf2,theta,'linear','none',1,N);

    figure;
    subplot(1,2,1); imagesc(rec1); colormap gray; axis image;
    title([filters{k} ' L = wmax']);

    subplot(1,2,2); imagesc(rec2); colormap gray; axis image;
    title([filters{k} ' L = wmax/2']);
end

%% Unfiltered backprojection
rec_unfiltered = iradon(R,theta,'linear','none',1,N);
figure; imagesc(rec_unfiltered); colormap gray; axis image;
title('Unfiltered Backprojection');

%% Gaussian blurring
mask1 = fspecial('gaussian',11,1);
S1 = conv2(f,mask1,'same');

mask5 = fspecial('gaussian',51,5);
S5 = conv2(f,mask5,'same');

S0 = f;

figure;
subplot(1,3,1); imagesc(S0); colormap gray; axis image; title('S0');
subplot(1,3,2); imagesc(S1); colormap gray; axis image; title('S1');
subplot(1,3,3); imagesc(S5); colormap gray; axis image; title('S5');

%% Radon + Ram-Lak filtering + Backprojection
[R0,~] = radon(S0,theta);
[R1,~] = radon(S1,theta);
[R5,~] = radon(S5,theta);

Rf0 = myFilter(R0,w,wmax,'ramlak');
Rf1 = myFilter(R1,w,wmax,'ramlak');
Rf5 = myFilter(R5,w,wmax,'ramlak');

rec0 = iradon(Rf0,theta,'linear','none',1,N);
rec1 = iradon(Rf1,theta,'linear','none',1,N);
rec5 = iradon(Rf5,theta,'linear','none',1,N);

figure;
subplot(1,3,1); imagesc(rec0); colormap gray; axis image; title('R0');
subplot(1,3,2); imagesc(rec1); colormap gray; axis image; title('R1');
subplot(1,3,3); imagesc(rec5); colormap gray; axis image; title('R5');

Lvals = linspace(wmax/50,wmax,50);
err0 = zeros(size(Lvals));
err1 = zeros(size(Lvals));
err5 = zeros(size(Lvals));

for i = 1:length(Lvals)
    
    Rf0 = myFilter(R0,w,Lvals(i),'ramlak');
    Rf1 = myFilter(R1,w,Lvals(i),'ramlak');
    Rf5 = myFilter(R5,w,Lvals(i),'ramlak');
    
    rec0 = iradon(Rf0,theta,'linear','none',1,N);
    rec1 = iradon(Rf1,theta,'linear','none',1,N);
    rec5 = iradon(Rf5,theta,'linear','none',1,N);
    
    err0(i) = RRMSE(S0,rec0);
    err1(i) = RRMSE(S1,rec1);
    err5(i) = RRMSE(S5,rec5);
end

figure;
plot(Lvals,err0,'r',Lvals,err1,'g',Lvals,err5,'b');
legend('S0','S1','S5');
xlabel('L'); ylabel('RRMSE');
title('RRMSE vs L');
