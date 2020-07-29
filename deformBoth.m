function deformedCellArray = deformBoth(posBoxCellArray, fixedX, maxRowLength, leftClampPos, rightClampPos)
    deformedCellArray = posBoxCellArray;  %probably have this work without making a copy
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
      
   initialMinX = getMinX(posBoxCellArray(:,:,1));
   initialBoxWidth = posBoxCellArray{1,1,1}(3);
   leftBinCount = (fixedX-initialMinX)/initialBoxWidth;
   rightBinCount = (maxRowLength-leftBinCount);
   
   filledLeft = filloutliers(leftClampPos,'makima','gesd');
   smoothLeft = smoothdata(filledLeft, 'movmean',2);
   
   filledRight = filloutliers(rightClampPos,'makima','gesd');
   smoothRight = smoothdata(filledRight, 'movmean',2);
 
       
       displacementPerFrameRight(1,1) = 0; %initialize first element 
       displacementPerFrameLeft(1,1) = 0; 
      for i = 2:length(rightClampPos)
          displacementPerFrameRight(i,1) = smoothRight(i,1) -  smoothRight(i-1,1);
      end
      for i = 2:length(leftClampPos)
          displacementPerFrameLeft(i,1) = smoothLeft(i,1) -  smoothLeft(i-1,1);
      end
      
      %DEFORM RIGHT SIDE
      
      %calculate and apply displacements to cells
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array (first frame has no deformation)
                    
        displacementRight = calcBinIncrement(rightBinCount, displacementPerFrameRight(j,1));
         
        displacementLeft = calcBinIncrement(leftBinCount, displacementPerFrameLeft(j,1));
        displacementLeft = flipud(displacementLeft);  %we will still work left to right so flip displacements

         for r = 1 : size(posBoxCellArray,1) %loop through each row and apply the displacement
             temp = posBoxCellArray{r,1,j}(1);
             numBoxOnLeft = (fixedX - temp)/initialBoxWidth;
             
             countRight = 0; %at start of new row reset counts
             countLeft = 1;
             startIndex = 1; %assume every row starts at center for now
             for c = 1 : size(posBoxCellArray,2) 
                
                 
                 %breaks when theres gaps because the "first" box in the
                 %row always gets 0 for the right handed deformation
                if(~isempty(posBoxCellArray{r,c,j})) %if empty skip
                    
                    
                     if(posBoxCellArray{r,c,j}(1) >= fixedX) %if to right of fixed
                            if(countRight == 0) %if the first box we look at on the right side
                                startXRight = posBoxCellArray{r,c,j}(1);
                                startIndex = ((startXRight - fixedX)/initialBoxWidth)+1;
                            end %without checking this rows that don't start at the center will be displaced incorrectly
                    
                              deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) + sum(displacementRight(startIndex:startIndex + countRight,1));  %update xloc
                              deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacementRight(startIndex + countRight,1);    %update width
                              countRight = countRight + 1;
                     else %if to left of fixed
                             deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) - sum(displacementLeft(countLeft:numBoxOnLeft,1));  %update xloc
                             deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacementLeft(countLeft, 1);    %update width
                             countLeft = countLeft + 1;
                     end
                 end 
                 
             end
         end
      end

      

end