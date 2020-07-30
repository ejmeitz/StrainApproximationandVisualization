function [ polData ] = polProcessMatCalLanczos_LAKE( raw , C)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    cols = size(raw,2);
    rows = size(raw,1);
   
    polData = struct('I0',0,'I45',0,'I90',0,'I135',0,'S0',0,'S1',0,'S2',0,'DoLP',0,'AoP',0);

	%cal = (squeeze(raw) - darks') .* gains';
    
%     polData.I0 = raw(1:2:cols,1:2:rows);
%     polData.I45 = raw(1:2:cols,2:2:rows);
%     polData.I90 = raw(2:2:cols,2:2:rows);
%     polData.I135 = raw(2:2:cols,1:2:rows);

    i90 = raw(1:2:end,1:2:end);
    i135 = raw(1:2:end,2:2:end);
    i0 = raw(2:2:end,2:2:end);
    i45 = raw(2:2:end,1:2:end);
    
    i0c = (squeeze(C(1,1,:,:)).*i0) + (squeeze(C(1,2,:,:)).*i90) + (squeeze(C(1,3,:,:)).*i45) + (squeeze(C(1,4,:,:)).*i135);    
    i90c = (squeeze(C(2,1,:,:)).*i0) + (squeeze(C(2,2,:,:)).*i90) + (squeeze(C(2,3,:,:)).*i45) + (squeeze(C(2,4,:,:)).*i135);
    i45c = (squeeze(C(3,1,:,:)).*i0) + (squeeze(C(3,2,:,:)).*i90) + (squeeze(C(3,3,:,:)).*i45) + (squeeze(C(3,4,:,:)).*i135);
    i135c = (squeeze(C(4,1,:,:)).*i0) + (squeeze(C(4,2,:,:)).*i90) + (squeeze(C(4,3,:,:)).*i45) + (squeeze(C(4,4,:,:)).*i135);
    
    lancFilt = [sinc(-2.5/3)*sinc(2.5), 0, sinc(-1.5/3)*sinc(-1.5), 0, sinc(-0.5/3)*sinc(0.5), 1, sinc(0.5/3)*sinc(0.5) 0, sinc(1.5/3)*sinc(1.5), 0, sinc(2.5/3)*sinc(2.5)];
    
    i0i = zeros(rows,cols,'single');
    i0i(2:2:end,2:2:end) = i0c;
    i0c = conv2(lancFilt,lancFilt,i0i,'same');
    
    i45i = zeros(rows,cols,'single');
    i45i(2:2:end,1:2:end) = i45c;
    i45c = conv2(lancFilt,lancFilt,i45i,'same');
    
    i90i = zeros(rows,cols,'single');
    i90i(1:2:end,1:2:end) = i90c;
    i90c = conv2(lancFilt,lancFilt,i90i,'same');
    
    i135i = zeros(rows,cols,'single');
    i135i(1:2:end,2:2:end) = i135c;
    i135c = conv2(lancFilt,lancFilt,i135i,'same');    
    
    polData.I0 = i0c;
    polData.I45 = i45c;
    polData.I90 = i90c;
    polData.I135 = i135c;
%     for ix = 1:cols/2
%         for jx = 1:rows/2
%                 superpix = [polData.I0(ix,jx);polData.I90(ix,jx);polData.I45(ix,jx);polData.I135(ix,jx)];
%                 Ixy = C(:,:,ix,jx)*superpix;
%                 polData.I0(ix,jx) = Ixy(1);polData.I90(ix,jx) = Ixy(2);polData.I45(ix,jx) = Ixy(3);polData.I135(ix,jx) = Ixy(4);
%         end
%     end

%    polData.I0 = (squeeze(C(1,1,:,:)).*polData.I0) + (squeeze(C(1,2,:,:)).*polData.I45) + (squeeze(C(1,3,:,:)).*polData.I90) + (squeeze(C(1,4,:,:)).*polData.I135);
%    polData.I45 = (squeeze(C(2,1,:,:)).*polData.I0) + (squeeze(C(2,2,:,:)).*polData.I45) + (squeeze(C(2,3,:,:)).*polData.I90) + (squeeze(C(2,4,:,:)).*polData.I135);
%    polData.I90 = (squeeze(C(3,1,:,:)).*polData.I0) + (squeeze(C(3,2,:,:)).*polData.I45) + (squeeze(C(3,3,:,:)).*polData.I90) + (squeeze(C(3,4,:,:)).*polData.I135);
%    polData.I135 = (squeeze(C(4,1,:,:)).*polData.I0) + (squeeze(C(4,2,:,:)).*polData.I45) + (squeeze(C(4,3,:,:)).*polData.I90) + (squeeze(C(4,4,:,:)).*polData.I135);    
  

%    polData.I0 = (squeeze(C(1,1,:,:)).*polData.I0) + (squeeze(C(1,2,:,:)).*polData.I90) + (squeeze(C(1,3,:,:)).*polData.I45) + (squeeze(C(1,4,:,:)).*polData.I135);
%    polData.I90 = (squeeze(C(2,1,:,:)).*polData.I0) + (squeeze(C(2,2,:,:)).*polData.I90) + (squeeze(C(2,3,:,:)).*polData.I45) + (squeeze(C(2,4,:,:)).*polData.I135);
%    polData.I45 = (squeeze(C(3,1,:,:)).*polData.I0) + (squeeze(C(3,2,:,:)).*polData.I90) + (squeeze(C(3,3,:,:)).*polData.I45) + (squeeze(C(3,4,:,:)).*polData.I135);
%    polData.I135 = (squeeze(C(4,1,:,:)).*polData.I0) + (squeeze(C(4,2,:,:)).*polData.I90) + (squeeze(C(4,3,:,:)).*polData.I45) + (squeeze(C(4,4,:,:)).*polData.I135);  

    polData.S0 = (0.5)*(polData.I0 + polData.I45 + polData.I90 + polData.I135);
    polData.S1 = polData.I0 - polData.I90;
    polData.S2 = polData.I45 - polData.I135;
    
    polData.DoLP = sqrt((polData.S1).^2 + (polData.S2).^2)./polData.S0;
    
    %S0n = polData.S0 / (2*4095);
    
    %polData.DoLP(S0n < 0.05) = 0;
    %polData.DoLP(polData.DoLP > 1) = 1;
    
    polData.AoP = atan2(polData.S2,polData.S1);
    %polData.AoP(polData.AoP < 0) = polData.AoP(polData.AoP < 0) + pi;
    %polData.AoP = polData.AoP * (180/pi);
    polData.AoP(polData.AoP < 0) = polData.AoP(polData.AoP < 0) + (2*pi);
    polData.AoP = polData.AoP * (90/pi);
   
%     aopHSV(:,:,1) = polData.AoP / 180;
%     aopHSV(:,:,2) = 0.8;
%     aopHSV(:,:,3) = 0.9;
    
    % aopTh = aopHSV(:,:,1);
    % %aopTh((polData.DoLP < 0.01) | (polData.S0/(2*4095))<0.01) = 0;
    % aopHSV(:,:,1) = aopTh;
    % aopTh = aopHSV(:,:,2);
    % %aopTh((polData.DoLP < 0.01) | (polData.S0/(2*4095))<0.01) = 0;
    % aopHSV(:,:,2) = aopTh;
    % aopTh = aopHSV(:,:,3);
    % %aopTh((polData.DoLP < 0.01) | (polData.S0/(2*4095))<0.01) = 0;
    % aopHSV(:,:,3) = aopTh;
       
%     polData.aopRGB = hsv2rgb(aopHSV);
%     
%     hsvBar(:,:,1) = zeros(rows,48);
%     hsvBar(:,:,2) = 0.8;
%     hsvBar(:,:,3) = 0.9;
    
%     x = linspace(180,0,rows);
%     
%     for ix = 1:rows
%         hsvBar(ix,:,1) = x(ix)/180;
%     end
%     
%     rgbBar = hsv2rgb(hsvBar);
%     
%     polData.aopRGB = cat(2,polData.aopRGB,rgbBar);
    
%     dolp = polData.DoLP;
%     dolp(dolp < dLow) = 0;
%     dolp(dolp > dHigh) = dHigh;
%     dolp = dolp ./ dHigh;
%     
%     dolpBar = squeeze(repmat(linspace(1,0,rows),[1 1 48]));
%     dolpBar(dolpBar < dLow) = 0;
%     dolpBar(dolpBar > dHigh) = dHigh;
%     dolpBar = dolpBar ./ dHigh;
%     
%     polData.dolpRGB = dolpToColor(cat(2,dolp,dolpBar));

end

