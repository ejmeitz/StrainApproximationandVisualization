function [ aopRGB ] = scaleColorizeDoLP( aopIn, aLow, aHigh)
%scaleColorizeDoLP Colorize the DoLP with the Jet colormap, scaled between
%   dLow and dHigh

    aop = aopIn;

    aop(aop < aLow) = aLow;
    aop(aop > aHigh) = aHigh;
    aop = ((aop - aLow) ./ (aHigh - aLow))*(180);
    
    aopRGB = aopToColor(aop);   
    
%     tmp = aopRGB(1:size(aop,1),1:size(aop,2),:);
%     tmp(:,:,1) = ((aopIn > aLow) & (aopIn < aHigh)) .* tmp(:,:,1);
%     tmp(:,:,2) = ((aopIn > aLow) & (aopIn < aHigh)) .* tmp(:,:,2);
%     tmp(:,:,3) = ((aopIn > aLow) & (aopIn < aHigh)) .* tmp(:,:,3);
%     
%     aopRGB(1:size(aop,1),1:size(aop,2),:) = tmp;
end

