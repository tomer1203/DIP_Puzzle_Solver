%% coreletion between image:
% input: piece-     piece from the hole image; unormelized and RGB
%        RGB  -     unormelized and RGB refrencece image
%        num_row
%        num_col
%
%output: location- the assumed location of the puzzel piece in the image
%        relaibility- 

%notice : seperete_channle normelized the image

function [location,reliability] = correlation(piece,RGB,num_row,num_col)
% match the size of the piece to the refrence image
[N,M,c]=size(RGB);
row_factor=floor(N/num_row);
col_factor=floor(N/num_col);

piece=imresize(piece,[row_factor,col_factor]);
%seperte to channes:
R_piece=seperete_channle(piece,1);
G_piece=seperete_channle(piece,2);
B_piece=seperete_channle(piece,3);
% 


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
        %compute the correletion
        relability_mat(j,k)=(corr2(R_temp,R_piece)+corr2(G_temp,G_piece)+corr2(B_temp,B_piece));
    end
end
%return:
reliability=max(max(relability_mat));
[location(1),location(2)]=find(relability_mat==reliability);
end