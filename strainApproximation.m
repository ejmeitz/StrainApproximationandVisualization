function deformedCellArray = strainApproximation(posBoxArray, scaled_s0)

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
   
    %have user create mask and pick circles to track
    [chosenCircles, threshUp, threshDown] = pickCircles(scaled_s0);
    %track those circles throughout the video
    trackedCircleLocations = trackCircles(scaled_s0, threshUp, threshDown, chosenCircles);
    %figure out where force is applied based on those circles movements
    [forceLocation, leftClampPos, rightClampPos] = deduceForceLocation(trackedCircleLocations);
    
    switch(forceLocation)
        case 'right'
            fixedX = initialMinX;
            deformedCellArray = deformRight(posBoxCellArray, longestRowIndex, maxRowLength, rightClampPos);
        case 'left'
            fixedX = initialMaxX;
            deformedCellArray = deformLeft(posBoxCellArray, longestRowIndex, maxRowLength, leftClampPos); %just mirror of deformLeft()
        case 'both'
            fixedX = findFixed(posBoxCellArray(:,:,1),initialMinX, initialMaxX);  
            deformedCellArray = deformBoth(posBoxCellArray, fixedX, maxRowLength, leftClampPos, rightClampPos);
        otherwise
            error("Could not deform cells");
    end
    
    
    return
end