function vanish_point = compute_vanishing_point(dir_vec, f)
    vanish_point = zeros(2, 1);
    vanish_point(1) = f*dir_vec(1)/dir_vec(3);
    vanish_point(2) = f*dir_vec(2)/dir_vec(3);
end