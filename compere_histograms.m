%% compere histograms between image:
% input: piece-     piece from the hole image; unormelized and RGB
%        RGB  -     unormelized and RGB refrencece image
%        num_row
%        num_col
%
%output: location- the assumed location of the puzzel piece in the image
%        relaibility- 

%notice : seperete_channle normelized the image

function [location,reliability] = compere_histograms(piece,RGB,num_row,num_col)
% match the size of the piece to the refrence image
[N,M,~]=size(RGB);
row_factor=floor(N/num_row);
col_factor=floor(M/num_col);
piece1=imresize(piece,[row_factor,col_factor]);
%seperte to channes:
R_piece=seperete_channle(piece1,1);
G_piece=seperete_channle(piece1,2);
B_piece=seperete_channle(piece1,3);
%compute histograms
[C1_R,n1_R]=imhist(R_piece);
C1_R=C1_R/size(R_piece,1)/size(R_piece,2);
C1_R=C1_R/(1-C1_R(1));
C1_R(1)=0;

[C1_G,n1_G]=imhist(G_piece);
C1_G=C1_G/size(G_piece,1)/size(G_piece,2);
C1_G=C1_G/(1-C1_G(1));
C1_G(1)=0;

[C1_B,n1_B]=imhist(B_piece);
C1_B=C1_B/size(B_piece,1)/size(B_piece,2);
C1_B=C1_B/(1-C1_B(1));
C1_B(1)=0;

%#####################################
relability_mat = zeros(num_row,num_col);
for j = 1:num_row;
    x_start =(j-1)*row_factor+1;
    x_end   =j*row_factor;
    for k = 1:num_col;
        y_start =(k-1)*col_factor+1;
        y_end   =k*col_factor;
        temp_img=RGB(x_start:x_end,y_start:y_end,:);
        %seperte to channes:
        R_temp=seperete_channle(temp_img,1);
        G_temp=seperete_channle(temp_img,2);
        B_temp=seperete_channle(temp_img,3);
        %compute the histogram
        [C2_R,n2_R]=imhist(R_temp);
        C2_R=C2_R/size(R_temp,1)/size(R_temp,2);
        [C2_G,n2_G]=imhist(G_temp);
        C2_G=C2_G/size(G_temp,1)/size(G_temp,2);
        [C2_B,n2_B]=imhist(B_temp);
        C2_B=C2_B/size(B_temp,1)/size(B_temp,2);
        %compere the histograms of the 3 channles:
        relability_mat(j,k)=(pdist2(C1_R',C2_R',"correlation")+pdist2(C1_G',C2_G',"correlation")+pdist2(C1_B',C2_B',"correlation"));        
    end
end
%return:
%find the minimum destination
reliability=min(min(relability_mat));
[location(1),location(2)]=find(relability_mat==reliability);

%visualisation can be remove!
j=location(1);
k=location(2);
x_start =(j-1)*row_factor+1;
x_end   =j*row_factor;
y_start =(k-1)*col_factor+1;
y_end   =k*col_factor;
temp_img=RGB(x_start:x_end,y_start:y_end,:);
multi={temp_img,piece1,RGB};
figure;
montage(multi);
end

