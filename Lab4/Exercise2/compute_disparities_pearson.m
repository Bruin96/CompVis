function dispars = compute_disparities_pearson(im1, im2, win_height, win_width)
    [M, N] = size(im1);
    dispars = zeros(M, N, 'single');
    win_area = round(win_height*win_width);
    pad_width = floor(win_width/2);
    pad_height = floor(win_height/2);
    beam_size = win_height*N;
    
    max_disparity = 30;
    
    x_bottom = 1+pad_height;
    x_top = M-pad_height;
    y_bottom = 1+pad_width;
    y_top = N-pad_width;
    
    lower_bound = zeros(M, N, 'single');
    for y = y_bottom:y_top
        lower_bound(:, y) = max(1-y+pad_width, -max_disparity);
    end
    
    % Initialise costs matrix at a high value to facilitate minimum operation later on
    costs = 12000*ones(M, N, max_disparity+1, 'single'); 
    
    for x = x_bottom:x_top
        im1_beam = reshape(im1(x-pad_height:x+pad_height, :), [beam_size, 1]);
        im2_beam = reshape(im2(x-pad_height:x+pad_height, :), [beam_size, 1]);
        for y = y_bottom:y_top
            start_idx = 1 + (y-pad_width-1)*(win_height);
            im1_window = im1_beam(start_idx:start_idx+win_area-1);
            sum_im1_window = sum(sum(im1_window));
            start_idx_2 = (1+ (y+lower_bound(x, y)-pad_width-1)*win_height):win_height:(1+(y-pad_width-1)*win_height);
            for d = 1:-lower_bound(x,y)+1
                im2_window = im2_beam(start_idx_2(d):start_idx_2(d)+win_area-1);
                sum_im2_window = sum(sum(im2_window));
                costs(x, y, -(d+lower_bound(x,y)-2)) = (win_area*sum(sum(im1_window.*im2_window)) - sum_im1_window*sum_im2_window) / (sqrt(win_area*sum(sum(im1_window.^2)) - sum_im1_window.^2) * sqrt(win_area*sum(sum(im2_window.^2)) - sum_im2_window.^2));
            end
        end
    end   
    
    [~, dispar_val] = max(costs(x_bottom:x_top, y_bottom:y_top, :), [], 3);
    dispars(x_bottom:x_top, y_bottom:y_top) = dispar_val-1;
end