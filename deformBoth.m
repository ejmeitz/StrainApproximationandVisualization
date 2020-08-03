function deformedCellArray = deformBoth(posBoxCellArray, fixedX, maxRowLength, leftClampPos, rightClampPos)
    deformedCellArray = posBoxCellArray;  %probably have this work without making a copy
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
      
   initialMinX = getMinX(posBoxCellArray(:,:,1));
   initialBoxWidth = posBoxCellArray{1,1,1}(3);
   leftBinCount = (fixedX-initialMinX)/initialBoxWidth;
   rightBinCount = (maxRowLength-leftBinCount);
   
%    filledLeft = filloutliers(leftClampPos,'makima','gesd');
%    smoothLeft = smoothdata(filledLeft, 'movmean',2);
%    
%    filledRight = filloutliers(rightClampPos,'makima','gesd');
%    smoothRight = smoothdata(filledRight, 'movmean',2);
 
       
       displacementPerFrameRight(1,1) = 0; %initialize first element 
       displacementPerFrameLeft(1,1) = 0; 
      for i = 2:length(rightClampPos)
          displacementPerFrameRight(i,1) = rightClampPos(i,1) -  rightClampPos(i-1,1);
      end
      for i = 2:length(leftClampPos)
          displacementPerFrameLeft(i,1) = leftClampPos(i,1) -  leftClampPos(i-1,1);
      end
      
      %DEFORM RIGHT SIDE
      
      %calculate and apply displacements to cells
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array (first frame has no deformation)
                    
        displacementRight = calcBinIncrement(rightBinCount, displacementPerFrameRight(j,1));
         
        displacementLeft = calcBinIncrement(leftBinCount, displacementPerFrameLeft(j,1));
        displacementLeft = flipud(displacementLeft);  %we will still work left to right so flip displacements

         for r = 1 : size(posBoxCellArray,1) %loop through each row and apply the displacement
             temp = posBoxCellArray{r,1,1}(1);
             numBoxOnLeft = (fixedX - temp)/initialBoxWidth;
             
             countLeft = 0;
             currentIndexRight = 1;
             currentIndexLeft = 1;
             for c = 1 : size(posBoxCellArray,2) 
                if(~isempty(posBoxCellArray{r,c,j})) %if empty skip
                    
                    
                     if(posBoxCellArray{r,c,j}(1) >= fixedX) %if to right of fixed
                             if(currentIndexRight == 1) %if the first box in a row not necessarilly furthest left
                                startXRow = posBoxCellArray{r,c,j}(1);
                                startIndex = ((startXRow-fixedX)/initialBoxWidth) + 1; %plus 1 cause MATLAB starts at 1 
                                currentIndexRight = startIndex;
                              end 
                    
                              deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) + sum(displacementRight(1:currentIndexRight,1));  %update xloc
                              deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacementRight(currentIndexRight,1);    %update width
                              currentIndexRight = currentIndexRight + 1;
                     else %if to left of fixed
                         if(currentIndexLeft == 1) %if the first box in a row not necessarilly furthest left
                                startXRow = posBoxCellArray{r,c,j}(1);
                                startIndex = ((startXRow-initialMinX)/initialBoxWidth) + 1; %plus 1 cause MATLAB starts at 1 
                                currentIndexLeft = startIndex;
                         end 

                             deformedCellArray{r,c,j}(1) =  deformedCellArray{r,c,j}(1) - sum(displacementLeft(1:numBoxOnLeft-countLeft,1));  %update xloc
                             deformedCellArray{r,c,j}(3) =  deformedCellArray{r,c,j}(3) + displacementLeft(numBoxOnLeft-countLeft, 1);    %update width
                             currentIndexLeft = currentIndexLeft + 1;
                             countLeft = countLeft + 1;
                     end
                 end 
                 
             end
         end
      end

      

end