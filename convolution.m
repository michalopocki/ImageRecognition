function [resultImg] = convolution(image, filter)

    [width, height] = size(image); 
  
    [fW, fH] = size(filter);
    if mod(fW,2)==0
       filter(fW+1, fH+1) = 0;
    end

    resultImg=zeros(width, height);
    limit = (size(filter,1)-1)/2;
    image = im2double(image);

    for x=1+limit:width-limit
         for y=1+limit:height-limit
             for m= -limit:limit
                 for n= -limit:limit
                    resultImg(x,y) = resultImg(x,y)+image(x-m,y-n)*filter(m+limit+1,n+limit+1);
                 end
             end
         end
    end
    
end

