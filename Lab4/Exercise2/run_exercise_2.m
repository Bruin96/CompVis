
im1 = im2double(rgb2gray(imread('scene1.row3.col3.ppm')));
im2 = im2double(rgb2gray(imread('scene1.row3.col4.ppm')));
im_true = im2double(imread('truedisp.row3.col3.pgm'));

[M, N] = size(im1);
win_height = 11;
win_width = 25;
dispars = compute_disparities(im1, im2, 'AD', win_height, win_width);
percentile = prctile(dispars(:), 99.9);
dispars(dispars > percentile) = 0; % Set values above 99.9th percentile to zero to reduce noise impact
disparities = zeros(M, N);
disparities(19:M-18, 19:N-18) = dispars(19:M-18, 19:N-18); % Ground truth has a black border of 18 pixels, so we ignore those values

% Convert disparity to grey-scale
min_val = min(min(disparities));
max_val = max(max(disparities));
im_dispar = (disparities - min_val) ./(max_val - min_val);

SSD_score = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_true(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);

diff_image = 0.5 + im_true - im_dispar;

%imshow([im_dispar, im_true, diff_image]);
%imshow([im_dispar, im_true]);
imshow(im_dispar);

% Compute MSE
MSE = sum(sum((im_dispar-im_true).^2));
MSE = MSE / ((M-36)*(N-36))
