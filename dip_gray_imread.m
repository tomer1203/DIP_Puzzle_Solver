function ImgNormal = dip_gray_imread(file_name)

% Almog Stern 314965328, Evgeny Andrachnik 317174084
myImg = imread(file_name);
ImgGray = double(im2gray(myImg));
ImgNormal = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));

end