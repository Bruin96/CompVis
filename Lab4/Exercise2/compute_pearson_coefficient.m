function r = compute_pearson_coefficient(padded_im1, padded_im2, win_size, x, y, disparity)
    im1 = padded_im1(x:x+win_size-1, y:y+win_size-1);
    im2 = padded_im2(x:x+win_size-1, y+disparity:y+disparity+win_size-1);
    
    [m, n] = size(im1);
    
    r = (m*n*sum(sum(im1.*im2)) - sum(sum(im1))*sum(sum(im2))) / (sqrt(m*n*sum(sum(im1.^2)) - (sum(sum(im1))).^2) * sqrt(m*n*sum(sum(im2.^2)) - (sum(sum(im2))).^2));
end