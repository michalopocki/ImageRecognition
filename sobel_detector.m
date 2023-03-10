function [resultImg, beforeThresh] = sobel_detector(image, threshold)
    %image - 2d image
    %threshold - values from 0 to 255
    %resultImg - image with thresholing if applied
    %beforeThresh - image before thresholding

    %Sobel operator
    Gx = [-1 0 1; -2 0 2; -1 0 1]/4;
    Gy = [-1 -2 -1; 0 0 0; 1 2 1]/4;
    
    %Gradient x and y
    imgGx = convolution(image, Gx);
    imgGy = convolution(image, Gy);
    
    %Magnitude
    resultImg = sqrt(imgGx.^2 + imgGy.^2);

    resultImg = im2uint8(resultImg);  
    beforeThresh = resultImg;
    
    if(threshold >= 0)
        resultImg = thresholding(resultImg, threshold);
    end
end

