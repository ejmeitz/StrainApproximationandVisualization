function [ aopRGB ] = aopToColorNoBar( AoP )
%aopToColor Creates AoP image with colorbar
%   Detailed explanation goes here

aopHSV(:,:,1) = AoP ./ 180;
aopHSV(:,:,2) = 0.8;
aopHSV(:,:,3) = 0.9;

aopRGB = hsv2rgb(aopHSV);

% hsvBar(:,:,1) = squeeze(repmat(linspace(180,0,size(AoP,1))./180,[1 1 48]));
% hsvBar(:,:,2) = 0.8;
% hsvBar(:,:,3) = 0.9;
% 
% rgbBar = hsv2rgb(hsvBar);
% 
% aopRGB = cat(2,aopRGB,rgbBar);

end

