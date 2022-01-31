% as long as there are more then threshold white pixels in a square of size
% filt_size * filt_size the output pixel would be white
function filled_img = fill_white(img,filt_size,threshold)
    filter = ones([filt_size,filt_size]);
    filled_img = imfilter(double(img),filter,'replicate');
    filled_img = (filled_img >= threshold);
end