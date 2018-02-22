%This function takes a test image. It then assesses the test's feature vector. 
%Feature vector of test is compared with those of the training sets.
%The function returns the top three best matches from the training. 
%Other inputs, including mean of training data, feature vectors of training
%data, principle components (eigen vectors from training), vectorized
%training dataset and K-principle level are used to compute the Euclidean
%distance of the test from all trainings.

%It returns the top three matches' names and displays the best match.
function [match_image, match1_name, match2_name, match3_name] = face_recog(test_img, train_mean, featureV_train, evec_real, K, train_data)

%Vectorizes the test image and centers it by subtracting mean obtained from
%training.
test_img = reshape(double(test_img), 1, 4096);
test_img = test_img';
test_img_centered = test_img - train_mean;

%Projects the centered_test vector to the eigen vector dimension of the
%training sets. The result is the feature vector of the test.
featureV_test = evec_real(:, 1:K)' * test_img_centered;


%Euclidean distance is computed between the test's feature vector and that of each train
%image. Smallest Euclidean distance corresponds to best match. 
for N = 1:size(featureV_train, 2)
    diff = featureV_test(:,1) - featureV_train(:,N);
    disimilar = diff' * diff;
    
    distance_to_train(1, N) = disimilar;
end
% [M,min_index] = min(distance_to_train(1,:));
[matches, min_index] = sort(distance_to_train(1,:));

global match1_im;
global match2_im;
global match3_im;
match1_im = reshape(train_data(:,min_index(1,1)), 64, 64); 
match2_im = reshape(train_data(:,min_index(1,2)), 64, 64); 
match3_im = reshape(train_data(:,min_index(1,3)), 64, 64); 

%subplot(2,2,2), imshow(match1_im, []);title('1st Match');
%subplot(2,2,3), imshow(match2_im, []);title('2nd Match');
%subplot(2,2,4), imshow(match3_im, []);title('3rd Match');

match_image = match1_im;

global srcFiles;
match1_name = srcFiles(min_index(1,1)).name;
match2_name = srcFiles(min_index(1,2)).name;
match3_name = srcFiles(min_index(1,3)).name;

end