function [ PL ] = PixelLength( odd, even, s, BIthin_pruning, BIl, name, ds, sel, Iorig, d)
%   PIXEL LENGTH 
%   TESTING VERSION
%
%   Description: Calculation of pixel length and writting to the excel
%
%   Author.....: KPB
%
%   Created.......: 2018, January
%   Last update...: 2018, February
%   
%
%   INPUT:
%   --------------------------------------------------------
%   odd, even       - directions of 4-connected Freeman chain code,
%                   used direction-to-code convention is
%   s               - number of selected objects
%   BIthin_pruning  - binary image with the selected objects 
%                     after thinning to one-pixel lines
%                     and pruning
%   BIl             - binary image with labeled selected np-by-2 objects
%   name            - name of open image file
%   ds              - desired width of subimages in um
%   sel             - number of selected subimage for analysis
%   Iorig           - original RGB image
%   d           - width of RGB image in um
%
%   OUTPUT:
%   --------------------------------------------------------
%   PL              - pixel length


% Pixel resolution of the original image
[height, width, dim] = size(Iorig);   
R = d/width;

% Correction factor c dependent on image resolution R
% set for persistence length of 50 nm
% according to C. Rivetti, Cytometry 75A, 854 (2009)
c = 0.9479+0.00433*R;

% Freeman estimator with the correction factor
PL = round(c*(sqrt(odd)+even), 1);  
    

%  Display number of each molecule and its pixel length
figure, imshow(BIthin_pruning, 'InitialMagnification', 'fit');
hold on
for i=1:1:s
    [sc1,sc2] = find(BIl==i);
    sc = [sc1,sc2];
    string1 = [num2str(i)];
    string2 = [num2str(PL(i))];
    string12 = {string1, ':', string2};
    string = sprintf('%s %s',string12{:});
    text(min(sc(:,2)), min(sc(:,1)), string, 'Color', 'red', 'FontSize', 14, 'FontWeight', 'bold');
    hold on
end

% Writing data to excel 
exdatacal = xlsread('AFM_lemeDNA.xlsx', 'calibration');
[exdatarcal, exdataccal] = size(exdatacal);
newdatarcal = 6 + exdatarcal;         %size of possible previous calibration data
                                      %in excel

exdata = xlsread('AFM_lemeDNA.xlsx', 'data');
[exdatar, exdatac] = size(exdata);
newdatar = 6 + exdatar;               %size of possible previous data
                                      %in excel

% Select calibration molecules
cal = input('Write number of molecules for calibration in [], separated by space. If there is not any, write 0 without []:');

% Writing calibration data to excel, sheet calibration
if cal ~= 0

% Image, calibration, column A
newdatarA = {'A', newdatarcal};
newA = sprintf('%s %d',newdatarA{:});
xlswrite('AFM_lemeDNA.xlsx', {name}, 'calibration', newA);

% Subimage width, calibration, column B
newdatarB = {'B', newdatarcal};
newB = sprintf('%s %d',newdatarB{:});
xlswrite('AFM_lemeDNA.xlsx', ds, 'calibration', newB);

% Subimage, calibration, column C
newdatarC = {'C', newdatarcal};
newC = sprintf('%s %d',newdatarC{:});
xlswrite('AFM_lemeDNA.xlsx', sel, 'calibration', newC);

% Odd (pixel), calibration, column D
newdatarD = {'D', newdatarcal};
newD = sprintf('%s %d',newdatarD{:});
xlswrite('AFM_lemeDNA.xlsx', odd(cal), 'calibration', newD);

% Even (pixel), calibration, column E
newdatarE = {'E', newdatarcal};
newE = sprintf('%s %d',newdatarE{:});
xlswrite('AFM_lemeDNA.xlsx', even(cal), 'calibration', newE);

% Length (pixel), calibration, column F
newdatarF = {'F', newdatarcal};
newF = sprintf('%s %d',newdatarF{:});
xlswrite('AFM_lemeDNA.xlsx', PL(cal), 'calibration', newF);

% Assign to the calibration values zero values
odd(cal) = 0;
even(cal) = 0;
PL(cal) = 0;
end

% Writing analysed data to excel, sheet data

% Delete the data already written to the calibration sheet
PLzero = find(PL==0);
odd(PLzero)=[];
even(PLzero)=[];
PL(PLzero)=[];

% Image, data, column A
newdatarA = {'A', newdatar};
newA = sprintf('%s %d',newdatarA{:});
xlswrite('AFM_lemeDNA.xlsx', {name}, 'data', newA);

% Subimage width, data, column B
newdatarB = {'B', newdatar};
newB = sprintf('%s %d',newdatarB{:});
xlswrite('AFM_lemeDNA.xlsx', ds, 'data', newB);

% Subimage, data, column C
newdatarC = {'C', newdatar};
newC = sprintf('%s %d',newdatarC{:});
xlswrite('AFM_lemeDNA.xlsx', sel, 'data', newC);

% Odd (pixel), data, column D
newdatarD = {'D', newdatar};
newD = sprintf('%s %d',newdatarD{:});
xlswrite('AFM_lemeDNA.xlsx', odd, 'data', newD);

% Even (pixel), data, column E
newdatarE = {'E', newdatar};
newE = sprintf('%s %d',newdatarE{:});
xlswrite('AFM_lemeDNA.xlsx', even, 'data', newE);

% Length (pixel), data, column F
newdatarF = {'F', newdatar};
newF = sprintf('%s %d',newdatarF{:});
xlswrite('AFM_lemeDNA.xlsx', PL, 'data', newF);

end

