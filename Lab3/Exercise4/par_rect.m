function [f, dir_vecs, normal] = par_rect(file1, file2)
    par_set1 = readfile(file1);
    par_set2 = readfile(file2);
    
    min_vec1 = compute_min_vec(par_set1); % x_a = (x_1, x_2, x_3)
    min_vec2 = compute_min_vec(par_set2); % x_b = (x_4, x_5, x_6)
    
    % Compute focal length (in units of pixels!): f = sqrt(- (x_1*x_4 + x_2*x_5) / (x_3*x_6))
    f = sqrt(- (min_vec1(1)*min_vec2(1) + min_vec1(2)*min_vec2(2))/(min_vec1(3)*min_vec2(3)));
    
    % Compute direction vectors and normalise them
    dir_vecs = zeros(2, 3);
    dir_vecs(1, 1) = min_vec1(1)/f; dir_vecs(1, 2) = min_vec1(2)/f; dir_vecs(1, 3) = min_vec1(3);
    dir_vecs(2, 1) = min_vec2(1)/f; dir_vecs(2, 2) = min_vec2(2)/f; dir_vecs(2, 3) = min_vec2(3);
    dir_vecs(1, :) = dir_vecs(1, :) ./ norm(dir_vecs(1, :)); 
    dir_vecs(2, :) = dir_vecs(2, :) ./ norm(dir_vecs(2, :)); 
    
    dot_dir_vecs = dot(dir_vecs(1, :), dir_vecs(2, :))
    
    van_point1 = compute_vanishing_point(dir_vecs(1, :), f);
    van_point2 = compute_vanishing_point(dir_vecs(2, :), f);
    
    % Solve the equation M * (A B C)' = (0 0 0)', with M = [w_1 w_2 w_3; u_inf1 v_inf1 f; u_inf2 v_inf2 f]
    M = [dir_vecs(1, 1) dir_vecs(1, 2) dir_vecs(1, 3); dir_vecs(2, 1) dir_vecs(2, 2) dir_vecs(2, 3); van_point1(1) van_point1(2) f; van_point2(1) van_point2(2) f];
    
    [~, ~, V] = svd(M);
    
    normal = V(:, end); % Extract minimum vector from V
    
    if normal(3) > eps % We found the backward-facing normal, so flip its sign
        normal = -normal;
    end
    
    n_dot_dir_vec1 = dot(normal, dir_vecs(1, :))
    n_dot_dir_vec2 = dot(normal, dir_vecs(2, :))
    
    
    
end


% Copied from the file par_line.m
function data=readfile(file)
  f = fopen(file,'r');
  for i=1:4; fgets(f); end
  all = fscanf(f,'%f %f %f %f '); m = length(all)/4;
  data= reshape(all,4,m)';
  fclose(f);
end