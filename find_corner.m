

function [x_corner,y_corner]=find_corner(RGB)
%global value for function
N=9; %filter for lower noise
extent_filter=0.9;
dialtion_size1=2;
dialtion_size2=3;
minQuality=0.1;
filterSize=9;
fuctor=0.06;


%#################################
%% mask the image:
ImgGray = double(im2gray(RGB));
I = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
% imshow(I)

I=medfilt2(I,[N,N]);
% imshow(I);
BW = edge(I,'sobel',0.01,'both','thinning');
% imshow(BW)
dial = imdilate(BW,strel("rectangle",[dialtion_size1,dialtion_size1]));%**
extent = bwpropfilt(dial, 'Extent', [0, extent_filter]);

dial = imdilate(extent,strel("rectangle",[dialtion_size2,dialtion_size2]));%**
% imshow(dial)
mask = imfill(double(dial),8,"holes");
% imshow(mask)

%% find centers:
%center of mass:
props = regionprops(true(size(mask)), mask, 'WeightedCentroid');
%image center
x_center=floor(size(mask,2)/2);
y_center=floor(size(mask,1)/2);
%% find the iamge corner-
%the asamption is that the corners in the the corner of the image
width=floor(x_center/2);
height=floor(y_center/2);

x1=size(mask,2)-width;
y1=1;
roi_1=[x1,y1,width,height];

x2=1;
y2=1;
roi_2=[x2,y2,width,height];

x3=1;
y3=size(mask,1)-height;
roi_3=[x3,y3,width,height];

x4=size(mask,2)-width;
y4=size(mask,1)-height;
roi_4=[x4,y4,width,height];


Q1=detectHarrisFeatures(BW,'MinQuality',minQuality,"FilterSize",filterSize,"ROI",roi_1);
Q2=detectHarrisFeatures(BW,'MinQuality',minQuality,"FilterSize",filterSize,"ROI",roi_2);
Q3=detectHarrisFeatures(BW,'MinQuality',minQuality,"FilterSize",filterSize,"ROI",roi_3);
Q4=detectHarrisFeatures(BW,'MinQuality',minQuality,"FilterSize",filterSize,"ROI",roi_4);

minQuality1=minQuality;
minQuality2=minQuality;
minQuality3=minQuality;
minQuality4=minQuality;

while(size(Q1,1)>1)
minQuality1=minQuality1+fuctor ;

if(minQuality1>1)
    break
end
Q1=detectHarrisFeatures(BW,'MinQuality',minQuality1,"FilterSize",filterSize,"ROI",roi_1);    
end
if (size(Q1,1)==0)
    Q1=detectHarrisFeatures(BW,'MinQuality',0.01,"FilterSize",filterSize);   
    Q1.Location(1,1)=size(mask,2);
    Q1.Location(1,2)=1;
end
if (size(Q1,1)>1)
    y=[size(mask,2),1];
    dist=[];
    for i=1:Q1.Count
        x=[Q1.Location(i,1),Q1.Location(i,2)];
        dist(i)=norm(x-y);
    end
    Q1.Location(1)= Q1.Location(find(dist==min(dist)),1);
    Q1.Location(2)= Q1.Location(find(dist==min(dist)),2);
end


while(size(Q2,1)>1)
minQuality2=minQuality2+fuctor;  
if(minQuality2>1)
    break
end
  
Q2=detectHarrisFeatures(BW,'MinQuality',minQuality2,"FilterSize",filterSize,"ROI",roi_2);    
end
if (size(Q2,1)==0)
    Q2=detectHarrisFeatures(BW,'MinQuality',0.01,"FilterSize",filterSize);   
    Q2.Location(1,1)=1;
    Q2.Location(1,2)=1;
end
if (size(Q2,1)>1)
    y=[1,1];
    dist=[];
    for i=1:Q2.Count
        x=[Q2.Location(i,1),Q2.Location(i,2)];
        dist(i)=norm(x-y);
    end
    Q2.Location(1)= Q2.Location(find(dist==min(dist)),1);
    Q2.Location(2)= Q2.Location(find(dist==min(dist)),2);
end

while(size(Q3,1)>1 )
minQuality3=minQuality3+fuctor ;  
if(minQuality3>1)
    break
end

Q3=detectHarrisFeatures(BW,'MinQuality',minQuality3,"FilterSize",filterSize,"ROI",roi_3);    
end

if (size(Q3,1)==0)
    
    Q3=detectHarrisFeatures(BW,'MinQuality',0.01,"FilterSize",filterSize);   
    Q3.Location(1,1)=1;
    Q3.Location(1,2)=size(mask,1);
end
if (size(Q3,1)>1)
    y=[1,size(mask,1)];
    dist=[];
    for i=1:Q3.Count
        x=[Q3.Location(i,1),Q3.Location(i,2)];
        dist(i)=norm(x-y);
    end
    Q3.Location(1)= Q3.Location(find(dist==min(dist)),1);
    Q3.Location(2)= Q3.Location(find(dist==min(dist)),2);
end



while(size(Q4,1)>1)
minQuality4=minQuality4+fuctor   ;
if(minQuality4>1)
    break
end
 
Q4=detectHarrisFeatures(BW,'MinQuality',minQuality4,"FilterSize",filterSize,"ROI",roi_4);    
end
if (size(Q4,1)==0)
    Q4=detectHarrisFeatures(BW,'MinQuality',0.01,"FilterSize",filterSize);   
    Q4.Location(1,1)=size(mask,2);
    Q4.Location(1,2)=size(mask,1);
end
if (size(Q4,1)>1)
    y=[size(mask,2),size(mask,1)];
    dist=[];
    for i=1:Q4.Count
        x=[Q4.Location(i,1),Q4.Location(i,2)];
        dist(i)=norm(x-y);
    end
    Q4.Location(1)= Q4.Location(find(dist==min(dist)),1);
    Q4.Location(2)= Q4.Location(find(dist==min(dist)),2);
end

x_corner=[Q1.Location(1),Q2.Location(1),Q3.Location(1),Q4.Location(1)];
y_corner=[Q1.Location(2),Q2.Location(2),Q3.Location(2),Q4.Location(2)];
corner=[x_corner,y_corner];
end