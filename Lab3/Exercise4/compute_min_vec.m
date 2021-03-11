function v_min = compute_min_vec(data)
    n = 3; 
    m = size(data,1);
    if m<n; fprintf('M < 3 / error\n'); return; end
  
    a = zeros(m,n);
    a(:,1) = data(:,4) - data(:,2); % a(n, 1) = h_n = d - b
    a(:,2) = -(data(:,3) - data(:,1)); % a(n, 2) = -g_n = -(c - a)
    a(:,3) = data(:,2) .* -a(:,2)  - data(:,1) .* a(:,1); % a(n, 3) = b*g_n - a*h_n = -b*a(n, 2) - a*a(n, 1)

    [U,S,V] = svd(a);  % call matlab SVD routine
    v_min = V(:,n); % s and v are already sorted from largest to smallest
    if all(v_min < 0); v_min = -v_min; end 
end