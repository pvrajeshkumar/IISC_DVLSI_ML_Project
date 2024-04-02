function [outputfixedfloat , outputargfixedinteger ,err] = fixedpoint(inputArg1,totalbits , fractionbits,action)
%FIXEDPOINT Summary of this function goes here
%   Detailed explanation goes here
err = 0;
if(totalbits>=(fractionbits+1))
 integerbits = totalbits - fractionbits -1 ; %for sign
 inputArgInteger(find(inputArg1<0)) =  ceil(inputArg1(find(inputArg1<0))); %change it to ceil if required ,but in fpga everything is floor
 inputArgInteger(find(inputArg1>=0)) =  floor(inputArg1(find(inputArg1>=0)));
 inputArgInteger = reshape(inputArgInteger,size(inputArg1));
 inputArgFraction = inputArg1 - inputArgInteger;
 inputArgInteger(find((abs(inputArgInteger))>(2^integerbits-1))) = 0;
 outputargfixedinteger = inputArgInteger*(2^fractionbits) + floor(inputArgFraction*(2^fractionbits));
 inputarg1fixedfloat = outputargfixedinteger/(2^fractionbits);
 
else
    outputfixedfloat = 0;
    outputargfixedinteger = 0;
    inputarg1fixedfloat=0;
    err = bitor(err,0x01);
end

%%%% check condition %%%
if(~isequal(ceil(inputArg1),ceil(inputarg1fixedfloat)) && ~isequal(floor(inputArg1),floor(inputarg1fixedfloat)))
    err = bitor(err,0x02);
 %   x = find(ceil(inputArg1)~=ceil(inputarg1fixedfloat));
 %   x1 = find(floor(inputArg1)~=floor(inputarg1fixedfloat));
end 

if action == 1
    outputfixedfloat=inputarg1fixedfloat;
else
    outputfixedfloat=  inputArg1;
end
