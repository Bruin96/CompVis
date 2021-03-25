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
[~, des1, loc1] = sift(image1);
[~, des2, loc2] = sift(image2);

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

ground_truth = im2single(imread(ground_truth_image));

MSE = 0;
% loop through all features
for i = 1: size(des1,1)
  if (match(i) > 0)
    prediction = abs(loc1(i,2)-loc2(match(i),2));
    value = ground_truth(floor(loc1(i,1)), floor(loc1(i,2))) * max_disparity;
    MSE = MSE + (value - prediction)^2;
  end
end
MSE = MSE / size(des1,1);




