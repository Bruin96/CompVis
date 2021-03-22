function SNR_diff = compute_signal_to_noise_ratio(padded_im1, padded_im2, win_height, win_width, x, y, disparity)
    im1 = padded_im1(x:x+win_height-1, y:y+win_width-1);
    im2 = padded_im2(x:x+win_height-1, y+disparity:y+disparity+win_width-1);
    
    [m, n] = size(im1);
    
    SNR1 = mean(reshape(im1, [1, m*n])) / std(reshape(im1, [1, m*n]));
    SNR2 = mean(reshape(im2, [1, m*n])) / std(reshape(im2, [1, m*n]));
    
    SNR_diff = sqrt(SNR1 - SNR2);
end