function showhistogram(imageGray, t)         
    [histG, x] = histogram(imageGray);
    a = area(x, histG); a.FaceColor = '#767676'; 
    xlim([0, 255]);

    if t ~= -1
        xline(t,'-',['Próg T = ',num2str(t)]);
    end

    xlabel('Intensywność J_i');
    ylabel('Liczba pikseli h(J_i)');
    title('Histogram obrazu monochromatycznego')
end

