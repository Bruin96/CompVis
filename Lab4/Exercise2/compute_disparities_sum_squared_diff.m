function dispars = compute_disparities_sum_squared_diff(im1, im2, win_height, win_width)
    [M, N] = size(im1);
    dispars = zeros(M, N, 'single');
    pad_width = floor(win_width/2);
    pad_height = floor(win_height/2);
    
    max_disparity = 32;
    
    x_bottom = 1+pad_height;
    x_top = M-pad_height;
    y_bottom = 1+pad_width;
    y_top = N-pad_width;
    
    lower_bound = zeros(M, N, 'single');
    for y = y_bottom:y_top
        lower_bound(:, y) = max(1-y+pad_width, -max_disparity);
    end
    
    % Initialise costs matrix at a high value to facilitate minimum operation later on
    row_vals = zeros(M, N, max_disparity+1, 'single');
    costs = 12000*ones(M, N, max_disparity+1, 'single'); 
    
    im_beam = im1(x_bottom-pad_height:x_bottom+pad_height, :);
    for y = y_bottom:y_top
        im1_window = im_beam(:, y-pad_width:y+pad_width);
        for d = lower_bound(x_bottom, y):0
            im2_window = im2(x_bottom-pad_height:x_bottom+pad_height, y+d-pad_width:y+d+pad_width);
            abs_diff = 0;
            for i = x_bottom-pad_height:x_bottom+pad_height
                row_vals(i, y, -d+1) = sum((im1_window(i, :) - im2_window(i, :)).^2);
                abs_diff = abs_diff + row_vals(i, y, -d+1);
            end
            costs(x_bottom, y, -d+1) = abs_diff;
        end
    end
    
    % Compute disparity for leftmost column
    for x = x_bottom+1:x_top
        for d = lower_bound(x, y_bottom):0
            row_vals(x+pad_height, y_bottom, -d+1) = sum((im1(x+pad_height, y_bottom-pad_width:y_bottom+pad_width) - im2(x+pad_height, y_bottom+d-pad_width:y_bottom+d+pad_width)).^2);
            costs(x, y_bottom, -d+1) = costs(x-1,y_bottom, -d+1) - row_vals(x-1-pad_height, y_bottom, -d+1) + row_vals(x+pad_height, y_bottom, -d+1);
        end
    end
    
    one_plus_pad_width = 1 + pad_width;
    one_plus_pad_height = 1+pad_height;
    
    for x = x_bottom+1:x_top
        x_neg_offset = x-one_plus_pad_height;
        x_pos_offset = x+pad_height;
        for y = y_bottom+1:y_bottom+max_disparity+1
                val_1_1 = im1(x-one_plus_pad_height,y-one_plus_pad_width);
                val_1_2 = im1(x-one_plus_pad_height, y+pad_width);
                val_1_3 = im1(x+pad_height, y-one_plus_pad_width);
                val_1_4 = im1(x+pad_height, y+pad_width);
                for d = lower_bound(x, y)+1:0
                    costs(x, y, -d+1) = costs(x-1, y, -d+1) + costs(x, y-1, -d+1) - costs(x-1, y-1, -d+1) + ...
                        (val_1_1 - im2(x_neg_offset, y+d-one_plus_pad_width))^2 - ...
                        (val_1_2 - im2(x_neg_offset, y+d+pad_width))^2 - ...
                        (val_1_3 - im2(x_pos_offset, y+d-one_plus_pad_width))^2 + ...
                        (val_1_4 - im2(x_pos_offset, y+d+pad_width))^2;
                end
                row_vals(x+pad_height, y, -lower_bound(x, y)+1) = sum((im1(x_pos_offset, y-pad_width:y+pad_width) - im2(x_pos_offset, y+lower_bound(x, y)-pad_width:y+lower_bound(x, y)+pad_width)).^2);
                costs(x, y, -lower_bound(x, y)+1) = costs(x-1, y, -lower_bound(x, y)+1) - row_vals(x_neg_offset, y, -lower_bound(x, y)+1) + row_vals(x_pos_offset, y, -lower_bound(x, y)+1);
        end
    end        
    
    for x = x_bottom+1:x_top
        for y = y_bottom+max_disparity+2:y_top
            if y <= y_bottom+max_disparity+1 % lower_bound changes in this region, so we can't use area table here
                im1_window = im1(x+pad_height, y-pad_width:y+pad_width);
                for d = lower_bound(x, y):0
                    row_vals(x+pad_height, y, -d+1) = sum((im1_window - im2(x+pad_height, y+d-pad_width:y+d+pad_width)).^2);
                    costs(x, y, -d+1) = costs(x-1, y, -d+1) - row_vals(x-1-pad_height, y, -d+1) + row_vals(x+pad_height, y, -d+1);
                end
            else % We use full dynamic programming here
                for d = lower_bound(x, y):0
                    %x
                    %y
                    %d
                    costs(x, y, -d+1) = costs(x-1, y, -d+1) + costs(x, y-1, -d+1) - costs(x-1, y-1, -d+1) + ...
                        (im1(x-1-pad_height, y-1-pad_width) - im2(x-1-pad_height, y-1+d-pad_width))^2 - ...
                        (im1(x-1-pad_height, y+pad_width) - im2(x-1-pad_height, y+d+pad_width))^2 - ...
                        (im1(x+pad_height, y-1-pad_width) - im2(x+pad_height, y-1+d-pad_width))^2 + ...
                        (im1(x+pad_height, y+pad_width) - im2(x+pad_height, y+d+pad_width))^2;
                end
                
            end
        end
    end
    
    [~, dispar_val] = min(costs(x_bottom:x_top, y_bottom:y_top, :), [], 3);
    dispars(x_bottom:x_top, y_bottom:y_top) = dispar_val-1;
    
end