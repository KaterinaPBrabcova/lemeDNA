
%   "lemeDNA"
%   length measurement of DNA imaged by AFM
%   TESTING VERSION
%
%   Author.....: Katerina Pachnerova Brabcova
%                brabcova@ujf.cas.cz
%
%   Created.......: 2015, February
%   Last update...: 2018, February


%   INPUT:   
%   --------------------------------------------------------
%   name        - name of input RGB image
%   d           - width of RGB image in um
%   ds          - desired width of subimages in um 
%   threshold   - threshold of binary conversion <0,1>
%
%
%   OUTPUT:
%   --------------------------------------------------------
%   BIthin_prunning     - binary image after the analysis with 
%                         selected molecules and pixel lengths
%   AFM_lemeDNA.xlsx    - excel file with pixel lengths


clc; clear all
% removes all variables from system memory
warning ('off', 'images:initSize:adjustingMag');  
% turn off the warnigs about image resolution

%*************************
%1. INPUT
%*************************

% 1.1 RGB Image
name = 'trial.png';
[Iorig] = imread(name); 

fprintf('This is testing version. \n');

fprintf('Data will be written to excel file "AFM_lemeDNA.xlsx".\n')
fprintf('MAKE SURE IT IS CLOSED!\n');

% 1.2 Subimage
d = input('Width of the image in um: ');
ds = input('Desired width of subimage in um: ');

if ds<=d
  [I, sel] = SubImage(Iorig, d, ds);
else
    fprintf('Subimage dimension must be in interval (0,d>');
    return;
end

%*************************
%2. (SUB)IMAGE ANALYSIS
%*************************

% 2.1 Background, inversion, binary conversion
[noiseFreeI, BI] = BinaryConversion(I);

% 2.2 Selection and visual control
[BIs] = Selection(BI);

% 2.3 Thinning up to one-pixel line
BIthin = bwmorph(BIs, 'thin',100);

% 2.4 Pruning with visual control
[BIthin_pruning] = Pruning(BIthin);

%*************************
%3. LENGTH
%*************************

% 3.1 Parameters of Freeman chain code
BIthin_pruning = bwmorph(BIthin_pruning, 'clean');  % removing isolated pixels
BIl = bwlabel(BIthin_pruning, 8);      % indexes selected objects with integrer
s = max(BIl(:));                       % number of selected objects on the subimage
fprintf('Selected objects on the subimage: %d\n', s)

[odd, even] = Fchaincode(BIl, s);

% 3.2 Pixel length
[PL] = PixelLength(odd, even, s, BIthin_pruning, BIl, name, ds, sel, Iorig, d);
