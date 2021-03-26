close all;
% Since SIFT only accepts gray scale images, we need to convert the input
% stereo pair images
im1 = im2single(rgb2gray(imread('tsukuba1.png')));
im2 = im2single(rgb2gray(imread('tsukuba2.png')));
imwrite(im1, 'tsukuba1_gray.png');
imwrite(im2, 'tsukuba2_gray.png');

compute_disparity_error('tsukuba1_gray.png','tsukuba2_gray.png', 'tsukuba_gt.png')
