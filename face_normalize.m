% This .mat file contains the normalization portion of the PCA face
% detection project. It outputs the transformed face images (64 x 64 grayscale)
% where features of each face is transformed closely to the predetermined
% locations. The face recognition algorithm can directly read the
% transformed images obtained here. Hence, the normalization code is NOT
% implemented into the User Interface code. 
close all;
clear all;

% feature_cord contains all features' x and y coordinates of all faces provided in the excel file.
% name lists the name of the corresponding face ("string" person's name)
% [a, b], a and b are x and y coordinates respectively
[feature_cord,name,raw]  = xlsread('Dataset_Face_Recognition.xlsx');
feature1 = [1, 2]; % left eye
feature2 = [3, 4]; % right eye
feature3 = [5, 6]; % nose
feature4 = [7, 8]; % mouth (left end)
feature5 = [9, 10]; % mouth (right end)

% Initialize F_bar (average locations of features) with the feature locations of the first set of features
% (top row of the excel data)
F_bar = [feature_cord(1, feature1);
         feature_cord(1, feature2);
         feature_cord(1, feature3);
         feature_cord(1, feature4);
         feature_cord(1, feature5)];

% Predetermined feature locations (transformation destinations)     
f_projection = [13 20; 50 20; 34 34; 16 50; 48 50];

% Append a column of ones ([1;1;1;1;1]) to F_i (featire locations of each face) 
for i = 1 : size (feature_cord,1)
    if i == 1
        img = [feature_cord(i, feature1);feature_cord(i, feature2);feature_cord(i, feature3);feature_cord(i, feature4);feature_cord(i, feature5)];
        F_i = [img(:,:,i),[1;1;1;1;1]];
    else 
        img(:,:,i) = [feature_cord(i, feature1);feature_cord(i, feature2);feature_cord(i, feature3);feature_cord(i, feature4);feature_cord(i, feature5)];
        F_i(:,:,i) = [img(:,:,i),[1;1;1;1;1]];
    end   
end

iteration = 0;

% Solve for F_bar iteratively. If F_bar converges, find the affine
% transformations that will map F_i of each face to the final F_bar
% Number of loops is used as the termination condition
while iteration < 10
    prev_F_bar = F_bar;
    F_bar = [F_bar [1;1;1;1;1]]; 
    x = F_bar \ f_projection;
    F_bar = F_bar * x;
    total = 0;
    for i = 1: size (feature_cord,1)
        if i == 1
            x = F_i(:,:,i) \ F_bar;
        else
            x(:,:,i) = F_i(:,:,i) \ F_bar;
        end
        
        total = total + F_i(:,:,i) * x (:,:,i);
    end
    
    % F_bar is updated by the average of F_i
    F_bar = total ./ size (feature_cord,1);
    
    diff_F_bar = sum(sum((prev_F_bar - F_bar).^2))/10;
    iteration = iteration + 1;
end

% x contains the affine transformations that map the features of every face
% to predetermined locations (x is updated using the final F_bar)
for i = 1: size (feature_cord,1)
        if i == 1
            x = F_i(:,:,i) \ F_bar;
        else
            x(:,:,i) = F_i(:,:,i) \ F_bar;
        end
end

% Read original face images from the specified directory. The directory
% needs to be changed according to different computers
% srcFiles is the struct that contains all loaded images
srcFiles = dir(fullfile('D:\VIBOT\Course\Applied Math\face_detection\FaceProject\faces_resized\*.jpg')); 
for i = 1 : length(srcFiles)
    filename = strcat('D:\VIBOT\Course\Applied Math\face_detection\FaceProject\faces_resized\',srcFiles(i).name);
    I = double(rgb2gray(imread(filename)));
    if i == 1
        face_im = I;
    else
        face_im(:,:,i) = I;
    end
end

% MatLAB is case-sensitive when reading images. Thus, the image order is 
%different from that of the excel feature list. 
% match_table is used to find the right feature data corresponding to each
% image read by MatLAB
match_table = zeros (1, length(srcFiles)); 
for i = 1 : length(srcFiles)
    face_name_str = srcFiles(i).name;
    face_name_str = face_name_str(1:end-4); % get rid of '.jpg' in filename
    
    % feature_cord coresponds to pure numeric part of the excel sheet
    % 'j' starts at 2 because the first row of the excel is text
    for j = 2 : size (feature_cord,1)+1 
        tf = strcmp(face_name_str,name (j,1)); %find match between image's name and the name in excel
        if tf ==1
           match_table(1, i) = j-1; %If a match is found, update match_table's image index with the matching row in the excel
        end
    end
end

% Apply affine transformations to every "image" using backward mapping. 
% Use match_table to find the paired transformations for every image
% Save the transformed images to the designated folder
for test_num = 1:length(srcFiles)
    if match_table(test_num) ~= 0
        tform = [x(:,:,match_table(test_num)), [0;0;1]];
        tform = maketform('affine',tform);
        im1_t = imtransform(face_im(:,:,test_num),tform, 'bilinear');
        
        out = zeros (64, 64);
        for i = 1:64
            for j = 1:64
                [in_index_x,in_index_y] = tforminv(tform,i,j);
                if in_index_x < 320.4 && in_index_x > 0.5 && in_index_y < 320.4 && in_index_y > 0.5
                    out (j, i) = face_im(round (in_index_y), round (in_index_x), test_num);
                end
            end
        end
        
        face_name_str = srcFiles(test_num).name;
        face_name_str = face_name_str(1:end-4);
        filename = strcat(face_name_str, 'N.jpg');
        filename = strcat('D:\VIBOT\Course\Applied Math\face_detection\faces_normalized\',filename);
         imwrite(uint8(out),filename);
    end
end
