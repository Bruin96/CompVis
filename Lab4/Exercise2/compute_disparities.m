% This function switches between the different methods and selects the
% correct function. The possible methods are:
% 1) XCORR : Normalised cross-correlation
% 2) SSD : Sum squared difference
% 3) AD : Absolute difference
function dispars = compute_disparities(im1, im2, method, win_height, win_width)
    if strcmp(method, 'XCORR') == 1
        dispars = compute_disparities_cross_correlation(im1, im2, win_height, win_width);
    elseif strcmp(method, 'SSD') == 1
        dispars = compute_disparities_sum_squared_diff(im1, im2, win_height, win_width);
    elseif strcmp(method, 'AD') == 1
        dispars = compute_disparities_abs_diff(im1, im2, win_height, win_width);
    elseif strcmp(method, 'SNR') == 1
        dispars = compute_disparities_signal_to_noise(im1, im2, win_height, win_width);
    elseif strcmp(method, 'PEARSON') == 1
        dispars = compute_disparities_pearson(im1, im2, win_height, win_width);
    else
        disp('This method is not supported.');
        dispars = zeros(size(im1));
    end
end