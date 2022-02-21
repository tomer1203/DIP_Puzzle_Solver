% img     = RGB
% mask    = segmented image of the puzzle
% N       = number of segmented pieces
% padding = add black padding surrounding the images.
function [returnValue,imgCell] = cut_images(img,mask,N,padding,appGui)
    % label the areas and take only the N largest ones.
    labled = bwlabel(bwareafilt(logical(mask),N));
%     imshow(bwareafilt(logical(img),N));
    imgCell = cell(N);
    for i=1:N
        temp = labled==i;
        [r,c]=find(labled==i);
        
        temp2 = img.*cast(temp,"like",img);
        % add padding to the edges of the images
        r_low = max(min(r)-padding,1);
        r_high = min(max(r)+padding,size(temp,1));
        c_low = max(min(c)-padding,1);
        c_high = min(max(c)+padding,size(temp,2));

        img_cut=temp2(r_low:r_high,c_low:c_high,:);
        mask_cut = temp(r_low:r_high,c_low:c_high);
        
        BWedge = edge(mask_cut,"prewitt");
        if (isempty(BWedge))
            disp("hello world")
            msg = ['Did not manage to find all the peices. make sure' ...
                'you put all the peices on the board Retrying in 5 seconds'];
            appGui.Label.Text = msg;
            pause(5);
%             uiconfirm(appGui.UIFigure,msg,'Check Peices','Icon','error');
            returnValue = -1;
            return;
        end
        [H,T,R] = hough(BWedge);
        peaks = houghpeaks(H,N*4);
        lines = houghlines(BWedge,T,R,peaks);
        angles = [lines.theta]';
        % find the two average angles
        if (isempty(angles) == 0)

            if (length(angles)== 1)% in case there is only one line
                two_angles = [angles(1),angles(1)];
            else
                [~,two_angles,~,~] = kmeans(angles,2);
            end
            % match to the closest angle
            a1 = mod(two_angles(1),90);
            if (a1>45)
                a1 = a1-90;
            end
            img_rot = imrotate(img_cut,a1,"crop");
        else
            disp("found no lines!")
            img_rot = img_cut;
        end
        imgCell{i} = img_rot;
        returnValue = 1;
%         subplot(5,3,i);
%         imshow(imgCell{i});
%         hold on
%         max_len = 0;
%         for k = 1:length(lines)
%            xy = [lines(k).point1; lines(k).point2];
%            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%         
%            % Plot beginnings and ends of lines
%            plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%            plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%         
%            % Determine the endpoints of the longest line segment
%            len = norm(lines(k).point1 - lines(k).point2);
%            if ( len > max_len)
%               max_len = len;
%               xy_long = xy;
%            end
%         end
        
    end
end