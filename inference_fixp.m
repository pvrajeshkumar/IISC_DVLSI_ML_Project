function accuracy = inference_fp(data,testd,w12,w23,b12,b23)
%Inference on test data

%Test Data
images = data(1:testd,1:256);
images = images';

%Test Labels
test_labels = data(1:testd,257:266);
labels_ts = zeros(testd,1);

%Converting one-hot labels to integer for comparison
for i = 1:testd
    [maxv,index] = max(test_labels(i,:));
    labels_ts(i) = index - 1;
end

success = 0;

    [w12_fix_float, w12_fix_int, err] = fixedpoint(w12, 16,8,1);
    [w23_fix_float, w23_fix_int, err] = fixedpoint(w23, 16,8,1);
    [b12_fix_float, b12_fix_int, err] = fixedpoint(b12, 16,8,1);
    [b23_fix_float, b23_fix_int, err] = fixedpoint(b23, 16,8,1);


%Some points for Fixed point calculations
% Q point calculations go like this
% Q8 + Q8 = Q8
% Q16 + Q16 = Q16
% Q32 + Q32 = Q32
% Q8 * Q8 = Q16
% Q16 * Q16 = Q32
% Q32 * Q32 = Q64
% Fractional parts calculations with below examples
% Q16.8 * Q1.0 = Q17.8
% Q17.8 + Q16.8 = Q17.8
% Q11.8 * Q17.8 = Q28.16
%So, do below MUL & ADD accordingly

for i = 1:testd
    
    %Feed forward
    a1 = images(:,i);

    %Convert below to Fixed Point Representation
    % z2 = w12_fix_int*a1 + b12;
    % a2 = leaky_relu(z2);
    z2_interim = w12_fix_int * a1; % (Q16.8 * Q1.0 = Q17.8). Interim var for fixed point conv
    z2 = z2_interim + b12_fix_int; % Q17.8 + Q16.8 = Q17.8
    %Apply RELU with Fixed point representation
    a2 = leaky_relu_fixp(z2);  % Q11.8 * Q17.8 = Q28.16

    %Convert below to Fixed Point Representation
    % z3 = w23*a2 + b23;
    % a3 = leaky_relu(z3); %Output vector
    z3_interim = w23_fix_int * a2; % (Q16.8 * Q28.16 = Q44.24). Interim var for fixed point conv
    %b23_fix_int_inz3_interim Q Point
    b23_fix_int_interim = b23_fix_int * 2^16; %To convert to Q.24 format
    z3 = z3_interim + b23_fix_int_interim;  % Q44.24 + Q32.24 = Q44.24
    %Apply RELU with Fixed point representation
    a3 = leaky_relu_fixp(z3);

    %Get the index of the maximum output
    [maxv1,index1] = max(a3);
    num = index1-1; %subtract the index by 1 as matlab indices are 1-10

    %compare with integer label
    if labels_ts(i) == num
        success = success + 1;
    end    

end

accuracy = success/testd*100;

end

