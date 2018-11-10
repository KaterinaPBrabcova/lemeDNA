function [BIthin_pruning] = Pruning(BIthin)
%   PRUNING
%   TESTING VERSION
%
%   Description: Pruning of false branches
%                appearing due to AFM background
%                 
%   Author.....: KPB
%
%   Created.......: 2017, August
%   Last update...: 2018, February
%   
%
%   INPUT:
%   --------------------------------------------------------
%   BIthin          - Selected objects after thinning to one-pixel lines
%   pruning_index   - length of the branches (in pixels) to be removed;
%                     defaultly set to 50
%                           
%   OUTPUT:
%   --------------------------------------------------------
%   BIthin_pruning  - binary image with the selected objects 
%                     after thinning to one-pixel lines
%                     and pruning 

visual =0;
pruning_index = 20;   %default 

% Adding 1-pixel-width-edge of zeros to the analysed image
% to solve the problem of analyzing molecules with edge pixels

sizeBIthin = size(BIthin);
BIthinedge = zeros(sizeBIthin(1)+2, sizeBIthin(2)+2);
sizeBIthinedge = size(BIthinedge);
BIthinedge(2:sizeBIthinedge(1)-1, 2:sizeBIthinedge(2)-1)=BIthin;

% Identifiation of crosses
BIbranch = bwmorph(BIthinedge, 'branchpoints');
[b1,b2] = find(BIbranch == 1);
b = [b1 b2];

% Identification of endpoints
BIend = bwmorph(BIthinedge, 'endpoints');
[e1,e2] = find(BIend == 1);
e = [e1,e2];

if isempty(b)==1      %if no braches found, skip prunig
   BIthin_prunning = BIthinedge;
   
else  
while visual==0       %visual control of pruning process
BIthin_pruning = BIthinedge;

for i = 1:length(e);  %each endpoint is tested

center = e(i,:);      %tested pixel, starts from an endpoint
BIthin_actual = BIthin_pruning;     %BIthin_actual = working copy

pruning_actual = 0;                 %pruning_actual = working copy

pruning_b = false;

j = 2;

clear eb
eb(1,:)=e(i,:);                     %tracking of a branch

% Tracking of a branch run until the tail is shorter than pruning_index 
% or the tested pixel center is branchpoint

% Directions around the tested pixel to be checked
%    3      2       1
%    4    center    8
%    5      6       7

while pruning_actual < pruning_index && ~pruning_b
   
   if BIthin_actual(center(1)-1, center(2)+1)==1  %direction 1
       eb(j,:) = [center(1)-1, center(2)+1];
   end
   
   if BIthin_actual(center(1)-1, center(2))==1    %direction 2
       eb(j,:) = [center(1)-1, center(2)];
   end
     
   if BIthin_actual(center(1)-1, center(2)-1)==1  %direction 3
       eb(j,:) = [center(1)-1, center(2)-1];
   end 
      
   if BIthin_actual(center(1), center(2)-1)==1    %direction 4
       eb(j,:) = [center(1), center(2)-1];
   end 
   
   if BIthin_actual(center(1)+1, center(2)-1)==1  %direction 5
       eb(j,:) = [center(1)+1, center(2)-1];
   end 
      
   if BIthin_actual(center(1)+1, center(2))==1    %direction 6
       eb(j,:) = [center(1)+1, center(2)];
   end 
      
   if BIthin_actual(center(1)+1, center(2)+1)==1  %direction 7
       eb(j,:) = [center(1)+1, center(2)+1];
   end 
      
   if BIthin_actual(center(1), center(2)+1)==1    %direction 8
       eb(j,:) = [center(1), center(2)+1];
   end

    %In next step this direction needs to be omitted from testing
    BIthin_actual(center(1),center(2))=false;   
    
    % Move forward only if any direction was positively tested
    if j <= size(eb, 1)
    center = eb(j,:);
    j = j+1;
    else break
    end

    pruning_actual = length(eb);

    pruning_b = any((b(:,1)==center(1) & b(:,2)==center(2)));
end

% Deleting of the false branches
if j < pruning_index
   BIthin_pruning = BIthin_actual;
end

end

% Visual control of the pruning
figure, imshow(BIthinedge, 'InitialMagnification', 'fit');

BIthin_p = bwlabel(BIthin_pruning, 8);
number = max(BIthin_p(:));
for p=1:1:number
[s1 s2] = find(BIthin_p == p);
s = [s1 s2];
hold on
plot(s(:,2), s(:,1), 'b.')
end

visual = input('Is the pruning ok? yes 1/no 0:');
if visual ==0
fprintf('Pruning index is %d. ', pruning_index)
pruning_index = input('Setup pruning index to: '); 
else close all
end

if visual == 1
    close all
else
end
end

end

