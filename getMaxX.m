function max = getMaxX(firstFrameAsCellArray)

    sizeArray = size(firstFrameAsCellArray);
    maxI = sizeArray(1);
    maxJ = sizeArray(2);

    max = 0;

     for m = 1:maxI
             for n = 1:maxJ
                   if(~isempty(firstFrameAsCellArray{m,n}))
                        currentX = firstFrameAsCellArray{m,n}(1); %x vals are the first spot in each sub array
                        
                        if(currentX > max)
                            max = currentX;
                        end
                        
                   end
             end
     end

    return;
end