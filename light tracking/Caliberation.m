
clc;


Folder = '/Users/Jeffrey/Downloads/light tracking/distance caliberation photos/blue'
all_frames = dir(fullfile(Folder, '*.png'));
num_dir = numel(all_frames);

% repos_red=zeros(num_dir,3);
% repos_green=zeros(num_dir,3);
 repos_blue=zeros(num_dir,3);


k=fix(num_dir*2/5)

frames=all_frames(k).name;
FileName=fullfile(Folder, frames);

rgb = imread(FileName);
imshow(rgb);

% Choose framed to set reference hsv    
% fprintf('Select mutiple points on "Red" object, right click to stop\n');
% hsvMean_red = selectPixelsAndGetHSV(rgb, 10);
% fprintf('Select mutiple points on "Green" object, right click to stop\n');
% hsvMean_green = selectPixelsAndGetHSV(rgb, 10);
fprintf('Select mutiple points on "Blue" object, right click to stop\n');
 hsvMean_blue = selectPixelsAndGetHSV(rgb, 10);


for Index=1:num_dir

frames=all_frames(Index).name;
FileName=fullfile(Folder, frames);

rgb = imread(FileName);
imshow(rgb);
    
     
% Enhance specified hsv values in images
% enhance_red=colorDetectHSV(FileName, hsvMean_red, [0.04 0.7 0.5]);
% enhance_green=colorDetectHSV(FileName, hsvMean_green, [0.015 0.5 1.2]);
 enhance_blue=colorDetectHSV(FileName, hsvMean_blue, [0.3 0.075 0.6]);
% Area
% red_area=bwarea(enhance_red);
% green_area=bwarea(enhance_green);
 blue_area=bwarea(enhance_blue);

% Clalculate the position of the light in the image
% stats = regionprops('table',red_enhance,'Centroid',...'MajorAxisLength','MinorAxisLength')

% reg_red = regionprops('table',enhance_red,'Centroid');
% pos_red=reg_red.Centroid;
% reg_green = regionprops('table',enhance_green,'Centroid');
% pos_green=reg_green.Centroid;
 reg_blue = regionprops('table',enhance_blue,'Centroid');
 pos_blue=reg_blue.Centroid;


% repos_red(Index,:)=[ pos_red, red_area];
% repos_green(Index,:)=[ pos_green, green_area];
 repos_blue(Index,:)=[ pos_blue, blue_area];

end


a_r=repos_red(:,3);
 a_b=repos_blue(:,3);
a_g=repos_green(:,3);