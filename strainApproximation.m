function deformedPosBoxArray = strainApproximation(allPosBoxArray, scaled_s0)

    posBoxCellArray = createGrid(allPosBoxArray); %organize box into rows by y-coord (breaks if boxes are not at a constant y height along a row)
    deformedCellArray = {};
    
    initialBoxWidth = posBoxCellArray{1,1,1}(3); 
    initialMinX = getMinX(posBoxCellArray(:,:,1)); %minimum x from first frame (before deformation occurs)
    initialMaxX = getMaxX(posBoxCellArray(:,:,1)); %maximum x from first frame (before deformation occurs)
    maxWidthByBoxes = ((initialMaxX-initialMinX)/initialBoxWidth) + 1;  %width with dimension of boxes e.g. width = 10 boxes  %plus 1 because boxes are defined by their bottom left so otherwise we off by 1
    
    
    %have user create mask and pick circles to track
    [chosenCircles, threshUp, threshDown, numCirclesFound] = pickCircles(scaled_s0);  %this will assign a variable in base for chosenCircles
    %track those circles throughout the video
    [trackedCircleLocations, circleFrames] = trackCircles(scaled_s0, threshUp, threshDown, chosenCircles, numCirclesFound);
    assignin('base', 'circleFrames', circleFrames);
    
    %figure out where force is applied based on those circles movements
    [forceLocation, leftClampPos, rightClampPos] = deduceForceLocation(trackedCircleLocations);
    
    switch(forceLocation)
        case 'right'
            deformedCellArray = deformRight(posBoxCellArray, maxWidthByBoxes, rightClampPos);
        case 'left'
            deformedCellArray = deformLeft(posBoxCellArray, maxWidthByBoxes, leftClampPos); %just mirror of deformLeft()
        case 'both'
            fixedX = findFixed(posBoxCellArray(:,:,1),initialMinX, initialMaxX,size(scaled_s0,1),size(scaled_s0,2));  
            deformedCellArray = deformBoth(posBoxCellArray, fixedX, leftClampPos, rightClampPos);
        otherwise
            error("Could not deform cells");
    end
    
    allPosXLength = size(allPosBoxArray,1);
    %put back into array form so the rest of original script works
    deformedPosBoxArray = cellArrayBackToArray(deformedCellArray, allPosXLength);
    clear deformedCellArray trackedCircleLocations posBoxCellArray;
    return;
end