function min = getMinX(firstFrameAsCellArray)

    sizeArray = size(firstFrameAsCellArray);
    maxI = sizeArray(1);
    maxJ = sizeArray(2);

    min = Inf;

     for m = 1:maxI
             for n = 1:maxJ
                   if(~isempty(firstFrameAsCellArray{m,n}))
                        currentX = firstFrameAsCellArray{m,n}(1); %x vals are the first spot in each sub array
                        
                        if(currentX < min)
                            min = currentX;
                        end
                        
                   end
             end
     end

    return;
end