function cross_corr = compute_normalized_cross_correlation(padded_im1, padded_im2, win_height, win_width, x, y, disparity)
    
    im1 = padded_im1(x:x+win_height-1, y:y+win_width-1);
    im2 = padded_im2(x:x+win_height-1, y+disparity:y+disparity+win_width-1);
    cross_corr = sum(sum(im1 .* im2)) / sqrt(sum(sum(im1 .^2)) * sum(sum(im2.^2)));
end