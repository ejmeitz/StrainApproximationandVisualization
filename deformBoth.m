function deformedCellArray = deformBoth(posBoxCellArray, fixedX, maxRowLength, leftClampPos, rightClampPos)
    deformedCellArray = posBoxCellArray;
       %1 = x loc  %2 = y loc  % 3 = width   %4 = width
      
   initialMinX = getMinX(posBoxCellArray(:,:,1));
   initialBoxWidth = posBoxCellArray{1,1,1}(3);
   leftBinCount = (fixedX-initialMinX)/initialBoxWidth;
   rightBinCount = (maxRowLength-leftBinCount);
   
   
   smoothLeft = smoothdata(leftClampPos, 'movmean',5);
   filledLeft = filloutliers(smoothLeft,'makima');
   smoothRight = smoothdata(rightClampPos, 'movmean',5);
   filledRight = filloutliers(smoothRight,'makima');
       
       displacementPerFrameRight(1,1) = 0; %initialize first element 
       displacementPerFrameLeft(1,1) = 0; 
      for i = 2:length(rightClampPos)
          displacementPerFrameRight(i,1) = filledRight(i-1,1) -  filledRight(i,1);
      end
      for i = 2:length(leftClampPos)
          displacementPerFrameLeft(i,1) = filledLeft(i-1,1) -  filledLeft(i,1);
      end
      
      %DEFORM RIGHT SIDE
      
      %calculate and apply displacements to cells
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array (first frame has no deformation)
                    
         displacementRight = calcBinIncrement(rightBinCount, displacementPerFrameRight(j,1));
         countRight = 1;
         
        displacementLeft = calcBinIncrement(leftBinCount, displacementPerFrameLeft(j,1));
        displacementLeft = flipud(displacementLeft);  %we will still work left to right so flip displacements
        countLeft = 1;
         
         for k = 1 : size(posBoxCellArray,1) %loop through each row and apply the displacement
             for h = 1 : size(posBoxCellArray,2) 
                 
                if(~isempty(posBoxCellArray{k,h,j})) %if empty skip
                    if(posBoxCellArray{k,h,j}(1) >= fixedX) %if to right of fixed
                             deformedCellArray{k,h,j}(1) =  deformedCellArray{k,h,j}(1) + sum(displacementRight(1:countRight,1));  %update xloc
                             deformedCellArray{k,h,j}(3) =  deformedCellArray{k,h,j}(3) + displacementRight(countRight,1);    %update width
                             countRight = countRight + 1;
                    else %if to left of fixed
                            deformedCellArray{k,h,j}(1) =  deformedCellArray{k,h,j}(1) - sum(displacementLeft(countLeft:(size(displacementLeft,1)),1));  %update xloc
                            deformedCellArray{k,h,j}(3) =  deformedCellArray{k,h,j}(3) + displacementLeft(countLeft,1);    %update width
                            countLeft = countLeft + 1;
                            h
                    end
                 end 
                 
             end
             k
             countRight = 1; %at start of new row reset this
             countLeft = 1;
         end
         j
      end

      

end