function findSineWave(displacement)
    f = figure('Position',[100 200 1000 1000]);
    datacursormode(f,'on')
    plot(displacement);
    title('Select the first period of the sine wave');
    [x,y] = ginput(2);
    close(f);
    
     amp = 0.5*range(displacement);
    
    
        %find points on graph closest to clicked points
        firstX = min(x);
        lastX = max(x);
        
        firstX = floor(firstX)
        lastX = floor(lastX)
        
        
end