function deformedCellArray = deformBoth(posBoxCellArray, fixedX, maxRowLength, leftClampPos, rightClampPos)
    deformedCellArray = posBoxCellArray;
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
          displacementPerFrameRight(i,1) = smoothRight(i-1,1) -  smoothRight(i,1);
      end
      for i = 2:length(leftClampPos)
          displacementPerFrameLeft(i,1) = smoothLeft(i-1,1) -  smoothLeft(i,1);
      end
      
      %DEFORM RIGHT SIDE
      
      %calculate and apply displacements to cells
      for j = 2:size(posBoxCellArray,3) %for each frame calculate new displacemenet array (first frame has no deformation)
                    
        displacementRight = calcBinIncrement(rightBinCount, displacementPerFrameRight(j,1));
         
        displacementLeft = calcBinIncrement(leftBinCount, displacementPerFrameLeft(j,1));
        displacementLeft = flipud(displacementLeft);  %we will still work left to right so flip displacements

         for k = 1 : size(posBoxCellArray,1) %loop through each row and apply the displacement
             temp = posBoxCellArray{k,1,j}(1);
             numBoxOnLeft = (fixedX - temp)/initialBoxWidth;
             
             countRight = 1; %at start of new row reset counts
             countLeft = 1;
             for h = 1 : size(posBoxCellArray,2) 
                 
          
                 
                if(~isempty(posBoxCellArray{k,h,j})) %if empty skip
                    if(posBoxCellArray{k,h,j}(1) >= fixedX) %if to right of fixed
                             deformedCellArray{k,h,j}(1) =  deformedCellArray{k,h,j}(1) + sum(displacementRight(1:countRight,1));  %update xloc
                             deformedCellArray{k,h,j}(3) =  deformedCellArray{k,h,j}(3) + displacementRight(countRight,1);    %update width
                             countRight = countRight + 1;
                    else %if to left of fixed
                            deformedCellArray{k,h,j}(1) =  deformedCellArray{k,h,j}(1) - sum(displacementLeft(countLeft:numBoxOnLeft,1));  %update xloc
                            deformedCellArray{k,h,j}(3) =  deformedCellArray{k,h,j}(3) + displacementLeft(countLeft, 1);    %update width
                            countLeft = countLeft + 1;
                    end
                 end 
                 
             end
         end
      end

      

end