function [outputArg1,outputArg2,outputArg3,outputArg4] = training(data,traind,hn1)
%Train the network using backpropagation

%Training Data
images = data(1:traind,1:256);
images = images'; %Input vectors

%Training Labels
train_labels = data(1:traind,257:266);
y = train_labels'; %Output labels

%Initializing weights and biases
w12 = randn(hn1,256)*sqrt(2/256);
w23 = randn(10,hn1)*sqrt(2/hn1);
b12 = randn(hn1,1);
b23 = randn(10,1);

eta = 0.01; %learning rate

epochs = 50; %Number of training epochs

m = 10; %Minibatch size

images1 = images;   %initial value

for k = 1:epochs %Outer epoch loop
    
    batches = 1;
    
    for j = 1:traind/m 
        
        for i = batches:batches+m-1 %Loop over each minibatch
    
            %Feed forward
            a1 = images1(:,i);
            
            z2 = w12*a1 + b12;
            a2 = leaky_relu(z2);
            
            z3 = w23*a2 + b23;
            a3 = leaky_relu(z3); %Output vector
            
            % Backpropagation    
            error3 = (a3-y(:,i)).*grad_leaky_relu(z3);
            error2 = (w23'*error3).*grad_leaky_relu(z2);

            % Weight Update
            w23 = w23 - eta.*error3*a2';
            w12 = w12 - eta.*error2*a1';
            b23 = b23 - eta.*error3;
            b12 = b12 - eta.*error2;

        end

        batches = batches + m;
    
    end
    fprintf('Epochs: %d \n', k);
    [images1,y] = shuffle(images1,y); %Shuffles order of the images for next epoch
end

%Return trained weights and biases
outputArg1 = w12;
outputArg2 = w23;
outputArg3 = b12;
outputArg4 = b23;

disp('Training done!')

end

