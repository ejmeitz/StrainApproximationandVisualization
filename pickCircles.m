function [chosenCircles, threshUp, threshDown] = pickCircles(s0)    %scaled s0 by 500

    %settings
    brushSize = 4;
    minRad = 18;
    maxRad = 100;
    
    brush = strel('disk', brushSize);
    
    img = s0(:,:,1);
    img_erode = imerode(img,brush);
    Iobr = imreconstruct(img_erode,img);

   %have user apply threshold  
   uiwait(msgbox('Adjust sliders until only the circular pins are visible','Marker Selection','modal'));
   [threshUp, threshDown] =  slideThresh(Iobr);
  
   %create the binary threshold img
   thresh_img = (Iobr<=threshUp) & (Iobr>=threshDown);
   
   %fill in holes in image so circle alg works better
   filled_img = imfill(thresh_img,8,'holes');
   
    %apply circle alg to find circles in img
   [centers, radii] = imfindcircles(filled_img, [minRad maxRad]);
   imshow(filled_img);
   viscircles(centers,radii);
   uiwait(msgbox('Click INSIDE two circles on opposite sides of the gel. The circles should be over the pins','Marker Selection','modal'));

    [firstX, firstY] = ginput(1);
    [secondX, secondY] = ginput(1);
    
    %check which circles the chosen points reside within
    chosenCircles = zeros(2,2);
    for i = 1:length(centers)
        distanceToCenter1 = sqrt(((firstX-centers(i,1))^2) + (firstY - centers(i,2))^2);
        distanceToCenter2 = sqrt(((secondX-centers(i,1))^2) + (secondY - centers(i,2))^2);
        
        if(distanceToCenter1 < radii(i,1))
            chosenCircles(1,1) = centers(i,1);
            chosenCircles(1,2) = centers(i,2);
        end
        if(distanceToCenter2 < radii(i,1))
            chosenCircles(2,1) = centers(i,1);
            chosenCircles(2,2) = centers(i,2);
        end
    end
    

end