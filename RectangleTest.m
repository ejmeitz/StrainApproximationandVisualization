numFrames = size(allPosBoxArray,3);

    frames = [];
    clear('frames');
    name = inputdlg("Choose a file name");
    
%    set(gca,'color','black');
%     xlim([0 size(s0,2)]);
%     ylim([0 size(s0,1)]);
   
    maxI = size(allPosBoxArray,1);   
  
    updateWaitbar = waitbarParfor(size(s0,3), "Drawing Rectangles");
        parfor h = 1:(numFrames)
        f = figure;
             for m = 1:maxI
                 r =  allPosBoxArray(m,8,h);
                 g =  allPosBoxArray(m,9,h);
                 b =  allPosBoxArray(m,10,h);
                   rectangle('Position', allPosBoxArray(m,1:4,h),'FaceColor',[r g b],'LineStyle','none');
                  %rectangle('Position', deformedPosBoxArray(m,1:4,h));
             end
          
           set(gca,'color','black');
           % set(gca,'visible','off')
           xlim([0 size(s0,2)]);
           ylim([0 size(s0,1)]);
   
     
            frames(h) = getframe(f);  %add frame to array
            updateWaitbar();
            close(f);
        end

    
    name_str = string(name);
    vidfile = VideoWriter(name,'MPEG-4');
    open(vidfile);
    for i = 1:numFrames 
        
        writeVideo(vidfile, frames(i));
    end
    close(vidfile);

