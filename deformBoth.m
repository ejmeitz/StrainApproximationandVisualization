function deformedCellArray = deformBoth(posBoxCellArray, fixedX, leftClampPos, rightClampPos)
    deformedCellArray = posBoxCellArray;  %probably have this work without making a copy
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
      
   initialMinX = getMinX(posBoxCellArray(:,:,1));
   initialMaxX = getMaxX(posBoxCellArray(:,:,1));
   initialBoxWidth = posBoxCellArray{1,1,1}(3);
   
   %have to use the extreme X vals to ensure all boxes are accounted for
   leftBinCount = (fixedX-initialMinX)/initialBoxWidth; %number of bins to left of fixed point
   rightBinCount = ((initialMaxX - fixedX)/initialBoxWidth) + 1;  %num of bins to right of fixed point 
   
 

       displacementPerFrameRight(1,1) = 0; %initialize first element (first frame always has zero displacement)
       displacementPerFrameLeft(1,1) = 0; 
      for i = 2:length(rightClampPos)
          displacementPerFrameRight(i,1) = rightClampPos(i,1) -  rightClampPos(i-1,1); %has length = numFrames
      end
      for i = 2:length(leftClampPos)
          displacementPerFrameLeft(i,1) = leftClampPos(i,1) -  leftClampPos(i-1,1); %has length = numFrames
      end
      
      
      %calculate and apply displacements to cells
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array (first frame has no deformation)
                    
        displacementRight = calcBinIncrement(rightBinCount, displacementPerFrameRight(j,1)); %has length = rightBinCount
         
        displacementLeft = calcBinIncrement(leftBinCount, displacementPerFrameLeft(j,1)); %has length = leftBinCount
        
       % displacementLeft = flipud(displacementLeft);  %we will still work left to right so flip displacements

         for r = 1 : size(posBoxCellArray,1) %loop through each row and apply the displacement
             temp = posBoxCellArray{r,1,1}(1);
             numBoxToLeftOfFixed = (fixedX - temp)/initialBoxWidth; %this could change with each row
             
             countLeft = 0;
             currentIndexRight = 1;
             for c = 1 : size(posBoxCellArray,2) %loop columns
                if(~isempty(posBoxCellArray{r,c,j})) %if empty skip
                     if(posBoxCellArray{r,c,j}(1) >= fixedX) %if to right of fixed
                             if(currentIndexRight == 1) %if the first box in a row not necessarilly furthest left
                                startXRow = posBoxCellArray{r,c,1}(1); %do relative to first frame because the others will give decimal values
                                startIndex = ((startXRow-fixedX)/initialBoxWidth) + 1; %plus 1 cause MATLAB starts at 1 
                                currentIndexRight = startIndex;
                              end 
                    
                              deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) + sum(displacementRight(1:currentIndexRight,1));  %update xloc
                              deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacementRight(currentIndexRight,1);    %update width
                              currentIndexRight = currentIndexRight + 1;
                     else %if to left of fixed
                             deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) - sum(displacementLeft(1:numBoxToLeftOfFixed-countLeft,1));  %update xloc
                             deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacementLeft(numBoxToLeftOfFixed-countLeft, 1);    %update width
                             countLeft = countLeft + 1; %since we can't loop backwards like in deformLeft() we have to count and subtract from the number of boxes in that row
                     end
                 end 
                 
             end
         end
      end

      

end