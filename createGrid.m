%iterates through the array of positive boxes and places them into a cell
%array such that the number in each row of the cell array matches the real
%grid

function posBoxCellArray =  createGrid (posBoxArray)


    posBoxCellArray = {};

    for j = 1:size(posBoxArray,3)
         row = 1;
        elementsInRow = 1;
        for i = 1:length(posBoxArray)

            if(i > 1)
                if(posBoxArray(i , 2, j) < posBoxArray(i-1 , 2, j) || posBoxArray(i , 2, j) > posBoxArray(i-1 , 2, j))  %this will break if height changes across a row
                   row = row + 1;
                   elementsInRow = 1;
                end
            end

            posBoxCellArray{row, elementsInRow, j} = posBoxArray(i, 1:4, j);
            elementsInRow = elementsInRow + 1;      

        end
    end
    
    return;
end