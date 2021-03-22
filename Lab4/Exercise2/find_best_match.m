function [best_SSD, best_size_SSD, best_XCORR, best_size_XCORR] = find_best_match(im1, im2, im_ref)
    best_SSD = '';
    best_XCORR = '';
    best_size_SSD = -1;
    best_size_XCORR = -1;
    lowest_SSD = realmax;
    lowest_XCORR = realmax;
    [M, N] = size(im1);
    
    top_win_size = 41;
    
    SSD_score = zeros((top_win_size+1)/2, 1);
    XCORR_score = zeros((top_win_size+1)/2, 1);
    
    disp('Computing best for AD method');
    tic
    parfor i = 1:(top_win_size+1)/2 % Compute AD method first
        
        curr_win_size = i*2-1;
        disp(curr_win_size)
        dispar = compute_disparities_abs_diff(im1, im2, curr_win_size, curr_win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score(i) = compute_sum_squared_difference(im_dispar, im_ref, M, N, 1, 1, 0);
        XCORR_score(i) = compute_normalized_cross_correlation(im_dispar, im_ref, M, N, 1, 1, 0);
        %{
        if SSD_score < lowest_SSD
            best_SSD = 'AD';
            best_size_SSD = win_size;
            lowest_SSD = SSD_score;
        end
        if XCORR_score < lowest_XCORR
            best_XCORR = 'AD';
            best_size_XCORR = win_size;
            lowest_XCORR = XCORR_score;
        end
        %}
    end
    
    disp('Time for full loop:');
    time_ended = toc
    
    [curr_min_SSD, idx_SSD] = min(SSD_score);
    [curr_min_XCORR, idx_XCORR] = max(XCORR_score);
    
    if curr_min_SSD < lowest_SSD
        best_SSD = 'AD';
        best_size_SSD = 2*idx_SSD - 1;
        lowest_SSD = curr_min_SSD;
    end
    if curr_min_XCORR < lowest_XCORR
        best_XCORR = 'AD';
        best_size_XCORR = 2*idx_XCORR - 1;
        lowest_XCORR = curr_min_XCORR;
    end
    
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    disp('Computing best for SSD method');
    for win_size = 1:2:top_win_size 
        curr_win_size = win_size
        dispar = compute_disparities_sum_squared_diff(im1, im2, win_size, win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score = compute_sum_squared_difference(im_dispar, im_ref, M, N, 1, 1, 0);
        XCORR_score = compute_normalized_cross_correlation(im_dispar, im_ref, M, N, 1, 1, 0);
        if SSD_score < lowest_SSD
            best_SSD = 'SSD';
            best_size_SSD = win_size;
            lowest_SSD = SSD_score;
        end
        if XCORR_score < lowest_XCORR
            best_XCORR = 'SSD';
            best_size_XCORR = win_size;
            lowest_XCORR = XCORR_score;
        end
    end
    
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    disp('Computing best for XCORR method');
    for win_size = 1:2:top_win_size 
        curr_win_size = win_size
        dispar = compute_disparities_cross_correlation(im1, im2, win_size, win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score = compute_sum_squared_difference(im_dispar, im_ref, M, N, 1, 1, 0);
        XCORR_score = compute_normalized_cross_correlation(im_dispar, im_ref, M, N, 1, 1, 0);
        if SSD_score < lowest_SSD
            best_SSD = 'XCORR';
            best_size_SSD = win_size;
            lowest_SSD = SSD_score;
        end
        if XCORR_score < lowest_XCORR
            best_XCORR = 'XCORR';
            best_size_XCORR = win_size;
            lowest_XCORR = XCORR_score;
        end
    end
    
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    disp('Computing best for PEARSON method');
    for win_size = 1:2:top_win_size 
        curr_win_size = win_size
        dispar = compute_disparities_pearson(im1, im2, win_size, win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score = compute_sum_squared_difference(im_dispar, im_ref, M, N, 1, 1, 0);
        XCORR_score = compute_normalized_cross_correlation(im_dispar, im_ref, M, N, 1, 1, 0);
        if SSD_score < lowest_SSD
            best_SSD = 'PEARSON';
            best_size_SSD = win_size;
            lowest_SSD = SSD_score;
        end
        if XCORR_score < lowest_XCORR
            best_XCORR = 'PEARSON';
            best_size_XCORR = win_size;
            lowest_XCORR = XCORR_score;
        end
    end
    
    %{
    best
    best_size
    
    disp('Computing best for SNR method');
    for win_size = 1:2:41 
        curr_win_size = win_size
        dispar = compute_disparities_signal_to_noise(im1, im2, win_size, win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score = compute_sum_squared_difference(im_dispar, im_ref, M, N, 1, 1, 0);
        if SSD_score < lowest_SSD
            best = 'SNR';
            best_size = win_size;
            lowest_SSD = SSD_score;
        end
    end
    %}
end