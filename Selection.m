function [BIs] = Selection(BI)
%   SELECTION OF MOLECULES
%   TESTING VERSION
%
%   Description: Manual selection of objects (DNA molecules)
%                for further analysis,  
%                and visual control
%
%   Author.....: KPB
%
%   Created.......: 2017, April
%   Last update...: 
%   
%
%   INPUT:
%   --------------------------------------------------------
%   BI          - binary image          
%
%   OUTPUT:
%   --------------------------------------------------------
%   BIs         - binary image with selected objects  

visual = 0;
while visual == 0

% Selection of objects for analysis
fprintf('Select objects for analysis; after the selection, press enter.\n');
[BIs] = bwselect(BI,8);  

% Visual control of the selection
BIsl = bwlabel(BIs, 8);
number = max(BIsl(:));
for i=1:1:number
[s1 s2] = find(BIsl == i);
s = [s1 s2];
hold on
plot(s(:,2), s(:,1), 'b.')
end

visual = input('Is the selection ok? yes 1/no 0:');
end

if visual == 1
    close all
else
    fprintf('Invalid answer.');  %will proceed as selection ok
end

end

