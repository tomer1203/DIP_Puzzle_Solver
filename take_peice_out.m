function  take_peice_out(cam,appGui,Old_number_of_peices)

while(true)
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
        
         count_fr = count_fr +1;
        if(count_fr > 50)
            count_fr = 0;
            noise = noise_val(cam);
        end

        if( different > noise*1.5 )
            count_fr = 0;
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
            
            if(count > 1) break; end;
            
            count_fr = count_fr +1;
            if(count_fr > 20)
                count_fr = 0;
                noise = noise_val(cam);
            end
            
            end
            break;
        end
            
    end
        new_img2 = snapshot(cam);
        ImgGray = double(im2gray(new_img2));
        new_img2  = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
        [seg_img,~] = segmentation(new_img2 ,appGui.segParams.dial1,appGui.segParams.dial2,appGui.segParams.ext_filt ,appGui.segParams.center_size);
        largestBlob = bwareafilt(logical(seg_img), 1);
        largestArea = sum(largestBlob(:));
        area_filtered = bwpropfilt(logical(seg_img), 'area', [largestArea/2, largestArea]);
        [~,Number_of_lables]=bwlabel(area_filtered);
        if ((Number_of_lables<Old_number_of_peices)||(Old_number_of_peices==1))
            break;
        end
    end
end
