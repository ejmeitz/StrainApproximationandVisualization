%user will click and the x-coord of the fixed point in the gel will get
%passed into here along with the x-coord of where the gel starts and the
%initial width of a box

%returns the x-coord of the central box  (maybe make it return the index??)
function fixedX = findFixed (x, startX, initialBoxWidth)

    %probably a prettier way to do this (like with mod()) but this works 
    fixedX = startX;

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