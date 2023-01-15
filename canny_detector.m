function [resultImg, resultNMS] = canny_detector(image, TLow, THigh, sigma, kernelsize)
    %Filtr dolnoprzepusowy Gaussa (redukcja szumu)
    filterGauss = gaussian([kernelsize, kernelsize], sigma);
    %Operatory Sobela
    Gx = [-1 0 1; -2 0 2; -1 0 1];
    Gy = [1 2 1; 0 0 0; -1 -2 -1];

    [width, height] = size(image);
    imgSmoothed = zeros(width,height);
    imgMagnitude = zeros(width,height);
    gradDir = zeros(width,height);
    gradDirRound = zeros(width, height);
    NMS = zeros (width, height);
    imgThres = zeros (width, height);

    %1)Wygładzanie obrazu za pomocą filtru gaussowskiego
    imgSmoothed = convolution(image, filterGauss);
    %2)Wyznaczenie gradientu dla każdego pikselaobrazu wygładzonego
    %za pomocą operatorów Sobela 
    imgGx = convolution(imgSmoothed, Gx);
    imgGy = convolution(imgSmoothed, Gy);
    %Moduł gradientu
    imgMagnitude = sqrt(imgGx.^2 + imgGy.^2);
    %Usunięcie błędnych krawędzi związanych z obramowaniem powstałym po filtracji wygładzającej 
    imgMagnitude(:, [1:ceil(length(filterGauss)/2)+1, end-ceil(length(filterGauss)/2):end]) = 0;
    imgMagnitude([1:ceil(length(filterGauss)/2)+1, end-ceil(length(filterGauss)/2):end],:) = 0;         
    %Kierunek wektora gradientu (kąt nachylenia)
    gradDir = atan2 (imgGy, imgGx);
    %Zamiana radianów na stopnie
    gradDir = gradDir*180/pi;
    
    %Sprawdzenie czy któryś z kierunków przyjmuje wartość ujemną
    for i=1:width
        for j=1:height
            if  gradDir(i,j)<0
                gradDir(i,j)=360+gradDir(i,j);
            end
        end
    end               
    %Kąty gradientu są zaokrąglane do (0, 45, 90, 135)
    for i = 1 : width
        for j = 1 : height
            if ((gradDir(i, j) >= 0 ) && (gradDir(i, j) < 22.5) || (gradDir(i, j) >= 157.5) && (gradDir(i, j) < 202.5) || (gradDir(i, j) >= 337.5) && (gradDir(i, j) <= 360))
                gradDirRound(i, j) = 0;
            elseif ((gradDir(i, j) >= 22.5) && (gradDir(i, j) < 67.5) || (gradDir(i, j) >= 202.5) && (gradDir(i, j) < 247.5))
                gradDirRound(i, j) = 45;
            elseif ((gradDir(i, j) >= 67.5 && gradDir(i, j) < 112.5) || (gradDir(i, j) >= 247.5 && gradDir(i, j) < 292.5))
                gradDirRound(i, j) = 90;
            elseif ((gradDir(i, j) >= 112.5 && gradDir(i, j) < 157.5) || (gradDir(i, j) >= 292.5 && gradDir(i, j) < 337.5))
                gradDirRound(i, j) = 135;
            end
        end
    end
    
    %3)Tłumienie niemaksymalne (non-maximal suppression).
    %Jest to algorytm tłumienia zbędnych danych występująych przy detekcji
    %skośnych krawędzi
    %Dla każdego piksela rozpatrywane są 2 piksele sąsiednie; jeśli
    %piksel ten większy od sąsiadów to stanowi krawędź obrazu, 
    %w przeciwnym przypadku przyjmuje wartość zero
    for i=2:width-1
        for j=2:height-1
            if (gradDirRound(i,j)==0)
                NMS(i,j) = (imgMagnitude(i,j) == max([imgMagnitude(i,j), imgMagnitude(i,j+1), imgMagnitude(i,j-1)]));
            elseif (gradDirRound(i,j)==45)
                NMS(i,j) = (imgMagnitude(i,j) == max([imgMagnitude(i,j), imgMagnitude(i+1,j-1), imgMagnitude(i-1,j+1)]));
            elseif (gradDirRound(i,j)==90)
                NMS(i,j) = (imgMagnitude(i,j) == max([imgMagnitude(i,j), imgMagnitude(i+1,j), imgMagnitude(i-1,j)]));
            elseif (gradDirRound(i,j)==135)
                NMS(i,j) = (imgMagnitude(i,j) == max([imgMagnitude(i,j), imgMagnitude(i+1,j+1), imgMagnitude(i-1,j-1)]));
            end
        end
    end

    NMS = NMS.*imgMagnitude;
    
    %4) Progowanie z histerezą (minimalizacja występowania
    %fałszywych krawędzi)        
    %Wartości progu niskiego TL i wysokiego TH  (TL,TH = 0...1)
    TLow = TLow/255;
    THigh = THigh/255;
    TL = TLow * max(max(NMS));
    TH = THigh * max(max(NMS));

    for i = 1  : width
        for j = 1 : height
            %Jeśli intensywność krawędzi jest mniejsza od TL to usuwana
            %jest ona z obrazu wynikowego Tthres
            if (NMS(i, j) < TL)
                imgThres(i, j) = 0;
            %Jesli intensywność krawędzi jest większa niż TH uznaje się
            %ją za krawędź pozytywną
            elseif (NMS(i, j) > TH)
                imgThres(i, j) = 255;
            %Jeśli intensywność jest pomiędzy TL i TH to uznaje się ją
            %za pozytywną, gdy któraś z sąsiedniej krawędzi jest
            %pozytywna
            elseif ( NMS(i+1,j)>TH || NMS(i-1,j)>TH || NMS(i,j+1)>TH || NMS(i,j-1)>TH || NMS(i-1, j-1)>TH || NMS(i-1, j+1)>TH || NMS(i+1, j+1)>TH || NMS(i+1, j-1)>TH)
                imgThres(i,j) = 255;
            end
        end
    end
    
    %Ostateczne rezultaty 
    resultNMS = im2uint8(NMS); %Tlumienie niemaksymalne
    resultImg = imgThres; %Po progowaniu z histereza
end
