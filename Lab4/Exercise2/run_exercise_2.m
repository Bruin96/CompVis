
im1 = im2double(rgb2gray(imread('scene1.row3.col3.ppm')));
im2 = im2double(rgb2gray(imread('scene1.row3.col4.ppm')));
im_true = im2double(imread('truedisp.row3.col3.pgm'));
im_true_int = imread('truedisp.row3.col3.pgm');

%figure;
%imshow(im1);
%figure;
%imshow(im2);

im1_gpu = gpuArray(single(im1));
im2_gpu = gpuArray(single(im2));

[M, N] = size(im1);
win_height = 9;
win_width = 25;
dispars = compute_disparities(im1, im2, 'AD', win_height, win_width);
percentile = prctile(dispars(:), 99.9);
dispars(dispars > percentile) = 0;
disparities = zeros(M, N);
disparities(19:M-18, 19:N-18) = dispars(19:M-18, 19:N-18);



% Convert disparity to grey-scale
min_val = min(min(disparities));
max_val = max(max(disparities));
im_dispar = (disparities - min_val) ./(max_val - min_val);
im_dispar_int = round(255*im_dispar);

SSD_score = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_true(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);

diff_image = 0.5 + im_true - im_dispar;

%imshow([im_dispar, im_true, diff_image]);
%imshow([im_dispar, im_true]);
imshow(im_dispar);

%imshow(disparities);