function [histogram, x] = histogram(image)
    x = [0:255];
    histogram = zeros(1,256);
    [width, height] = size(image);

    Ji = 0; %Bez pikseli J=0
    for i = 1:width
        for j = 1:height
             while (image(i,j) ~= Ji) && Ji<256
                    Ji=Ji+1;
             end
             if Ji<256
                histogram(Ji+1)=histogram(Ji+1)+1;
             end
             Ji = 0;
        end        
    end   
end

