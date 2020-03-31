function posBel = motionEstimate(accFile, gpsFile)
    %% data import
    % accFile = fullfile('Input','accelerometer.csv');
    % gpsFile = fullfile('Input','gps.csv');
    acc = csvread(accFile,1);
    gps = csvread(gpsFile,1);

    acc = -acc(:,2); % x-dir accelerometer
    gpsSpeed = gps(:,6); % speed

    accT = 0.05; % accelerometer sample period
    gpsT = 1; % gps sample period

    %% low pass filter
    [bl,al] = butter(12,0.1,'low');
    acc = filtfilt(bl,al,acc);

    %% main
    posBel = 0; % position believe
    velBel = 0; % velocity believe

    accVar = 1.5; % acceleromter variance
    GPSVar = 0.05; % GPS variance
    for ii = 1:size(acc,1)
        velBel = vertcat(velBel, velBel(end) + acc(ii)*accT);
        if(mod(ii,20) == 0)
            gpsvel = gpsSpeed(ii/20);
            combinedSpeed = (velBel(end)/accVar + gpsvel/GPSVar)/(1/accVar + 1/GPSVar); % combine the gaussian 
            velBel(end) = combinedSpeed;
        end
        posBel = vertcat(posBel, posBel(end)+velBel(end)*accT);
    end

    t = 0:accT:accT*size(acc,1);
    plot(t,posBel)
    title('position predict');
    xlabel('time (sec)'); ylabel('displacement (m)');
    
end
  