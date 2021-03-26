function MSE = compute_disparity_error(I1,I2, ground_truth)  

    [x1,y1,x2,~] = pick_features(I1,I2);

    predictions = NaN(size(ground_truth));

    % loop through all features
    for i = 1:length(x1)
             predictions(floor(y1(i)), floor(x1(i))) = abs(x2(i) - x1(i));
    end
    
    minimum_disparity = min(min(predictions))
    maximum_disparity = max(max(predictions))
    not_nan = ~isnan(predictions);
    predictions(not_nan) = (predictions(not_nan) - max(predictions(not_nan))) ./ (max(predictions(not_nan)) - min(predictions(not_nan)));
    ground_truth_norm = (ground_truth - max(ground_truth)) ./ (max(ground_truth) - min(ground_truth));
    MSE = sum(sum((ground_truth_norm(not_nan) - predictions(not_nan)).^2)) / length(x1);