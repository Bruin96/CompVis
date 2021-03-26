function MSE = compute_disparity_error(I1,I2, ground_truth, max_disparity)  
    [x1,y1,x2,~] = pick_features(I1,I2);
    MSE = 0;
    % loop through all features
    for n = 1:length(x1)
        % value at position (floor(x1(n)), floor(y1(n)))
        prediction = abs(x2(n) - x1(n))
        value = ground_truth(floor(y1(n)), floor(x1(n))) * max_disparity
        MSE = MSE + (value - prediction)^2;
    end
    MSE = MSE / length(x1);