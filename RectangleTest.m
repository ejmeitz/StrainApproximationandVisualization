numFrames = size(deformedPosBoxArray,3);

    frames = [];
    clear('frames');
    name = inputdlg("Choose a file name");
    
  % set(gca,'color','black');
    xlim([0 size(s0,2)]);
    ylim([0 size(s0,1)]);
   
    sizeArray = size(deformedPosBoxArray);
    maxI = sizeArray(1);
    
  
    updateWaitbar = waitbarParfor(size(s0,3), "Drawing Rectangles");
        parfor h = 1:(numFrames)
        f = figure(1);
             for m = 1:maxI
                 %r =  allPosBoxArray(m,14,h);
                % g =  allPosBoxArray(m,15,h);
                % b =  allPosBoxArray(m,16,h);
                 %  rectangle('Position', allPosBoxArray(m,1:4,h),'FaceColor',[r g b],'LineStyle','none','LineWidth',0.01);
                  rectangle('Position', deformedPosBoxArray(m,1:4,h));


             end
          
          % set(gca,'color','black');
            set(gca,'visible','off')
           xlim([0 size(s0,2)]);
           ylim([0 size(s0,1)]);
   
     
    
            frames(h) = getframe(f);  %add frame to array
            clf(f);  %clear figure 
            updateWaitbar();
            close(f);
        end

    
    
    vidfile = VideoWriter(name,'MPEG-4');
    open(vidfile);
    for i = 1:numFrames 
        
        writeVideo(vidfile, frames(i));
    end
    close(vidfile);

