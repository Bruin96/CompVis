% MSE = compute_disparity_error(image1, image2, ground_truth_image, filter)
%
% This function reads a set of stereo pair images, finds their SIFT features, 
% and computes the disparity values between the features.
% After the disparity values are obtained, the function computes the MSE
% using the ground truth image. A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match. If filter is set to true, matches that do not 
%   lie on the same horizontal axis are removed. If set to false, the
%   results are included in the MSE calculation.
% The MSE values is returned. The maximal vertical distance in
% matches, the maximum disparity and the mininum disparity are also displayed to
% the user.
%
% Example: match('tsukuba1.png','tsukuba2.png', 'tsukuba_gt.png', true);

function MSE = compute_disparity_error(image1, image2, ground_truth_image, filter)

% Find SIFT keypoints for each image
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end

% Create a new image showing the two images side by side.
im3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
for i = 1: size(des1,1)
  if (match(i) > 0)
      if (loc1(i,1) == loc2(match(i),1))
        line([loc1(i,2) loc2(match(i),2)+cols1], ...
         [loc1(i,1) loc2(match(i),1)], 'Color', 'c');
      else
           line([loc1(i,2) loc2(match(i),2)+cols1], ...
         [loc1(i,1) loc2(match(i),1)], 'Color', 'r');
      end
  end
end
hold off;
num = sum(match > 0);
fprintf('Found %d matches.\n', num);

ground_truth = im2single(imread(ground_truth_image));

predictions = NaN(size(ground_truth));
vert_dist = [];
% loop through all features
for i = 1: size(des1,1) 
  if (match(i) > 0)
      % if match does not have vertical deviation
      if (~filter || loc1(i,1) == loc2(match(i),1))
         predictions(floor(loc1(i,1)), floor(loc1(i,2))) = abs(loc1(i,2)-loc2(match(i),2));
      end
      if (loc1(i,1) ~= loc2(match(i),1))
         vert_dist(i) = abs(loc1(i,1) - loc2(match(i),1));

     end
  end
end
minimum_disparity = min(min(predictions))
maximum_disparity = max(max(predictions))
maximum_vertical_distance = max(vert_dist)

not_nan = ~isnan(predictions);
predictions(not_nan) = (predictions(not_nan) - max(max(predictions(not_nan)))) ./ (max(max(predictions(not_nan))) - min(min(predictions(not_nan))));
ground_truth_norm = (ground_truth - max(max(ground_truth))) ./ (max(max(ground_truth)) - min(min(ground_truth)));
MSE = sum(sum((ground_truth_norm(not_nan) - predictions(not_nan)).^2)) /  size(des1,1);



