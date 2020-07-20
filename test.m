
sizeArray = size(posBoxCellArray);
maxI = sizeArray(1);
maxJ = sizeArray(2);

    for i = 1:maxI
        for j = 1:maxJ
             if(~isempty(posBoxCellArray{i,j}))
                rectangle('Position', posBoxCellArray{i,j});          %draw rect
             end
        end

    end
    
    
