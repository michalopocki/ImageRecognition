function resultImg = thresholding(image, t)
    [width, height] = size(image);
    resultImg = zeros(width, height);

    for i = 1:width
        for j = 1:height
            if image(i,j)<=t
                resultImg(i,j) = 0;
            else
               resultImg(i,j) = 255; 
            end
        end
    end
end
