%input : path to video.
%output : The point where the finger touched the puzzle.
function tach_point = found_tach_point(path)
%cam = webcam('cameraname')
v =  VideoReader(path)

finger_edge = [0,0];
%old = readFrame(v);

old2 = read(v,110);
new2 =  read(v,111);

mooving_pixel = new2 - old2 ;
mooving_pixel = double(rgb2gray(mooving_pixel))/255;
mooving_pixel = (mooving_pixel>0.05);
% figure()
% imshow(mooving_pixel)

summ =0;
for i = 1:120
old = read(v,i);
new =  read(v,i+1);
mooving_pixel = new - old ;
mooving_pixel = double(rgb2gray(mooving_pixel))/255;
mooving_pixel = (mooving_pixel>0.05);
summ = summ + mooving_pixel;
end
summ = (summ /120 > 0);
% figure()
% imshow(summ>0);


filter_size = [40 40];
fun = @(x) ((sum(x(:),'all')) / (filter_size(1)*filter_size(2))) > 0.9;
summ = nlfilter(summ,filter_size,fun); 
summ = medfilt2(summ,[5,5]);

% figure()
% summ = summ>0;
% imshow(summ);

[m, n] = size(summ);
tresh = 50;
side(1) = sum(summ(tresh,:)); %up
side(2) = sum(summ(m-tresh,:)); %douwn
side(3) = sum(summ(:,tresh)); %left
side(4) = sum(summ(:,n-tresh)); %right
maxx = max(side);

if(side(1) == maxx)
    s = sum(summ(m-tresh,:));
    while (s < 20)
       s = sum(summ(m-tresh,:)); 
       tresh = tresh+1;      
    end
    p = find(summ((m-tresh),:));
    tach_point = [(m-tresh) , p(1)];
end

if(side(2) == maxx)
      s = sum(summ(tresh,:));
    while (s < 20)
       s = sum(summ(tresh,:)); 
       tresh = tresh+1;       
    end
    p = find(summ(tresh,:));
    tach_point = [tresh , p(1)];
end

if(side(3) == maxx)
      s = sum(summ(:,n-tresh));
    while (s < 20)
       s = sum(summ(:,n-tresh)); 
       tresh = tresh+1;     
    end
    p = find(summ(:,n-tresh));
    tach_point = [p(1) ,n-tresh];
end

if(side(4) == maxx)
      s = sum(summ(:,tresh));
    while (s < 20)
       s = sum(summ(:,tresh)); 
       tresh = tresh+1;       
    end
    p = find(summ(:,tresh));
    tach_point = [p(1) ,tresh];
end



figure()
img = read(v,1);
imshow(img);
hold on;
theta = 0 : 0.01 : 2*pi;
radius = 50;
x = radius * cos(theta) + tach_point(2);
y = radius * sin(theta) + tach_point(1);
plot(x, y, 'r-', 'LineWidth', 3);



end
