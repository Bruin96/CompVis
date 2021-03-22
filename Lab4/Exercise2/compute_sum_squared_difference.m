function ssd = compute_sum_squared_difference(padded_im1, padded_im2, win_height, win_width, x, y, disparity)
    ssd = sum(sum((padded_im1(x:x+win_height-1, y:y+win_width-1) - padded_im2(x:x+win_height-1, y+disparity:y+disparity+win_width-1)).^2));
end