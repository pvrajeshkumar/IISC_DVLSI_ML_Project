%Top Script to Train and Classify Handwritten Digits
clear all;
global slope;

%Configuration Parameters
eta = 0.02; %learning rate
epochs = 50; %Number of training epochs
mini_batch_size = 10; %Minibatch size
hidden_nodes = 20; %Number of neurons in the first hidden layer
slope = 0.05; %relu slope
%Code running mode options
do_training = 0;  %Set 1 for Training. Set 0 if only inference
use_fixp_inference = 1; %Set 1 for fixedpoint. Set 0 without fixed point inference
no_of_test_imgs = 3;  %To test Single or multiple images
load_randomized_data = 1;

disp('Starting ...');

if (load_randomized_data)
    %Load Data from .mat file
    %This data is randomized
    load('semeion_data_randomized.mat');
else
    %Load Data from .data file
    %This data is arranged in increasing order of digit. so randomize
    data = load('semeion.data');
    data = data(randperm(size(data, 1)), :); %Randomize data rows
end

%divide the dataset into training and testing
traind = 1100; % Training set
testd = 493; % Testing set
train_data = data(1:traind,:);
test_data = data((traind + (1:testd)),:);

if (do_training)  %do training??
%Training function to get weights and biases and save them
%comment out the 2 lines below when a desired test accuracy is reached and
%you want to run only inference.
[w12,w23,b12,b23] = training(train_data,traind,hidden_nodes, eta, epochs, mini_batch_size);
save('trained_params.mat','w12','w23','b12','b23');
end
%Load the saved training parameters
load('trained_params.mat','w12','w23','b12','b23');

%Check train data accuracy
if (use_fixp_inference)
    train_accuracy = inference_fixp(train_data,traind,w12,w23,b12,b23);
else
    train_accuracy = inference(train_data,traind,w12,w23,b12,b23);
end
fprintf('Train Accuracy: %f %% \n',train_accuracy);

%Check test data accuracy
if (use_fixp_inference)
    test_accuracy = inference_fixp(test_data,testd,w12,w23,b12,b23);
else
    test_accuracy = inference(test_data,testd,w12,w23,b12,b23);
end    
fprintf('Test Accuracy: %f %% \n',test_accuracy);

disp('Done!');

if ( no_of_test_imgs == 1 )
    %display a sample image
    img_num = 20;
    sample_img_vector = data(img_num,1:256);
    sample_img = reshape(sample_img_vector,[16,16]);
    imshow(sample_img.')
else
    %display test sample images (This can go for Verilog TestBench)
    test_imgs= [1, 21, 41, 61, 81, 101, 121, 141, 161, 181];
    figure
    tiledlayout(1,no_of_test_imgs)
    
    %test the images above
    for test_imgs_index = 1:no_of_test_imgs
        nexttile
        
        %Get Predicted img from the test_imgs[] 
        if (use_fixp_inference)
            test_accuracy = inference_fixp(test_data,test_imgs(test_imgs_index),w12,w23,b12,b23);
        else
            test_accuracy = inference(test_data,test_imgs(test_imgs_index),w12,w23,b12,b23);
        end   

        img_num = test_imgs(test_imgs_index);
        sample_img_vector = data(img_num,1:256);
        sample_img = reshape(sample_img_vector,[16,16]);
        imshow(sample_img.')
    end
end

