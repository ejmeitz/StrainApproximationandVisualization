function [ dolpJet ] = dolpToColor( dolp )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    dolpJet = zeros(size(dolp,1),size(dolp,2),3);
    
    dolpJet(:,:,1) = (((dolp >= 0.375) & (dolp < 0.625)) .* (4*dolp - 1.5)) + (((dolp >= 0.625) & (dolp < 0.875)) + ((dolp >= 0.875).*(-4*dolp + 4.5)));
    dolpJet(:,:,2) = (((dolp >= 0.125) & (dolp < 0.375)) .* (4*dolp - 0.5)) + (((dolp >= 0.375) & (dolp < 0.625)) + (((dolp >= 0.625) & (dolp < 0.875)).*(-4*dolp + 3.5)));
    dolpJet(:,:,3) = (((dolp < 0.125).*(4*dolp + 0.5)) + ((dolp >= 0.125) & (dolp < 0.375)) + (((dolp >= 0.375) & (dolp < 0.625)).*(-4*dolp + 2.5)));
    %dolpJet(dolp == 1) = [0.5 0 0];

end

