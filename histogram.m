function [histogram, x] = histogram(image)
    x = [0:255];
    histogram = zeros(1,256);
    [width, height] = size(image);

    for i = 1:width
        for j = 1:height
            index = image(i,j);
            histogram(index + 1) = histogram(index + 1) + 1;
        end        
    end   
end

