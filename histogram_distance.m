% input: 1 channel piece image
%        1 channel grid image
%        bin: number of bins for the histogram
%output  d=norm2(hist_piece, hist_grid)
function  d=histogram_distance(piece,grid,bins,show)
% create the histograms:

[C,~]=imhist(piece);
[grid_hist,n]=imhist(grid);
%normelized the grid image:
grid_hist=grid_hist/size(piece,1)/size(piece,2);
grid_hist=grid_hist/(1-grid_hist(1));
grid_hist(1)=0;
%normelized and remove the black from the image:
C=C/size(piece,1)/size(piece,2);
C=C/(1-C(1));
C(1)=0;

L=floor(256/bins);
piece_hist=zeros(bins,1);
grid_hist_f=zeros(bins,1);
for i=1:bins
    piece_hist(i)=sum(C((i-1)*L+1:i*L));
    grid_hist_f(i)=sum(grid_hist((i-1)*L+1:i*L));
end

%find the distance
d=norm(piece_hist-grid_hist_f);
%visualisation:
if (show)
figure;
subplot(2,1,1);
plot (piece_hist)
title("piece histogram")

subplot(2,1,2);
plot (grid_hist_f)
title("grid histogarm")
end
end