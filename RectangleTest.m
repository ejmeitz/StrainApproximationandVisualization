numFrames = size(allPosBoxArray,3);

    frames = [];
    clear('frames');
    
    f = figure(1);
   %$set(gca,'color','black');
    xlim([0 size(s0,2)]);
    ylim([0 size(s0,1)]);
   
    sizeArray = size(allPosBoxArray);
    maxI = sizeArray(1);
    
  
    
    abc = waitbar(0,'Drawing boxes...');
    %when true grip is pulling on the right

        count = 1;
        for h = 1:(numFrames)
          
            
             for m = 1:maxI
               %  r =  allPosBoxArray(m,14,h);
                % g =  allPosBoxArray(m,15,h);
               %  b =  allPosBoxArray(m,16,h);
                %   rectangle('Position', allPosBoxArray(m,1:4,h),'FaceColor',[r g b],'LineStyle','none','LineWidth',0.01);
                   rectangle('Position', allPosBoxArray(m,1:4,h));


             end
          
          % set(gca,'color','black');
           xlim([0 size(s0,2)]);
           ylim([0 size(s0,1)]);
   
     
    
            frames(count) = getframe(f);  %add frame to array
            clf(f);  %clear figure 
             waitbar(count/(numFrames));
             count = count + 1;  
        end

    close(f);
    close(abc);
  
    set(gca,'visible','off')
    movie(frames,1000,30); %play movie x times at y fps
