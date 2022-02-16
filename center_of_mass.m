function centroids = center_of_mass(seg_img,filter_size,tuch_point,app)
seg_img = seg_img >0;
% seg_img = medfilt2(seg_img ,filter_size);
% seg_img = seg_img >0;
s = regionprops(seg_img,'centroid');
centroids_s = cat(1,s.Centroid);

vec = abs((centroids_s - [tuch_point(2),tuch_point(1)]));
summ_vec = sum(vec,2); 
minn = min(summ_vec);
k = find(summ_vec == minn);
centroids(1) = centroids_s(k,1);
centroids(2) = centroids_s(k,2);

%--- all points
figure()
imshow(seg_img)
hold on
plot(centroids(:,1),centroids(:,2),'b*')
hold off

% --- cousen point
% figure()
% imshow(seg_img,'Parent',app.appSettings.UIAxesPiece)
% hold(app.appSettings.UIAxesPiece,"on")
% plot(centroids(1),centroids(2),'b*','Parent',app.appSettings.UIAxesPiece)
% theta = 0 : 0.01 : 2*pi;
% radius = 50;
% x = radius * cos(theta) + centroids(1);
% y = radius * sin(theta) + centroids(2);
% plot(x, y, 'r-', 'LineWidth', 3,'Parent',app.appSettings.UIAxesPiece);
% % title("Take out the choosen piece");
% textLabel = sprintf("Take out the choosen piece");
% app.Label.Text = textLabel;
% hold(app.appSettings.UIAxesPiece,"off")
end