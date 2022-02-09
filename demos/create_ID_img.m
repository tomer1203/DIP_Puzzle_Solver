function QR_img = create_ID_img(img,x,y)
img = not(67/255<img .* img<200/255);
[m,n] = size(img);

min_x = min(x);
max_x = max(x);
min_y = min(y);
max_y = max(y);
img = img(min_y:max_y,min_x:max_x);


x=x/m/(max_x-min_x);
y=y/n/(max_y-min_y);



udata = [0 1];  vdata = [0 1];
tform = maketform('projective',[ 0 0;  1  0;  1  1; 0 1],...
                               [x(1) y(1); x(2) y(2); x(3) y(3); x(4) y(4)]);
                           
[B,xdata,ydata] = imtransform(img,tform,'bicubic', ...
                              'udata',udata,...
                              'vdata',vdata,...
                              'size',size(img),...
                              'fill',255);
                          
% figure()
% subplot(1,2,1); imshow(img,'XData',udata,'YData',vdata);
% subplot(1,2,2); imshow(B,'XData',xdata,'YData',ydata);

[m,n] = size(B);
M = max(m,n);
B = imresize(B, [M M]);
B = imrotate(B,90);
B = imrotate(B,90);

QR_img = B;
QR_img = not(150/255<QR_img .* QR_img<200/255);


end