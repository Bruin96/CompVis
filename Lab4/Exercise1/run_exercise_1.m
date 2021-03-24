close all;
im1 = im2single(rgb2gray(imread('tsukuba1.png')));
im2 = im2single(rgb2gray(imread('tsukuba2.png')));
ground_truth = im2single(imread('tsukuba_gt.png'));


compute_disparity_error(im1, im2, ground_truth)
