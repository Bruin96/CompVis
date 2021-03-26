im3 = im2double(rgb2gray(imread('scene1.row3.col3.ppm')));
im4 = im2double(rgb2gray(imread('scene1.row3.col4.ppm')));
im3_true = im2double(imread('truedisp.row3.col3.pgm'));

[best_AD, best_size_AD, best_SSD, best_size_SSD, best_XCORR, best_size_XCORR] = find_best_match_rectangle(im3, im4, im3_true, 41)