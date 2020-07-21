%user will click and the x-coord of the fixed point in the gel will get
%passed into here along with the x-coord of where the gel starts and the
%initial width of a box

%returns the x-coord of the central box  (maybe make it return the index??)
function fixedX = findFixed (firstFrameAsCellArray)

    sizeArray = size(firstFrameAsCellArray);
    maxI = sizeArray(1);
    maxJ = sizeArray(2);
    
     temp = figure(1);
         %draw first frame
        for m = 1:maxI
             for n = 1:maxJ
                   if(~isempty(firstFrameAsCellArray{m,n}))
                             rectangle('Position', firstFrameAsCellArray{m,n});
                   end
             end
        end
    
    title("Click the fixed point");
    coordinates_input = ginput(1);
    x = round(coordinates_input(1));
    y = round(coordinates_input(2));
    close(temp);

   
    startX = getMinX(firstFrameAsCellArray); 
    fixedX = startX; %this should be the furthest to the left x in the image
    initialBoxWidth = firstFrameAsCellArray{1,1}(3);  %3 value in sub array is width
    
    
    if(x < startX)
        error("You picked a point to the left of the gel region");
    end

    %this will break once we reach the point and i will match the edge of the
    %next box to the right of the point
      while(fixedX < x)
         fixedX = fixedX + initialBoxWidth; 
      end

    return;

end