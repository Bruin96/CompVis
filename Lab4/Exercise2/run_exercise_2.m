im1 = im2double(rgb2gray(imread('tsukuba1.png')));
im2 = im2double(rgb2gray(imread('tsukuba2.png')));

%figure;
%imshow(im1);
%figure;
%imshow(im2);

[M, N] = size(im1);
disparities = compute_disparities(im1, im2, 'SSD'); % Values in range [-M, +M]

% Convert disparity to grey-scale
min_val = min(min(disparities));
max_val = max(max(disparities));
im_dispar = (disparities - min_val) ./(max_val - min_val);
imshow(im_dispar);


%imshow(disparities);