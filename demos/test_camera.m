function test_camera()
    cam = webcam(2);

    preview(cam);
    for i=1:100
        im = snapshot(cam);
        disp("test");
        ImgGray = double(rgb2gray(im));
        ImgNormal = (ImgGray - min(ImgGray(:)))/(max(ImgGray(:)) - min(ImgGray(:)));
        [seg,b] = segmentation(ImgNormal,2,3,0.6,8);
        imshow(seg);
        
%         pause(0.1);
    end
end