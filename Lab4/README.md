# LAB 4 Computer Vision
The source code for exercises 2 and 3 are included in the same folder (Exercise2), since the code for the two exercises is mostly the same.
## Exercise 1
For exercises 1, the scripts `run_exercise_1.m` can be run from Matlab. Then, a number of matching feature points needs to be selected. First the left image from the stereo pair appears. Left click selects a feature point, after which the right image from the stereo pair appears. Select a matching feature point here. To end the selection, use the right mouse button to select the last feature point. The selection of feature points can only be ended when the right image is visible, such that for each feature point a match exists. Afterwards, the minimum and maximum disparity values are displayed. The script also returns the MSE value which is a measure for the accuracy compared to the ground truth image.

# Exercise 2 and Exercise 3
For exercises 2 and 3, the following scripts can be run:
- `run_exercise_2.m`: This script executes the code for a certain window width, window height, and window comparison metric ('AD', 'SSD', or 'XCORR'). You can change these values to get different results. The script visualises the resulting disparity map, and tells you the MSE compared with the ground truth.
- `run_find_best_match.m`: This script executes an exhaustive search of all possible square windows up to the maximum window size given in the script (top_win_size). At the end, it tells you the best window size according to each comparison metric.
- `run_find_best_match_rectangle.m`: This script executes an exhaustive search for all possible window shapes between the given maximum size. At the end, it tells you the best window shape according to each comparison metric.

# Exercise 4
For exercises 4, the scripts `run_exercise_4.m` can be run from Matlab. A number of matching feature points is automatically selected using the SIFT method. An image appears where the matching feature points are connected using lines. A red line means that the matching feature points do not lie on the same horizontal axis, a cyan line means that the matching feature points are located on the same horizontal axis. Afterwards, the minimum and maximum disparity values are displayed along with the maximum vertical distance in pixels between the matched feature points. The script also returns the MSE value which is a measure for the accuracy compared to the ground truth image.
