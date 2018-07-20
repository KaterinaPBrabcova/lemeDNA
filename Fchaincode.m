function [odd, even] = Fchaincode(BIl,s)
%   SUM OF FREEMAN CHAIN CODE
%
%   Description: Sum of odd and even directions of Freeman chain code 
%                8-connected representation of a
%                boundary
%                Number of molecule's crossings

%   Author.....: KPB

%   Date..........: 2015, May
%   
%
%   INPUT:
%   --------------------------------------------------------
%   BIl     - binary image with labeled selected np-by-2 objects
%   s       - number of selected objects
%
%            
%
%   OUTPUT:
%   --------------------------------------------------------
%   
%   odd, even     - directions of 4-connected Freeman chain code,
%                   used direction-to-code convention is:
%   
%                                               3  2  1
%                                                \ | /
%                                             4 -- P -- -
%                                                / | \
%                                               -  -  -

odd = zeros(s,1);
even = zeros(s,1);

for i=1:1:s
    [row col] = find(BIl==i);
    o = [row col];                            %object coordinates
 
      for oi=1:1:length(o)
  
        if BIl(o(oi,1)+1, o(oi, 2))==i   %direction 1
         odd(i)=odd(i)+1;
        end
  
        if BIl(o(oi,1)-1, o(oi,2)+1)==i  %direction 3
        odd(i)=odd(i)+1;
        end
  
        if BIl(o(oi,1), o(oi, 2)+1)==i   %direction 2
        even(i)=even(i)+1;
        end
  
        if BIl(o(oi,1)-1, o(oi,2))==i    %direction 4
        even(i)=even(i)+1;
        end
  
    end
    end

end