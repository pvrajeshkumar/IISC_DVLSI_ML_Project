function fr = leaky_relu_fixp(x)
global slope;
global totalbits;
global fractionbits;

    f = zeros(length(x),1);
    %Convert all integers params into Float
    [slope_fix_float, slope_fix_int, err] = fixedpoint(slope, totalbits,fractionbits,1);
    [mul_1_to_fix_float, mul_1_to_fix_int, err] = fixedpoint(1, totalbits,fractionbits,1);
    
    for i = 1:length(x)
        if x(i)>=0
            f(i) = mul_1_to_fix_int*x(i); %Result is i.e. Q16 Q8*Q8
        else
            f(i) = slope_fix_int*x(i);  %Result is Q16  i.e. Q16 Q8*Q8
        end
    end
    fr = f;
end