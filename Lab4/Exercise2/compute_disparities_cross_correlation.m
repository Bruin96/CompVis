function dispars = compute_disparities_cross_correlation(im1, im2, win_height, win_width)
    [M, N] = size(im1);
    dispars = zeros(M, N);
    win_size = max(win_height, win_width);
        
    pad_size = floor(win_size/2);
    padded_im1 = zeros(M+2*pad_size, N+2*pad_size);
    padded_im1(pad_size+1:M+pad_size, pad_size+1:N+pad_size) = im1;
    padded_im2 = zeros(M+2*pad_size, N+2*pad_size);
    padded_im2(pad_size+1:M+pad_size, pad_size+1:N+pad_size) = im2;
    
    x_bottom = 1+pad_size;
    x_top = M-pad_size;
    y_bottom = 1+pad_size;
    y_top = N-pad_size;
    
    tic
    parfor x = x_bottom:x_top
        for y = y_bottom:y_top
            %y
            max_diff = realmin;
            lower_bound = max(1-y+pad_size, -round(30));
            upper_bound = min(N-y, round(0));
            for d = lower_bound:upper_bound % Try all possible disparities
                abs_diff_val = compute_normalized_cross_correlation(padded_im1, padded_im2, win_height, win_width, x, y, d);
                if abs_diff_val > max_diff
                    max_diff = abs_diff_val;
                    dispars(x, y) = -d;
                end
            end
        end
    end
    toc
end