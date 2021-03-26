The source code for exercises 2 and 3 are included in the same folder (Exercise2), since the code for the two exercises is mostly the same.

For exercises 2 and 3, the following scripts can be run:
- run_exercise_2.m: This script executes the code for a certain window width, window height, and window comparison metric ('AD', 'SSD', or 'XCORR'). You can change these values to get different results. The script visualises the resulting disparity map, and tells you the MSE compared with the ground truth.
- run_find_best_match.m: This script executes an exhaustive search of all possible square windows up to the maximum window size given in the script (top_win_size). At the end, it tells you the best window size according to each comparison metric.
- run_find_best_match_rectangle.m: This script executes an exhaustive search for all possible window shapes between the given maximum size. At the end, it tells you the best window shape according to each comparison metric.