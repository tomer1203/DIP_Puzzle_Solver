function centroids = center_of_mass(seg_img,filter_size,tach_point)
seg_img = seg_img >0;
seg_img = medfilt2(seg_img ,filter_size);
seg_img = seg_img >0;

s = regionprops(seg_img,'centroid');
centroids_s = cat(1,s.Centroid);

vec = abs(centroids_s - [tach_point(2),tach_point(1)]);
summ_vec = sum(vec,2); 
minn = min(summ_vec);
k = find(summ_vec == minn);
centroids(1) = centroids_s(k,1);
centroids(2) = centroids_s(k,2);

% --- all points
% figure()
% imshow(seg_img)
% hold on
% plot(centroids_s(:,1),centroids_s(:,2),'b*')
% hold off

% --- cousen point
figure()
imshow(seg_img)
hold on
plot(centroids(1),centroids(2),'b*')
theta = 0 : 0.01 : 2*pi;
radius = 50;
x = radius * cos(theta) + centroids(1);
y = radius * sin(theta) + centroids(2);
plot(x, y, 'r-', 'LineWidth', 3);
title("Take out the choosen piece");
end