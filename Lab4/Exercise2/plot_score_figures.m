function [] = plot_score_figures(AD_scores, SSD_scores, XCORR_scores, top_win_size)
    % Plot AD scores
    figure;
    subplot(1, 3, 1);
    plot(1:2:top_win_size, AD_scores(1, :));
    hold on
    title('AD score absolute difference', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('AD score', 'FontSize', 14);
    ylim([5000 26000]);
    hold off
    
    subplot(1, 3, 2);
    plot(1:2:top_win_size, AD_scores(2, :));
    hold on
    title('AD score sum of squared difference', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('AD score', 'FontSize', 14);
    ylim([5000 26000]);
    hold off
    
    subplot(1, 3, 3);
    plot(1:2:top_win_size, AD_scores(3, :));
    hold on
    title('AD score normalised cross correlation', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('AD score', 'FontSize', 14);
    ylim([5000 26000]);
    hold off

    % Plot SSD scores
    figure;
    subplot(1, 3, 1);
    plot(1:2:top_win_size, SSD_scores(1, :));
    hold on
    title('SSD score absolute difference', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('SSD score', 'FontSize', 14);
    ylim([1000 10000]);
    hold off
    
    subplot(1, 3, 2);
    plot(1:2:top_win_size, SSD_scores(2, :));
    hold on
    title('SSD score sum of squared difference', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('SSD score', 'FontSize', 14);
    ylim([1000 10000]);
    hold off
    
    subplot(1, 3, 3);
    plot(1:2:top_win_size, SSD_scores(3, :));
    hold on
    title('SSD score normalised cross correlation', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('SSD score', 'FontSize', 14);
    ylim([1000 10000]);
    hold off
    
    % Plot XCORR scores
    figure;
    subplot(1, 3, 1);
    plot(1:2:top_win_size, XCORR_scores(1, :));
    hold on
    title('XCORR score absolute difference', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('XCORR score', 'FontSize', 14);
    ylim([0.75 1]);
    hold off
    
    subplot(1, 3, 2);
    plot(1:2:top_win_size, XCORR_scores(2, :));
    hold on
    title('XCORR score sum of squared difference', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('XCORR score', 'FontSize', 14);
    ylim([0.75 1]);
    hold off
    
    subplot(1, 3, 3);
    plot(1:2:top_win_size, XCORR_scores(3, :));
    hold on
    title('XCORR score normalised cross correlation', 'FontSize', 12);
    xlabel('window size', 'FontSize', 14);
    ylabel('XCORR score', 'FontSize', 14);
    ylim([0.75 1]);
    hold off
end