function ssd = compute_sum_squared_difference(padded_im1, padded_im2, win_size, x, y, disparity)
    ssd = sum(sum((padded_im1(x:x+win_size-1, y:y+win_size-1) - padded_im2(x:x+win_size-1, y+disparity:y+disparity+win_size-1)).^2));
end