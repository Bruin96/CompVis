function [best_SSD, best_size_SSD, best_XCORR, best_size_XCORR] = find_best_match(im1, im2, im_ref, top_win_size)
    best_SSD = '';
    best_XCORR = '';
    best_size_SSD = -1;
    best_size_XCORR = -1;
    lowest_SSD = realmax;
    highest_XCORR = realmin;
    [M, N] = size(im1);
        
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
        
        SSD_score(i) = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
        XCORR_score(i) = compute_normalized_cross_correlation(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
    end
    
    disp('Time for full loop:');
    time_ended = toc
    
    [curr_min_SSD, idx_SSD] = min(SSD_score);
    [curr_max_XCORR, idx_XCORR] = max(XCORR_score);
    
    if curr_min_SSD < lowest_SSD
        best_SSD = 'AD';
        best_size_SSD = 2*idx_SSD - 1;
        lowest_SSD = curr_min_SSD;
    end
    if curr_max_XCORR > highest_XCORR
        best_XCORR = 'AD';
        best_size_XCORR = 2*idx_XCORR - 1;
        highest_XCORR = curr_max_XCORR;
    end
    
    figure;
    subplot(2, 2, 1);
    plot(1:2:top_win_size, SSD_score);
    hold on
    title('SSD score absolute difference');
    xlabel('window size');
    ylabel('SSD score');
    hold off
    
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    disp('Computing best for SSD method');
    tic
    parfor i = 1:(top_win_size+1)/2 
        curr_win_size = i*2-1;
        disp(curr_win_size)
        dispar = compute_disparities_sum_squared_diff(im1, im2, curr_win_size, curr_win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score(i) = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
        XCORR_score(i) = compute_normalized_cross_correlation(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
    end
    
    disp('Time for full loop:');
    time_ended = toc
    
    [curr_min_SSD, idx_SSD] = min(SSD_score);
    [curr_max_XCORR, idx_XCORR] = max(XCORR_score);
    
    if curr_min_SSD < lowest_SSD
        best_SSD = 'SSD';
        best_size_SSD = 2*idx_SSD - 1;
        lowest_SSD = curr_min_SSD;
    end
    if curr_max_XCORR > highest_XCORR
        best_XCORR = 'SSD';
        best_size_XCORR = 2*idx_XCORR - 1;
        highest_XCORR = curr_max_XCORR;
    end
    
    subplot(2, 2, 2);
    plot(1:2:top_win_size, SSD_score);
    hold on
    title('SSD score sum squared difference');
    xlabel('window size');
    ylabel('SSD score');
    hold off
    
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    disp('Computing best for XCORR method');
    tic
    parfor i = 1:(top_win_size+1)/2 
        curr_win_size = i*2-1;
        disp(curr_win_size)
        dispar = compute_disparities_cross_correlation(im1, im2, curr_win_size, curr_win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score(i) = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
        XCORR_score(i) = compute_normalized_cross_correlation(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
    end
    
    disp('Time for full loop:');
    time_ended = toc
    
    [curr_min_SSD, idx_SSD] = min(SSD_score);
    [curr_max_XCORR, idx_XCORR] = max(XCORR_score);
    
    if curr_min_SSD < lowest_SSD
        best_SSD = 'XCORR';
        best_size_SSD = 2*idx_SSD - 1;
        lowest_SSD = curr_min_SSD;
    end
    if curr_max_XCORR > highest_XCORR
        best_XCORR = 'XCORR';
        best_size_XCORR = 2*idx_XCORR - 1;
        highest_XCORR = curr_max_XCORR;
    end
    
    subplot(2, 2, 3);
    plot(1:2:top_win_size, SSD_score);
    hold on
    title('SSD score normalised cross correlation');
    xlabel('window size');
    ylabel('SSD score');
    hold off
    
    best_SSD
    best_size_SSD
    best_XCORR
    best_size_XCORR
    
    disp('Computing best for PEARSON method');
    tic
    parfor i = 1:(top_win_size+1)/2 
        curr_win_size = i*2-1;
        disp(curr_win_size)
        dispar = compute_disparities_pearson(im1, im2, curr_win_size, curr_win_size);
        
        min_val = min(min(dispar));
        max_val = max(max(dispar));
        im_dispar = (dispar - min_val) ./(max_val - min_val);
        
        SSD_score = compute_sum_squared_difference(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
        XCORR_score = compute_normalized_cross_correlation(im_dispar(19:M-18, 19:N-18), im_ref(19:M-18, 19:N-18), M-36, N-36, 1, 1, 0);
    end
    
    disp('Time for full loop:');
    time_ended = toc
    
    [curr_min_SSD, idx_SSD] = min(SSD_score);
    [curr_max_XCORR, idx_XCORR] = max(XCORR_score);
    
    if curr_min_SSD < lowest_SSD
        best_SSD = 'PEARSON';
        best_size_SSD = 2*idx_SSD - 1;
        lowest_SSD = curr_min_SSD;
    end
    if curr_max_XCORR > highest_XCORR
        best_XCORR = 'PEARSON';
        best_size_XCORR = 2*idx_XCORR - 1;
        highest_XCORR = curr_max_XCORR;
    end
    
    subplot(2, 2, 4);
    plot(1:2:top_win_size, SSD_score);
    hold on
    title('SSD score pearson coefficient');
    xlabel('window size');
    ylabel('SSD score');
    hold off
    
end