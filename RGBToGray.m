function imageGray = RGBToGray(image)
    [width, height, d] = size(image);
    if d~=3
        return;
    end
    imageGray=ones(width,height);
    image = double(image);
    for i = 1:width
        for j = 1:height
            imageGray(i,j) = 0.2989 * image(i,j,1) + 0.5870 * image(i,j,2) + 0.1140 * image(i,j,3);
        end        
    end
    imageGray=uint8(imageGray);
end

