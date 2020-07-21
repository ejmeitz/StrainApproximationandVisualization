function deformedCellArray = strainApproximation(posBoxArray, clampInfo)

    posBoxCellArray = createGrid(posBoxArray); %organize box elements by row
    deformedCellArray = {};
    
    
    sizeArray = size(posBoxCellArray);
    maxI = sizeArray(1);
    maxJ = sizeArray(2);
    
    maxRowLength = maxJ; %longest row is the num of cols
    longestRowIndex = getLongestRowIndexFromCellArray(posBoxCellArray);
    initialBoxWidth = posBoxCellArray{1,1,1}(3); 
    initialMinX = getMinX(posBoxCellArray(:,:,1));
    initialMaxX = maxRowLength*initialBoxWidth + initialMinX;
    fixedX = 0;
   

    x = inputdlg({'Left','Right','Both'},...
              'Where is the force applied?',[1 50; 1 50; 1 50], {'True'; 'False'; 'False'}); 
    %parse user input
    forceLocation = 1;
    for i = 1:3
          if(strcmp(x(i,1),'True') || strcmp(x(i,1),'true') || strcmp(x(i,1),'T') || strcmp(x(i,1),'t'))
              forceLocation = i;
              break;
          end
    end
    
    switch(forceLocation)
        case 1
            fixedX = initialMinX;
            %deformedCellArray = deformLeft(posBoxCellArray, maxRowLength);
        case 2
            fixedX = initialMaxX;
            %deformedCellArray = deformRight(posBoxCellArray, maxRowLength); %just mirror of deformLeft()
        case 3
            fixedX = findFixed(posBoxCellArray(:,:,1),initialMinX, initialMaxX);  
            %deformedCellArray = deformBoth(fixedX, initialMinX, maxRowLength);
        otherwise
    end
    
    
    return
end