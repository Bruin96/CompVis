im1 = im2single(rgb2gray(imread('tsukuba1.png')));
im2 = im2single(rgb2gray(imread('tsukuba2.png')));

%figure;
%imshow(im1);
%figure;
%imshow(im2);

im1_gpu = gpuArray(single(im1));
im2_gpu = gpuArray(single(im2));

[M, N] = size(im1);
win_height = 5;
win_width = 5;
disparities = compute_disparities(im1, im2, 'XCORR', win_height, win_width);

% Convert disparity to grey-scale
min_val = min(min(disparities));
max_val = max(max(disparities));
im_dispar = (disparities - min_val) ./(max_val - min_val);
imshow(im_dispar);


%imshow(disparities);