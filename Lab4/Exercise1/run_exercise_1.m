close all;
im1 = im2single(rgb2gray(imread('tsukuba1.png')));
im2 = im2single(rgb2gray(imread('tsukuba2.png')));

% imshow(im1 - im2)
map = compute_disparity(im1, im2)

imshow(map)