function [gauss, x, y] = gaussian(kernelsize, sigma)
    %Rozmiar maski
    N =(kernelsize(1)-1)/2; 
    M = (kernelsize(2)-1)/2;
    %Utworzenie siatki
    [x, y] = meshgrid(-N:M, -N:M);    
    %Dwuwymiarowa funkcja Gaussa
    a = 1/(2*pi*sigma^2);
    b = exp( - (x .^ 2 + y .^ 2) / (2 * sigma ^ 2) );    
    gauss = a .* b;
    gauss = gauss/sum(sum(gauss));
end

