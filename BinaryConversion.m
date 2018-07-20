function [noiseFreeI, BI] = BinaryConversion(I)
%   BINARY CONVERSION 
%   TESTING VERSION
%
%   Description: Reduction of the noise, inversion, binary conversion
%
%   Author.....: KPB
%
%   Created.......: 2017, April
%   Last update...: 
%   
%
%   INPUT:
%   --------------------------------------------------------
%   I           - RGB image/subimage
%   threshold   - binary conversion
%            
%   OUTPUT:
%   --------------------------------------------------------
%   noisefreeI  - rgb without 'salt and pepper' noise, option: inverted
%   BI          - binary image 

% Extract salt and pepper noise
    rgbImage = I;
    [rows columns numberOfColorBands] = size(rgbImage);

    % Extract the individual red, green, and blue color channels.
    redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    blueChannel = rgbImage(:, :, 3);

    % Generate a noisy image. 
    noisyRGB = imnoise(rgbImage,'salt & pepper', 0.05);

    % Extract the individual red, green, and blue color channels.
    redChannel = noisyRGB(:, :, 1);
    greenChannel = noisyRGB(:, :, 2);
    blueChannel = noisyRGB(:, :, 3);

    % Median Filter the channels:
    redMF = medfilt2(redChannel, [3 3]);
    greenMF = medfilt2(greenChannel, [3 3]);
    blueMF = medfilt2(blueChannel, [3 3]);

    % Find the noise in the red.
    noiseImage = (redChannel == 0 | redChannel == 255);
    % Get rid of the noise in the red by replacing with median.
    noiseFreeRed = redChannel;
    noiseFreeRed(noiseImage) = redMF(noiseImage);

    % Find the noise in the green.
    noiseImage = (greenChannel == 0 | greenChannel == 255);
    % Get rid of the noise in the green by replacing with median.
    noiseFreeGreen = greenChannel;
    noiseFreeGreen(noiseImage) = greenMF(noiseImage);

    % Find the noise in the blue.
    noiseImage = (blueChannel == 0 | blueChannel == 255);
    % Get rid of the noise in the blue by replacing with median.
    noiseFreeBlue = blueChannel;
    noiseFreeBlue(noiseImage) = blueMF(noiseImage);

    % Reconstruct the noise free RGB image
    noiseFreeI = cat(3, noiseFreeRed, noiseFreeGreen, noiseFreeBlue);
    
% Inversion of rgb colours in case of adhesion image
inv = input('Requires the image inversion? yes 1/no 0:'); 
switch inv
    case 1
    noiseFreeI = imcomplement(noiseFreeI);
    case 0
    noiseFreeI = noiseFreeI;
    otherwise
    fprintf('Invalid answer.');
    return;
end
    
% Binary conversion
threshold = input('Threshold from interval <0,1>: ');   
BI = im2bw(noiseFreeI, threshold);
figure, imshow(BI, 'InitialMagnification', 'fit');

satisfaction = input('Is the conversion ok? yes 1/no 0:');

while satisfaction == 0
    threshold = input('New threshold from interval <0,1>: '); 
    BI = im2bw(noiseFreeI, threshold);
    figure, imshow(BI);
    hold on
satisfaction = input('Is the conversion ok? yes 1/no 0:');
end

if satisfaction ~= 1 
   fprintf('Invalid answer.');
   return;
end
close all
end

