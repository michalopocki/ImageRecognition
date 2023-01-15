function showhistogramCanny(imageGray, tlow, thigh)         
    [histG, x] = histogram(imageGray);
    a = area(x, histG); a.FaceColor = '#767676'; 
    xlim([0, 255]);

    if tlow ~= -1
        xline(tlow,'-',['Próg TLow = ',num2str(tlow)]);
    end
    if thigh ~= -1
        xline(thigh,'-',['Próg THigh = ',num2str(thigh)]);
    end

    xlabel('Intensywność J_i');
    ylabel('Liczba pikseli h(J_i)');
    title('Histogram obrazu monochromatycznego')
end
