


function [puzzel_shape loc_mat]=detect_pazzel_shape(pieces,image_factor_resize)
loc_mat=zeros(4,1);                 %up,down,left,right 
f=floor(50/8)*image_factor_resize;  % the window size
show=false;


pieces = double(im2gray(pieces));
pieces = (pieces - min(pieces(:)))/(max(pieces(:)) - min(pieces(:)));
pieces(pieces>0)=1;
[N,M]=size(pieces);
props = regionprops(true(size(pieces)), pieces, 'WeightedCentroid');
x_center=props.WeightedCentroid(1);
y_center=props.WeightedCentroid(2);


%first row:

mat_up=pieces(1:f,:);
c=1;
while isempty( find(mat_up>0) )&(f*c<y_center)
mat_up=pieces((c-1)*f+1:f*c,:);
c=c+1;
end
c=c+1;
mat_up=pieces((c-1)*f+1:f*c,:);
%first col:
mat_left=pieces(:,1:f);
c=1;
while isempty( find(mat_left>0) )&(f*c<x_center)
mat_left=pieces(:,(c-1)*f+1:f*c);
c=c+1;
end
c=c+1;
mat_left=pieces(:,(c-1)*f+1:f*c);
%last_col:
mat_right=pieces(:,size(pieces,2):-1:size(pieces,2)-f);
c=1;
while (isempty( find(mat_right>0))& (size(pieces,2)-f*(1+c)>x_center))
mat_right=pieces(:,size(pieces,2)-f*c:-1:size(pieces,2)-f*(1+c));
c=c+1;
end
c=c+1;
mat_right=pieces(:,size(pieces,2)-f*c:-1:size(pieces,2)-f*(1+c));
%last_row:
mat_down=pieces(size(pieces,1):-1:size(pieces,1)-f,:);
c=1;
while isempty( find(mat_down>0) )&(size(pieces,1)-f*(1+c)>y_center)
mat_down=pieces(size(pieces,1)-f*c:-1:size(pieces,1)-f*(1+c),:);
c=c+1;
end
c=c+1;
mat_down=pieces(size(pieces,1)-f*c:-1:size(pieces,1)-f*(1+c),:);

if(show)
    figure;
    imshow(pieces)
end

if(false)
    figure;
    imshow(pieces)
    title("the piece")
    figure;
    imshow(mat_up)
    title("up")
    figure;
    imshow(mat_left)
    title("left")
    figure;
    imshow(mat_right)
    title("right")
    

    
    figure;
    imshow(mat_down)
    title("down")
end

    mat_down=mat_down';
    mat_up=mat_up';
    up=mat_up(:,floor(f/2));
    down=mat_down(:,floor(f/2));
    left=mat_left(:,floor(f/2));
    right=mat_right(:,floor(f/2));

if (show)
    figure
    subplot (4,1,1)
    plot(up)
    title("up")
    subplot (4,1,2)
    plot(down)
    title("down")
    subplot (4,1,3)
    plot(left)
    title("left")  
    subplot (4,1,4)
    plot(right)
    title("right")
end
loc_mat=[side_type(up,M);side_type(down,M);side_type(left,N);side_type(right,N)];

puzzel_edges=find(loc_mat==0);
if length(puzzel_edges)>2|(loc_mat(1)==0&loc_mat(2)==0)|(loc_mat(3)==0&loc_mat(4)==0)
    %edege are in opessite side or more than 2 edge
    puzzel_shape="error";
else
    if(length(puzzel_edges)==2)
        puzzel_shape="corner";
    else
        if (length(puzzel_edges)==1)
            puzzel_shape="edge";
        else
            puzzel_shape="inside";
        end
    end
end
% 


end

function type=side_type(side,N)
prime=gradient(side);
pos_loc=find(prime>0);
neg_loc=find(prime<0);
if (length(pos_loc)<=2)    % less than threshold than or + or = . for ! eindows
    if( neg_loc(length(neg_loc))-pos_loc(1)<floor(N/2)) %the window size less than threshold than +
        type=1;
    else
        type=0;
    end
else
    left_value_pos=length(find(pos_loc<floor(N/2)));
    right_value_pos=length(find(pos_loc>floor(N/2)));
    left_value_neg=length(find(neg_loc<floor(N/2)));
    right_value_neg=length(find(neg_loc>floor(N/2)));
    bool_neg=(left_value_pos>=1)&(left_value_pos<=2)&(right_value_pos>=1)&(right_value_pos<=2);
    bool_pos=(left_value_neg>=1)&(left_value_neg<=2)&(right_value_neg>=1)&(right_value_neg<=2);
    if bool_pos|bool_neg
        %if thr number of raise in the left is in range and the value of
        %right in range than is '-'
        type=-1;
    else
        %else there is alot of noise so "=";
        type=0;
    end

end
end

