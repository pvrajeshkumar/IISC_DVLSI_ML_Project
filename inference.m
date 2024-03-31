function accuracy = inference(data,testd,w12,w23,b12,b23)
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

for i = 1:testd
    
    %Feed forward
    a1 = images(:,i);

    z2 = w12*a1 + b12;
    a2 = leaky_relu(z2);

    z3 = w23*a2 + b23;
    a3 = leaky_relu(z3); %Output vector
    
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

