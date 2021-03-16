function cross_corr = compute_normalized_cross_correlation(padded_im1, padded_im2, win_size, x, y, disparity)
    
    im1 = padded_im1(x:x+win_size-1, y:y+win_size-1);
    im2 = padded_im2(x:x+win_size-1, y+disparity:y+disparity+win_size-1);
    cross_corr = sum(sum(im1 .* im2)) / sqrt(sum(sum(im1 .^2)) * sum(sum(im2.^2)));
end