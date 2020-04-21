function rotm = getrotm(accfile, gyrofile, magnetfile)
    %% Read data
    
    Gyroscope = csvread(gyrofile,1);
    time = Gyroscope(:,1)/1000;
    Gyroscope = Gyroscope(:,2:4);
    Accelerometer = csvread(accfile,1);
    Accelerometer = Accelerometer(:,2:4);
%     Accelerometer(:,2) = Accelerometer(:,2) - 9.8;
    Magnetometer = csvread(magnetfile,1);
    Magnetometer = Magnetometer(:,2:4);

    %% Process sensor data through algorithm

    AHRS = MadgwickAHRS('SamplePeriod', 1/20, 'Beta', 0.1);
    % AHRS = MahonyAHRS('SamplePeriod', 1/256, 'Kp', 0.5);

    quaternion = zeros(length(time), 4);
    for t = 1:length(time)
    %     AHRS.Update(Gyroscope(t,:) * (pi/180), Accelerometer(t,:), Magnetometer(t,:));	% gyroscope units must be radians
    AHRS.Update(Gyroscope(t,:), Accelerometer(t,:), Magnetometer(t,:));	% gyroscope units must be radians
    quaternion(t, :) = AHRS.Quaternion;
    end
    %% get rotation matrix
    
    rotm = quatern2rotMat(quaternion);
    
end
