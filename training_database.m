%Returns feature vectors of the training images located in a designated
%folder. PCA is used to reduce dimensionality of the training set features.

%Returns:
%feature vectors (training)
%mean of training
%Principle component K value
%Principle component (eigen vector)
%Training data matrix
function [featureV_train, data_mean, K, evec_real, data] = training_database()
%close all;

% Loads training images from the designated folder. Each image (64x64) is converted 
% to a one dimensional vector (1x4096), and all one-dimensional images are
% put into the "data" matrix (dimension: 4096 x number_of_images)

global srcFiles;
srcFiles = dir(fullfile('D:\VIBOT\Course\Applied Math\face_detection\FaceProject\train_images\*.jpg'));
for i = 1 : length(srcFiles)
    filename = strcat('D:\VIBOT\Course\Applied Math\face_detection\FaceProject\train_images\',srcFiles(i).name);
    I = reshape(double(imread(filename)), 1, 4096);
    
    if i == 1
        data = I;
        
    else
        data = [data; I];
    end
end

%The rest of algorithm handles the transposed form of the training data
data = data'; 

%Centers all training data by subtracting the mean of features, then
%obtains covariance and its eigen vectors (principle components)
data_mean = mean (data, 2);
data_bar = data - repmat(data_mean,1, size(data, 2));

%Method 1 (slow): 4096 x 4096 covariance matrix
%cov_data = 1/(size(data, 2)-1) * data_bar * data_bar'; 
%[evec_real, eval] = eig(cov_data);

%Method 2 (fast): num of images x num of images covariance matrix
cov_data = 1/(size(data, 2)-1) * data_bar' * data_bar;
[evec, eval] = eig(cov_data);
for i = 1: size(data, 2) 
    if i == 1 
        evec_real = data * evec(:,i); 
    else
        evec_real = [evec_real, data * evec(:,i)];
    end
end

%Find K principle components such that at least 85% of the total variance
%of the training data is preserved
eval_sum = sum(diag(eval));
eval_cumsum = cumsum(diag(eval));

for j = 1:size(eval, 2)
    if eval_cumsum(j) / eval_sum > 0.85
        K = j;
        break;
    end
end

%Obtains "feature vectors" of training data by projecting the centered
%training data to eigen vector dimension (reduced dimension)

featureV_train = evec_real(:, 1:K)' * data_bar;
 
end