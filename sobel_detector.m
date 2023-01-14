function [resultImg] = sobel_detector(image)

    %Sobel operator
    Gx = [-1 0 1; -2 0 2; -1 0 1]/4;
    Gy = [-1 -2 -1; 0 0 0; 1 2 1]/4;
    
    %Gradient x and y
    imgGx = convolution(image, Gx);
    imgGy = convolution(image, Gy);
    
    %Magnitude
    resultImg = sqrt(imgGx.^2 + imgGy.^2);

    resultImg = im2uint8(resultImg);
end

