function img_grid = grid_puzzle(RGB,num_of_pices)
% Detect straight lines
straight_lines = detect_edges(RGB,num_of_pices);

% Find corners and cutting the image
point1 = [straight_lines.point1];
point2 = [straight_lines.point2];
rows = zeros(length(point1),1);
columns = zeros(length(point1),1);

for i = 1:(length(point1)/2)
    rows(i) = point1(i*2-1);
    columns(i) = point1(i*2);
    rows(i+length(point1)/2) = point2(i*2-1);
    columns(i+length(point1)/2) = point2(i*2);
end

corners = zeros(4,1);
corners(1) = min(columns); % left
corners(2) = max(columns); % right
corners(3) = min(rows); % down
corners(4) = max(rows); % up

img_grid = RGB(corners(1):corners(2),corners(3):corners(4),:);
figure
imshow(img_grid);

% theta = [straight_lines.theta];
% theta_diff = mod(max(theta),90);
% img_grid = imrotate(img_grid,theta_diff);
% figure
% imshow(img_grid);