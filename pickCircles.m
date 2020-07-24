function [chosenCircles, threshUp, threshDown] = pickCircles(s0)    %scaled s0 by 500

    %settings
    brushSize = 4;
    minRad = 18;
    maxRad = 100;
    
    brush = strel('disk', brushSize);
    
    img = s0(:,:,1);
    img_erode = imerode(img,brush);
    Iobr = imreconstruct(img_erode,img);

    chosenCircles  = zeros(2,2);
   uiwait(msgbox('Adjust sliders until only the circular pins are visible','Marker Selection','modal'));


   
      %have user apply threshold 
      [threshUp,threshDown] = setThresh();
      %apply circle alg to find circles in img
      
 
   
  %global vars break!!!!!
    function pickCirclesUI(filled_img) 
        
      f = figure();
      [centers, radii] = imfindcircles(filled_img, [minRad maxRad]);
      imshow(filled_img);
      viscircles(centers,radii);


      b1 = uicontrol(f,'style', 'pushbutton', 'string', 'Done', 'CallBack', {@buttonPushed,f});
      b1.Position = [210 20 100 20];
      set(b1,'Enable','off')
      b2 = uicontrol(f,'style', 'pushbutton', 'string', 'Change Mask', 'CallBack', {@changeMask,f});
      b2.Position = [110 20 100 20];
      b3 = uicontrol(f,'style', 'pushbutton', 'string', 'Choose Circles', 'CallBack', {@chooseCircles, centers, radii, b1, b2});
      b3.Position = [10 20 100 20];
      uiwait(msgbox('Click INSIDE two circles on opposite sides of the gel. The circles should be over the pins','Marker Selection','modal'));
    
      uiwait;
    end
     
  function buttonPushed(source, eventdata, fig) 
        close(fig);
        return;
  end

  function changeMask(source, eventdata,fig) 
        close(fig);
        [u,d] = setThresh();
         assignin('base', 'threshUp', u);
         assignin('base', 'threshDown', d);
        return;
  end

    function chooseCircles(source, eventdata, centers, radii, b1, b2) 
       set(b2,'Enable','off')
          [firstX, firstY] = ginput(1);
          [secondX, secondY] = ginput(1);
         temp  = zeros(2,2);
           %check which circles the chosen points reside within
        for i = 1:length(centers)
            distanceToCenter1 = sqrt(((firstX-centers(i,1))^2) + (firstY - centers(i,2))^2);
            distanceToCenter2 = sqrt(((secondX-centers(i,1))^2) + (secondY - centers(i,2))^2);

            if(distanceToCenter1 < radii(i,1))
                temp(1,1) = centers(i,1);
                temp(1,2) = centers(i,2);
            end
            if(distanceToCenter2 < radii(i,1))
                temp(2,1) = centers(i,1);
                temp(2,2) = centers(i,2);
            end
        end
        
       assignin('base', 'chosenCircles', temp);
       set(b2,'Enable','on')
       set(b1,'Enable','on')
            return;
  end

    function [threshUp, threshDown] =  setThresh()
       
       [threshUp, threshDown] =  slideThresh(Iobr);

       %create the binary threshold img
       thresh_img = (Iobr<=threshUp) & (Iobr>=threshDown);

       %fill in holes in image so circle alg works better
       filled_img = imfill(thresh_img,8,'holes');
       pickCirclesUI(filled_img);
       return;
    end

  return;  
end


