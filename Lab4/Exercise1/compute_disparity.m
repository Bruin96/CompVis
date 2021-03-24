function map = compute_disparity(I1,I2)
    [N,M] = size(I1);
    map = zeros(N,M);
    
    [x1,y1,x2,y2] = pick_features(I1,I2);
    
    for n = 1:length(x1)
        map(floor(x1(n)), floor(y1(n))) = abs(x2(n) - x1(n));  
    end