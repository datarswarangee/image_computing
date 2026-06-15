function A = constructSystemMatrix(N, angles)

numAngles = length(angles);
numDetectors = N;
numRays = numAngles * numDetectors;
numPixels = N*N;

[X, Y] = meshgrid(linspace(-1,1,N), linspace(-1,1,N));
X = X(:);
Y = Y(:);

rows = [];
cols = [];
vals = [];

rayIndex = 1;

for theta = angles
    
    t = theta * pi/180;
    
    for s = linspace(-1,1,numDetectors)
        
        distances = abs(X*cos(t) + Y*sin(t) - s);
        width = 2/N;
        mask = find(distances < width);
        
        rows = [rows; rayIndex * ones(length(mask),1)];
        cols = [cols; mask];
        vals = [vals; ones(length(mask),1)];
        
        rayIndex = rayIndex + 1;
    end
end

A = sparse(rows, cols, vals, numRays, numPixels);

end
