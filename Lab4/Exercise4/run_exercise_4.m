close all;
% Since SIFT only accepts gray scale images, we need to convert the input
% stereo pair images
im1 = im2single(rgb2gray(imread('tsukuba1.png')));
im2 = im2single(rgb2gray(imread('tsukuba2.png')));
imwrite(im1, 'tsukuba1_gray.png');
imwrite(im2, 'tsukuba2_gray.png');

max_disparity = 33;

compute_disparity_error('tsukuba1_gray.png','tsukuba2_gray.png', 'tsukuba_gt.png', max_disparity)

% MSE calculation 
best_window_result = im2single(imread('11_by_25_AD_result.png'));
ground_truth = im2single(imread('tsukuba_gt.png'));

MSE = 0;
max_vert_dist = 0;

factor = size(best_window_result,1) / size(ground_truth,1);
% loop through all features
for i = 1: size(ground_truth,1)
    for j = 1: size(ground_truth,2)
        prediction = best_window_result(floor(i * factor),floor(j* factor));
        value = ground_truth(i,j) * max_disparity / max_disparity;
        MSE = MSE + (value - prediction)^2;
    end
end
MSE = MSE / (size(ground_truth,1) * size(ground_truth,2))
