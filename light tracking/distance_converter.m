%% pre-processing
video = 'test0420.mp4';
vid=video;

% Read the video
videoObject = VideoReader(vid);

% Determine how many frames in the video
numberOfFrames = videoObject.NumFrames;

% Create empty array to store position data
repos_red=zeros(numberOfFrames,5);
repos_green=zeros(numberOfFrames,5);
repos_blue=zeros(numberOfFrames,5);

% Extract frames from video
Folder = 'C:\Users\Kerwin\Desktop\課程講義\碩一\Robotic Perceptions\Light Intensity Landmark-Based SLAM\light tracking\Extracted_Frames';


for iFrame = 1:numberOfFrames
  frames = read(videoObject, iFrame);
  imwrite(frames, fullfile(Folder, sprintf('%06d.png', iFrame)));
end 

% Image proccessing HSV
% Direct all frames
all_frames = dir(fullfile(Folder, '*.png'));


%% Cut frames

for Index = 1:length(all_frames)
    frames=all_frames(Index).name;
    
    % read the frame
    Folder = 'C:\Users\Kerwin\Desktop\課程講義\碩一\Robotic Perceptions\Light Intensity Landmark-Based SLAM\light tracking\Extracted_Frames';
    FileName = fullfile(Folder, frames);
    %fprintf(1, 'Now reading %s\n', FileName);
    rgb = imread(FileName);
    rgb = rgb(1:500,:,:); % trim the watermark

     % Choose first framed to set reference hsv
%      if Index==1
%     
%          % Select multiple points to calculate the average HSV values from an image first frame in video
%          % function hsvMean = selectPixelsAndGetHSV(RGB, Area)
%          % Area is the size of reference square 
%          Area=10
%          
%          fprintf('Select mutiple points on "Red" object, right click to stop\n');
%          hsvMean_red = selectPixelsAndGetHSV(rgb, Area);
%          fprintf('Select mutiple points on "Green" object, right click to stop\n');
%          hsvMean_green = selectPixelsAndGetHSV(rgb, Area);
%          fprintf('Select mutiple points on "Blue" object, right click to stop\n');
%          hsvMean_blue = selectPixelsAndGetHSV(rgb, Area);
%      else 
%      end
     
    %load('enhanced_value.mat');
    % Enhance specified hsv values in images
    enhance_red=(rgb(:,:,1) > 180 & rgb(:,:,2) < 100 & rgb(:,:,3) < 100);
    enhance_green=(rgb(:,:,2) > 200 & rgb(:,:,1) < 100);
    enhance_blue=(rgb(:,:,3) > 200 & rgb(:,:,1) < 100);
    
    bw = (enhance_red | enhance_green | enhance_blue); % binary image of three lights

    % Clalculate the position of the light in the image
    % stats = regionprops('table',red_enhance,'Centroid',...'MajorAxisLength','MinorAxisLength')

    stats = regionprops('table',bw,'Centroid');
    centers = stats.Centroid; % centers of the three lights

    % position: G -> B -> R
    cutGB = (centers(1,1) + centers(2,1)) / 2.0;
    cutBR = (centers(2,1) + centers(3,1)) / 2.0;

    Gimg = rgb(:,1:cutGB,:);
    Bimg = rgb(:,cutGB:cutBR,:);
    Rimg = rgb(:,cutBR:end,:);
    
    Folder = 'C:\Users\Kerwin\Desktop\課程講義\碩一\Robotic Perceptions\Light Intensity Landmark-Based SLAM\light tracking\Extracted_Frames\Seperated_Frames';
    imwrite(Rimg, fullfile(Folder, sprintf('%06dr.png', Index)));
    imwrite(Gimg, fullfile(Folder, sprintf('%06dg.png', Index)));
    imwrite(Bimg, fullfile(Folder, sprintf('%06db.png', Index)));

end


%% Computing the seperated frames
Folder = 'C:\Users\Kerwin\Desktop\課程講義\碩一\Robotic Perceptions\Light Intensity Landmark-Based SLAM\light tracking\Extracted_Frames\Seperated_Frames';
all_frames = dir(fullfile(Folder, '*.png'));

