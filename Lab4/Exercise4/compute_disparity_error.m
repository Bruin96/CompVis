% num = match(image1, image2)
%
% This function reads a set of stereo pair images, finds their SIFT features, 
% and computes the disparity values between the features. A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% After the disparity values are obtained, the function computes the MSE
% using the ground truth image
% The MSE values is returned.
%
% Example: match('tsukuba1.png','tsukuba2.png', 'tsukuba_gt.png', 33);

function MSE = compute_disparity_error(image1, image2, ground_truth_image, max_disparity)

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
max_vert_dist = 0;
% loop through all features
for i = 1: size(des1,1) 
  if (match(i) > 0)
      % if match does not have vertical deviation
      if (loc1(i,1) == loc2(match(i),1))
         predictions(floor(loc1(i,1)), floor(loc1(i,2))) = abs(loc1(i,2)-loc2(match(i),2));
      else
         dist = abs(loc1(i,1) - loc2(match(i),1));
         if (dist > max_vert_dist)
             max_vert_dist = dist;
         end
     end
  end
end
minimum_disparity = min(min(predictions))
maximum_disparity = max(max(predictions))
not_nan = ~isnan(predictions);
predictions(not_nan) = (predictions(not_nan) - max(predictions(not_nan))) ./ (max(predictions(not_nan)) - min(predictions(not_nan)));
ground_truth_norm = (ground_truth - max(ground_truth)) ./ (max(ground_truth) - min(ground_truth));
MSE = sum(sum((ground_truth_norm(not_nan) - predictions(not_nan)).^2)) /  size(des1,1);
max_vert_dist



