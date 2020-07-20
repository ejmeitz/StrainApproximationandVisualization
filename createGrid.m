%iterates through the array of positive boxes and places them into a cell
%array such that the number in each row of the cell array matches the real
%grid

function posBoxCellArray =  createGrid (posBoxArray)


    posBoxCellArray = {};
    row = 1;
    elementsInRow = 1;
    posBoxCellArray{1,1} = posBoxArray(1,1:4); %first one will always be first in cell array also


    for i = 1:length(posBoxArray)
        
        if(i > 1)
            if(posBoxArray(i , 2) < posBoxArray(i-1 , 2) || posBoxArray(i , 2) > posBoxArray(i-1 , 2))  %this will break if height changes across a row
               row = row + 1;
               elementsInRow = 1;
            end
        end
        
         posBoxCellArray{row, elementsInRow} = posBoxArray(i,1:4);
        elementsInRow = elementsInRow + 1;      

    end

    return;
end