function [best_AD, best_size_AD, best_SSD, best_size_SSD, best_XCORR, best_size_XCORR] = find_best_match_rectangle(im1, im2, im_ref, top_win_size)
    best_AD = '';
    best_size_AD = [-1, -1];
    best_SSD = '';
    best_XCORR = '';
    best_size_SSD = [-1, -1];
    best_size_XCORR = [-1, -1];
    lowest_AD = realmax;
    lowest_SSD = realmax;
    highest_XCORR = realmin;
    [M, N] = size(im1);
    
    AD_score = zeros((top_win_size+1)/2);
    SSD_score = zeros((top_win_size+1)/2);
    XCORR_score = zeros((top_win_size+1)/2);
    
    half_win_size = round((top_win_size+1)/2);
    
    
    disp('Computing best for AD method');
    tic
    parfor i = 1:half_win_size 
        curr_win_height = i*2-1;
        disp(curr_win_height)
        for j = 1:half_win_size
            dispar = zeros(M, N);
            curr_win_width = j*2-1;

            dispar_vals = compute_disparities_abs_diff(im1, im2, curr_win_height, curr_win_width);
            percentile = prctile(dispar_vals(:), 99.9);
            dispar_vals(dispar_vals > percentile) = 0;
            dispar(19:M-18, 19:N-18) = dispar_vals(19:M-18, 19:N-18);
        
            min_val = min(min(dispar));
            max_val = max(max(dispar));
            im_dispar = (dispar - min_val) ./(max_val - min_val);
        
            AD_score(i, j) = compute_absolute_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
            SSD_score(i, j) = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
            XCORR_score(i, j) = compute_normalized_cross_correlation(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
        end
    end
    
    
    disp('Time for full loop:');
    time_ended = toc
    
    % Compute lowest score for all three comparison metrics
    [curr_min_AD, idx_AD] = min(AD_score(:));
    [curr_min_SSD, idx_SSD] = min(SSD_score(:));
    [curr_max_XCORR, idx_XCORR] = max(XCORR_score(:));
    
    if curr_min_AD < lowest_AD
        best_height = 2*mod(idx_AD-1, half_win_size)+1;
        best_width = 2*floor((idx_AD-1)/half_win_size)+1;
        best_AD = 'AD';
        best_size_AD = [best_height, best_width];
        lowest_AD = curr_min_AD;
    end
    if curr_min_SSD < lowest_SSD
        best_height = 2*mod(idx_SSD-1, half_win_size)+1;
        best_width = 2*floor((idx_SSD-1)/half_win_size)+1;
        best_SSD = 'AD';
        best_size_SSD = [best_height, best_width];
        lowest_SSD = curr_min_SSD;
    end
    if curr_max_XCORR > highest_XCORR
        best_height = 2*mod((idx_XCORR-1), half_win_size)+1;
        best_width = 2*floor((idx_XCORR-1)/half_win_size)+1;
        best_XCORR = 'AD';
        best_size_XCORR = [best_height, best_width];
        highest_XCORR = curr_max_XCORR;
    end
    
    best_AD
    best_size_AD
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    
    disp('Computing best for SSD method');
    tic
    parfor i = 1:(top_win_size+1)/2 
        curr_win_height = i*2-1;
        disp(curr_win_height)
        for j = 1:half_win_size
            dispar = zeros(M, N);
            curr_win_width = j*2-1;

            dispar_vals = compute_disparities_sum_squared_diff(im1, im2, curr_win_height, curr_win_width);
            percentile = prctile(dispar_vals(:), 99.9);
            dispar_vals(dispar_vals > percentile) = 0;
            dispar(19:M-18, 19:N-18) = dispar_vals(19:M-18, 19:N-18);
        
            min_val = min(min(dispar));
            max_val = max(max(dispar));
            im_dispar = (dispar - min_val) ./(max_val - min_val);
        
            AD_score(i, j) = compute_absolute_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
            SSD_score(i, j) = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
            XCORR_score(i, j) = compute_normalized_cross_correlation(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
        end
    end
    
    disp('Time for full loop:');
    time_ended = toc
    
    % Compute lowest score for all three comparison metrics
    [curr_min_AD, idx_AD] = min(AD_score(:));
    [curr_min_SSD, idx_SSD] = min(SSD_score(:));
    [curr_max_XCORR, idx_XCORR] = max(XCORR_score(:));
    
    if curr_min_AD < lowest_AD
        best_height = 2*mod(idx_AD-1, half_win_size)+1;
        best_width = 2*floor((idx_AD-1)/half_win_size)+1;
        best_AD = 'SSD';
        best_size_AD = [best_height, best_width];
        lowest_AD = curr_min_AD;
    end
    if curr_min_SSD < lowest_SSD
        best_height = 2*mod(idx_SSD-1, half_win_size)+1;
        best_width = 2*floor((idx_SSD-1)/half_win_size)+1;
        best_SSD = 'SSD';
        best_size_SSD = [best_height, best_width];
        lowest_SSD = curr_min_SSD;
    end
    if curr_max_XCORR > highest_XCORR
        best_height = 2*mod((idx_XCORR-1), half_win_size)+1;
        best_width = 2*floor((idx_XCORR-1)/half_win_size)+1;
        best_XCORR = 'SSD';
        best_size_XCORR = [best_height, best_width];
        highest_XCORR = curr_max_XCORR;
    end
    
    best_AD
    best_size_AD
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    disp('Computing best for XCORR method');
    tic
    parfor i = 1:(top_win_size+1)/2 
        curr_win_height = i*2-1;
        disp(curr_win_height)
        for j = 1:half_win_size
            dispar = zeros(M, N);
            curr_win_width = j*2-1;
            
            dispar_vals = compute_disparities_cross_correlation(im1, im2, curr_win_height, curr_win_width);
            percentile = prctile(dispar_vals(:), 99.9);
            dispar_vals(dispar_vals > percentile) = 0;
            dispar(19:M-18, 19:N-18) = dispar_vals(19:M-18, 19:N-18);
            
            min_val = min(min(dispar));
            max_val = max(max(dispar));
            im_dispar = (dispar - min_val) ./(max_val - min_val);
        
            AD_score(i, j) = compute_absolute_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
            SSD_score(i, j) = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
            XCORR_score(i, j) = compute_normalized_cross_correlation(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
        end
    end
    
    disp('Time for full loop:');
    time_ended = toc
    
    % Compute lowest score for all three comparison metrics
    [curr_min_AD, idx_AD] = min(AD_score(:));
    [curr_min_SSD, idx_SSD] = min(SSD_score(:));
    [curr_max_XCORR, idx_XCORR] = max(XCORR_score(:));
    
    if curr_min_AD < lowest_AD
        best_height = 2*mod(idx_AD-1, half_win_size)+1;
        best_width = 2*floor((idx_AD-1)/half_win_size)+1;
        best_AD = 'XCORR';
        best_size_AD = [best_height, best_width];
        lowest_AD = curr_min_AD;
    end
    if curr_min_SSD < lowest_SSD
        best_height = 2*mod(idx_SSD-1, half_win_size)+1;
        best_width = 2*floor((idx_SSD-1)/half_win_size)+1;
        best_SSD = 'XCORR';
        best_size_SSD = [best_height, best_width];
        lowest_SSD = curr_min_SSD;
    end
    if curr_max_XCORR > highest_XCORR
        best_height = 2*mod((idx_XCORR-1), half_win_size)+1;
        best_width = 2*floor((idx_XCORR-1)/half_win_size)+1;
        best_XCORR = 'XCORR';
        best_size_XCORR = [best_height, best_width];
        highest_XCORR = curr_max_XCORR;
    end

end