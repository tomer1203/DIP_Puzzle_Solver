% as long as there are more then threshold black pixels in a square of size
% filt_size * filt_size the output pixel would be black
function filled_img = fill_black(img,filt_size,threshold)
    filled_img = 1 - fill_white(1-img,filt_size,threshold);
end