for Index = 1:length(all_frames)
    frames=all_frames(Index).name;
    
    % read the frame
    Folder = 'C:\Users\Kerwin\Desktop\課程講義\碩一\Robotic Perceptions\Light Intensity Landmark-Based SLAM\light tracking\Extracted_Frames\Seperated_Frames';
    FileName = fullfile(Folder, frames);
    rgb = imread(FileName);
    
    if frames(7) == 'r'
        enhance_red= (rgb(:,:,1) > 100);
        red_area=bwarea(enhance_red);
        
        reg_red = regionprops('table',enhance_red,'Centroid','MajorAxisLength');
        [~ , pos] = max(reg_red.MajorAxisLength);
        pos_red = reg_red.Centroid(pos,:);
        if isempty(pos_red)
            pos_red= repos_red(str2num(frames(1:6))-1,1:2);
        end
        
        a_r =470.2;
        b_r =-0.004413;
        c_r =233.7;
        d_r =-0.0002989;

        red_d=a_r*exp(b_r*red_area)+c_r*exp(d_r*red_area);
        
        Rrgb = double([rgb(round(pos_red(2)),round(pos_red(1)),1),...
            rgb(round(pos_red(2)),round(pos_red(1)),2),...
            rgb(round(pos_red(2)),round(pos_red(1)),3)]);
        Rhsl = rgb2hsl(Rrgb);
        
        repos_red(str2num(frames(1:6)),:)=[ pos_red, red_area, red_d, Rhsl(3)*100];
        
    elseif frames(7) == 'g'
        enhance_green = (rgb(:,:,2) > 100);
        
        green_area=bwarea(enhance_green);
        
        reg_green = regionprops('table',enhance_green,'Centroid','MajorAxisLength');
        [~ , pos] = max(reg_green.MajorAxisLength);
        pos_green = reg_green.Centroid(pos,:);
        if isempty(pos_green)
            pos_green= repos_green(str2num(frames(1:6))-1,1:2);
        end
        
        a_g =463.3;
        b_g =-0.004227;
        c_g =205.7;
        d_g =-0.0003388;

        green_d=a_g*exp(b_g*green_area)+c_g*exp(d_g*green_area);
        
        Grgb = double([rgb(round(pos_green(2)),round(pos_green(1)),1),...
            rgb(round(pos_green(2)),round(pos_green(1)),2),...
            rgb(round(pos_green(2)),round(pos_green(1)),3)]);
        Ghsl = rgb2hsl(Grgb);
        
        repos_green(str2num(frames(1:6)),:) = [pos_green, green_area, green_d, Ghsl(3)*100];
        
    else
        enhance_blue = (rgb(:,:,3) > 100);
        
        blue_area=bwarea(enhance_blue);
        
        reg_blue = regionprops('table',enhance_blue,'Centroid','MajorAxisLength');
        [~ , pos] = max(reg_blue.MajorAxisLength);
        pos_blue = reg_blue.Centroid(pos,:);
        if isempty(pos_blue)
            pos_blue= repos_blue(str2num(frames(1:6))-1,1:2);
        end

        a_b =523.6;
        b_b =-0.00813;
        c_b =184.7;
        d_b =-0.0004546;

        blue_d=a_b*exp(b_b*blue_area)+c_b*exp(d_b*blue_area);
        
        Brgb = double([rgb(round(pos_blue(2)),round(pos_blue(1)),1),...
            rgb(round(pos_blue(2)),round(pos_blue(1)),2),...
            rgb(round(pos_blue(2)),round(pos_blue(1)),3)]);
 
        Bhsl = rgb2hsl(Brgb);
      
        repos_blue(str2num(frames(1:6)),:) = [pos_blue, blue_area, blue_d, Bhsl(3)*100];
        
    end
 
end

%% low pass filter
f0=0.2; %cut-off frequency
w0=2*pi*f0;
N=512;
Fs=20; % sampling frequency
[NUMs,DENs]=butter(2,w0,'s'); %Butterworth order 2.
[NUMdp,DENdp] = bilinear(NUMs,DENs,Fs,f0) ;%with prewarping

rgb_distance = [repos_red(:,4)'-50 ; repos_green(:,4)'-50 ; repos_blue(:,4)'+80]./100;
rgb_distance = filtfilt(NUMdp,DENdp,rgb_distance.').';

fps = 24;
dt = 1.0/fps;
t = 0:dt:dt*(size(rgb_distance,2)-1);

tq = 0:0.05:7.95;
rgb_d(1,:) = interp1(t,rgb_distance(1,:),tq);
rgb_d(2,:) = interp1(t,rgb_distance(2,:),tq);
rgb_d(3,:) = interp1(t,rgb_distance(3,:),tq);

plot(tq,rgb_d(1,:),'r');
hold on;
plot(tq,rgb_d(2,:),'g');
plot(tq,rgb_d(3,:),'b');

