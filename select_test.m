%"select_test" loads all test images located in the designated
%folder. The target test image is specified as an input to this function.
%It returns a single image as specified. 

function test_img = select_test (num)
%close all;
test_images = dir(fullfile('D:\VIBOT\Course\Applied Math\face_detection\FaceProject\test_images\*.jpg'));
filename = test_images(num).name;
test_img_str = strcat('D:\VIBOT\Course\Applied Math\face_detection\FaceProject\test_images\',filename);

test_img = imread(test_img_str);
end