%Funkcja znajdująca dwie warstwy - 'classification layer'
% i 'learnable layer' na podstawie grafu warstwowego
function [learnableLayer,classLayer] = findLayersToReplace(lgraph)

    %Sprawdzenie czy argument wejściowy 'lgraph' jest grafem warstwowym
    if ~isa(lgraph,'nnet.cnn.LayerGraph')
        error('Argument wejsciowy musi byc obiektem typu grafu warstwowego')
    end

    src = string(lgraph.Connections.Source); %Źródło (source)
    dst = string(lgraph.Connections.Destination); %Cel (destination)
    layerNames = string({lgraph.Layers.Name}'); %Nazwy warstw

    %Szukanie 'classification layer'
    isClassificationLayer = arrayfun(@(l) ...
        (isa(l,'nnet.cnn.layer.ClassificationOutputLayer')|isa(l,'nnet.layer.ClassificationLayer')), ...
        lgraph.Layers);

    if sum(isClassificationLayer) ~= 1
        error('Layer graph must have a single classification layer.')
    end
    classLayer = lgraph.Layers(isClassificationLayer);

    % Przejrzyj wykres warstw w odwrotnej kolejności, zaczynając od klasyfikacji
    % warstwa. Jeśli sieć się rozgałęzia, zgłoś błąd.
    currentLayerIdx = find(isClassificationLayer);
    while true

        if numel(currentLayerIdx) ~= 1
            error('Layer graph must have a single learnable layer preceding the classification layer.')
        end

        currentLayerType = class(lgraph.Layers(currentLayerIdx));
        isLearnableLayer = ismember(currentLayerType, ...
            ['nnet.cnn.layer.FullyConnectedLayer','nnet.cnn.layer.Convolution2DLayer']);

        if isLearnableLayer
            learnableLayer =  lgraph.Layers(currentLayerIdx);
            return
        end

        currentDstIdx = find(layerNames(currentLayerIdx) == dst);
        currentLayerIdx = find(src(currentDstIdx) == layerNames);

    end

end

