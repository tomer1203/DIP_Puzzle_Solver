function  take_peice_out(cam)

flag = 0;
count = 0;
count_fr = 0;
start_img = snapshot(cam);
start_img = double(rgb2gray(start_img))/255;
new_img = start_img;
noise = noise_val(cam);
pause(0.1)
while(1)
old_img = new_img;
pause(0.1)
new_img = snapshot(cam);
new_img = double(rgb2gray(new_img))/255;
different = sum(abs(abs(new_img - old_img)),'all');

if( different > noise*2 )
    %new_img = finger_in_img;
    while(1);
    old_img = new_img;
    pause(0.1)
    new_img = snapshot(cam);
    new_img = double(rgb2gray(new_img))/255;
    mooving_pixel = abs(new_img - old_img);
    mooving_pixel_sum = sum(mooving_pixel,'all');
    if(mooving_pixel_sum < noise )
        if(flag == 1) count = count +1; 
        else flag = 1; end;
    else flag = 0; count =0; end;
    
    if(count > 2) break; end;
    
    count_fr = count_fr +1;
    if(count_fr > 20)
        count_fr = 0;
        noise = noise_val(cam);
    end
    
    end
    break;
end
        
end
end
