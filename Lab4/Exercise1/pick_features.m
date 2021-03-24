function [x1,y1,x2,y2] = pick_features(I1,I2)
figure;
hold on

n = 1;
x1 = [];
y1 = [];
x2 = [];
y2 = [];

but = 1;
while but == 1
      imshow(I1);
      [x_i1, y_i1, ~] = ginput(1);
      x1(n) = x_i1;
      y1(n) = y_i1;
      
      imshow(I2);
      [x_i2, y_i2, but] = ginput(1);
      x2(n) = x_i2;
      y2(n) = y_i2;
      n = n + 1;
end
hold off