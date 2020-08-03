function drawRectangles(allPosBoxArray, imgXDim, imgYDim)

    frames = [];
    clear('frames');
    name = inputdlg("Choose a file name");
    fps = 20;
   
    numRows = size(allPosBoxArray,1);   
      numFrames = size(allPosBoxArray,3);
    
    updateWaitbar = waitbarParfor(numFrames, "Drawing Rectangles for AvgDoLP");
        parfor h = 1:(numFrames)
        f = figure;
             for m = 1:numRows
                 r =  allPosBoxArray(m,8,h);
                 g =  allPosBoxArray(m,9,h);
                 b =  allPosBoxArray(m,10,h);
                   rectangle('Position', allPosBoxArray(m,1:4,h),'FaceColor',[r g b],'LineStyle','none');
                  %rectangle('Position', deformedPosBoxArray(m,1:4,h));
             end
          
           set(gca,'color','black');
           % set(gca,'visible','off')
           xlim([0 imgXDim]);
           ylim([0 imgYDim]);
   
     
            frames(h) = getframe(f);  %add frame to array
            updateWaitbar();
            close(f);
        end

    
    name_str = string(name);
    name_str = strcat(name_str, "_AvgDoLP");
    vidfile = VideoWriter(name_str,'MPEG-4');
    vidfile.FrameRate = fps;
    open(vidfile);
    for i = 1:numFrames 
        
        writeVideo(vidfile, frames(i));
    end
    close(vidfile);
    clear('frames');
    
      updateWaitbar = waitbarParfor(numFrames, "Drawing Rectangles for AvgAoP");
        parfor h = 1:(numFrames)
        f = figure;
             for m = 1:numRows
                 r =  allPosBoxArray(m,11,h);
                 g =  allPosBoxArray(m,12,h);
                 b =  allPosBoxArray(m,13,h);
                   rectangle('Position', allPosBoxArray(m,1:4,h),'FaceColor',[r g b],'LineStyle','none');
                  %rectangle('Position', deformedPosBoxArray(m,1:4,h));
             end
          
           set(gca,'color','black');
           % set(gca,'visible','off')
           xlim([0 imgXDim]);
           ylim([0 imgYDim]);
   
     
            frames(h) = getframe(f);  %add frame to array
            updateWaitbar();
            close(f);
        end
    
    name_str = string(name);
    name_str = strcat(name_str, "_AvgAoP");
    vidfile = VideoWriter(name_str,'MPEG-4');
    vidfile.FrameRate = fps;
    open(vidfile);
    for i = 1:numFrames 
        
        writeVideo(vidfile, frames(i));
    end
    close(vidfile);
    clear('frames');
    
    
    
      updateWaitbar = waitbarParfor(numFrames, "Drawing Rectangles for StdAoP");
        parfor h = 1:(numFrames)
        f = figure;
             for m = 1:numRows
                 r =  allPosBoxArray(m,14,h);
                 g =  allPosBoxArray(m,15,h);
                 b =  allPosBoxArray(m,16,h);
                   rectangle('Position', allPosBoxArray(m,1:4,h),'FaceColor',[r g b],'LineStyle','none');
                  %rectangle('Position', deformedPosBoxArray(m,1:4,h));
             end
          
           set(gca,'color','black');
           % set(gca,'visible','off')
           xlim([0 imgXDim]);
           ylim([0 imgYDim]);
   
     
            frames(h) = getframe(f);  %add frame to array
            updateWaitbar();
            close(f);
        end
    
    name_str = string(name);
    name_str = strcat(name_str, "_StdAoP");
    vidfile = VideoWriter(name_str,'MPEG-4');
    vidfile.FrameRate = fps;
    open(vidfile);
    for i = 1:numFrames 
        writeVideo(vidfile, frames(i));
    end
    close(vidfile);
    