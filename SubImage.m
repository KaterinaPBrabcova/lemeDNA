function [ I, sel ] = SubImage( Iorig, d , ds)
%   SMALLER SUBIMAGES
%   TESTING VERSION
%
%   Description: Division of the AFM image into nxn um subimages
%                and selection of the i-subimage for further analysis
%
%   Author.....: KPB
%
%   Created.......: 2015, May
%   Last update...: 2018, July
%   
%
%   INPUT:
%   --------------------------------------------------------
%   Iorig           - RGB image
%   d               - width of RGB image in um
%   ds              - desired width of subimages in um
%
%   OUTPUT:
%   --------------------------------------------------------
%   I               - selected RGB subimage
%   sel             - number of selected subimage for analysis

lwrgb = size(Iorig);

col1 = lwrgb(2)/d;    %columns for 1 um
coln = col1*ds;       %columns for n um

w = lwrgb(2)/coln;
w = ceil(w);          %round up     
l = lwrgb(2)/coln;
l = ceil(l);          
images = w*l;

if images ==1         %original image for analysis, no division
   I = Iorig;
   sel = 1;
else
    fprintf('Image will be divided into %d subimages.\n', images)
    i=1:1:l*w;
    Subimages = reshape(i,w,l);
    Subimages = Subimages'
    sel = input('Selected subimage for analysis: ');

    if sel > images || sel <=0
        error('The subimage selection failed.')
    else
    [r c] = find(Subimages==sel);
    Iorig1 = ceil(coln*r-coln+1:min(coln*r,lwrgb(1)));
    Iorig2 = ceil(coln*c-coln+1:min(coln*c,lwrgb(2)));
    I=Iorig(Iorig1, Iorig2, :);    
    end
    end 

end

