function out_metrix = next_pieces(seg_img,in_metrix,last_out_peice_Centroid)
out_metrix = in_metrix;
img = seg_img;
seg_img = seg_img >0;
figure()
imshow(seg_img)
% seg_img = medfilt2(seg_img ,filter_size);
% seg_img = seg_img >0;
s = regionprops(seg_img,'centroid');
centroids_s = cat(1,s.Centroid);

[m,n] = size(in_metrix);
[labled, labelCount] = bwlabel(bwareafilt(logical(seg_img),[500,999999]));
label = labled(floor(last_out_peice_Centroid(2)),floor(last_out_peice_Centroid(1)));
Location_in_metrix = find(in_metrix == label);
out_metrix(Location_in_metrix) = -5;
memo = out_metrix;
B = [0,1,0;1,0,1;0,1,0];
A = memo < 0;
A = A.*(-5);
Cfull = conv2(A,B);
Cfull = Cfull(2:m+1,2:n+1);
next = find(Cfull < -4);
labels = out_metrix(next);

label2center = zeros(labelCount,2);
for i=1:labelCount
    s_temp = regionprops(labled==i,'centroid');
    centroids_s_temp = cat(1,s_temp.Centroid);
    label2center(i,1) = centroids_s_temp(1);
    label2center(i,2) = centroids_s_temp(2);
end
%label2center(labels)
l1 =  label2center(:,1);
l2 =  label2center(:,2);
x = l1(labels);
y = l2(labels);
x = floor(x);
y = floor(y);


figure()
imshow(img);
hold on;
theta = 0 : 0.01 : 2*pi;
radius = 50;
x = radius * cos(theta) + x;
y = radius * sin(theta) + y;
plot(x', y', 'r-', 'LineWidth', 3);






% figure()
% imshow(img);
% hold on;
% theta = 0 : 0.01 : 2*pi;
% radius = 50;
% x = radius * cos(theta) + centroids_s(:,1);
% y = radius * sin(theta) + centroids_s(:,2);
% plot(x', y', 'r-', 'LineWidth', 3);


end