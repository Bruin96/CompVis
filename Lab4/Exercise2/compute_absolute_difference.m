function abs_diff = compute_absolute_difference(padded_im1, padded_im2, win_height, win_width, x, y, disparity)
%abs_diff = 0;
    %disparity
    %[M, N] = size(padded_im2)
    %im1 = padded_im1(x:x+win_height-1, y:y+win_width-1);
    %im2 = padded_im2(x:x+win_height-1, y+disparity:y+disparity+win_width-1);
    abs_diff = sum(sum(abs(padded_im1(x:x+win_height-1, y:y+win_width-1) - padded_im2(x:x+win_height-1, y+disparity:y+disparity+win_width-1))));
    %abs_diff = sum(sum(abs(padded_im1(x-pad_height:x+pad_height, y-pad_width:y+pad_width) - padded_im2(x-pad_height:x+pad_height, y+disparity-pad_width:y+disparity+pad_width))));
end