%Funkcja ustawiające wspołczynniki prędkości uczenia (lerning rates)
%wszystkich warstw na zero.

function layers = freezeWeights(layers)
    
    numLayers = size(layers,1); %Liczba warstw
    for ii = 1:numLayers
        %Pobiera nazwy publicznych właściowości danej warstwy
        props = properties(layers(ii));
        for p = 1:numel(props) %Liczba właściowsi danej warstwy
            propName = props{p};
            if ~isempty(regexp(propName, 'LearnRateFactor$', 'once'))
                layers(ii).(propName) = 0;
            end
        end
    end

end