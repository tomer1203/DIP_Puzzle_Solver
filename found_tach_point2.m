function tuch_point = found_tach_point(cam,noise)
tuch_point =0;
img = {};
summ = 0;
count = 0;
stuck = 0;
num_of_imgs = 1;
flag = 0;
start_img = snapshot(cam);
start_img = double(rgb2gray(start_img))/255;
noise = noise_val(cam);
pause(0.1)
while(1)
finger_in_img = snapshot(cam);
finger_in_img = double(rgb2gray(finger_in_img))/255;
different = sum(abs(abs(finger_in_img - start_img)),'all');
if( different > noise*2 )
    new_img = finger_in_img;
    while(1)
    num_of_imgs = num_of_imgs + 1;
    old_img = new_img;
    pause(0.1)
    new_img = snapshot(cam);
    new_img = double(rgb2gray(new_img))/255;
    mooving_pixel = abs(new_img - old_img);
    mooving_pixel_sum = sum(mooving_pixel,'all');
    if(mooving_pixel_sum < noise)
        if(flag == 1), count = count +1; 
        else, flag = 1; end
    else, flag = 0; count =0; 
    end
    
    if(count > 1), break; end

    stuck = stuck+1;
    if (stuck == 20)
        noise = noise_val(cam);
        stuck = 0;
    end
    

    mooving_pixel = (mooving_pixel>0.05);
    summ = summ + mooving_pixel;
    end
    break;
end
end

summ = (summ /num_of_imgs > 0);
% figure()
% imshow(summ);


filter_size = [25 25];
%fun = @(x) ((sum(x(:),'all')) / (filter_size(1)*filter_size(2))) > 0.8;
d_summ = double(summ);
summed_fil = imboxfilt(double(d_summ),25);
div_size = filter_size(1)*filter_size(2);
summ = summed_fil > 0.8;

% summ = nlfilter(summ,filter_size,fun);
% figure;
% imshow(summed_fil>0);
% figure;
% imshow(summ>0);
summ = medfilt2(summ,[5,5]);
summ = summ>0;


[m, n] = size(summ);
% tresh = 26; %25
tresh = 1; %25
side(1) = sum(summ(tresh,:)); %up
side(2) = sum(summ(m-tresh,:)); %douwn
side(3) = sum(summ(:,tresh)); %left
side(4) = sum(summ(:,n-tresh)); %right
if (side == 0)  return; end; 
maxx = max(side);

if(side(1) == maxx)
    s = sum(summ(m-tresh,:));
    while (s < 20 && tresh<(m-1))
       disp(m-tresh);
       s = sum(summ(m-tresh,:)); 
       tresh = tresh+1;      
    end
    p = find(summ((m-tresh),:));
    tuch_point = [(m-tresh) , p(1)];
end

if(side(2) == maxx)
      s = sum(summ(tresh,:));
    while (s < 20 && tresh<(m-1))
       disp(tresh);
       s = sum(summ(tresh,:)); 
       tresh = tresh+1;       
    end
    p = find(summ(tresh,:));
    tuch_point = [tresh , p(1)];
end

if(side(3) == maxx)
      s = sum(summ(:,n-tresh));
    while (s < 20 && tresh<(n-1))
       s = sum(summ(:,n-tresh)); 
       tresh = tresh+1;     
    end
    p = find(summ(:,n-tresh));
    tuch_point = [p(1) ,n-tresh];
end

if(side(4) == maxx)
      s = sum(summ(:,tresh));
    while (s < 20 && tresh<(n-1))
       s = sum(summ(:,tresh)); 
       tresh = tresh+1;       
    end
    p = find(summ(:,tresh));
    tuch_point = [p(1) ,tresh];
end




% figure()
% img = start_img;
% imshow(img);
% hold on;
% theta = 0 : 0.01 : 2*pi;
% radius = 50;
% x = radius * cos(theta) + tach_point(2);
% y = radius * sin(theta) + tach_point(1);
% plot(x, y, 'r-', 'LineWidth', 3);

end