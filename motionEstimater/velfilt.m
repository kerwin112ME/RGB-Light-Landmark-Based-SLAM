function [vx_his, vy_his, traj] = velfilt_new(accfile, gpsfile, rotm)
    %% Import file
%     [biasx, biasy, biasz,gpsbias, station] = biascalc('accelerometer_still.csv','gps_still.csv');
    acc = csvread('..\Input\test0420\accelerometer.csv',1);
%     acc = csvread(accfile,1);
    acc = acc(1:160,2:4).';
    acc(2,:) = acc(2,:);

    gps = csvread('..\Input\test0420\gps.csv',1);
    gps = gps(:,6).';%-gpsbias;
    
    tq = linspace(1,size(gps,2),size(acc,2)); % interpolation for gps
    gps = interp1(1:size(gps,2),gps,tq);
    dt = 0.05;
    t = 0:dt:dt*size(acc,2);
    %% low pass filter
    
    f0=0.4; %cut-off frequency
    w0=2*pi*f0;
    N=512;
    Fs=20; % sampling frequency
    [NUMs,DENs]=butter(2,w0,'s'); %Butterworth order 2.
    [NUMdp,DENdp] = bilinear(NUMs,DENs,Fs,f0) ;%with prewarping
    
    acc = filtfilt(NUMdp,DENdp,acc.').';

   % acclong = filtfilt(NUMdp,DENdp,acclong);
    %% Filtering
    vx_his = [0];
    vy_his = [0];
    posx = [0];
    posy = [0];
    P = [50 -5; -5 0];
    Q = eye(2);
    R = 0.5;
    acci = [];
    for i = 1:size(acc,2);
        acci(:,i) = rotm(:,:,i)*acc(:,i);
        %acci(:,i) = acc(:,i);

        [V, P] = prediction([vx_his(i);vy_his(i)], [acci(1,i);-acci(3,i)], P, Q); % prediction
        %       Update with interpolated GPS data
        [V, P, K] = measUpdate(V, P, R, gps(i)); %

        vx_his(i+1) = V(1);
        vy_his(i+1) = V(2);
        posx(i+1) = posx(i) + vx_his(i)*dt;
        posy(i+1) = posy(i) + vy_his(i)*dt;
        
    end
    %% Plotting
    figure(1);
    subplot(2,1,1);
    plot(t,vx_his)
    title('Vx');
    xlabel('time (sec)'); ylabel('Velx (m/s)');
    subplot(2,1,2);
    plot(t,vy_his)
    title('Vy');
    xlabel('time (sec)'); ylabel('Vely (m/s)');
    
    figure(2);
    subplot(2,1,1);
    plot(t,posx)
    title('Posx');
    xlabel('time (sec)'); ylabel('Posx (m)');
    subplot(2,1,2);
    plot(t,posy)
    title('Posy');
    xlabel('time (sec)'); ylabel('Posy (m)');

    traj = [posx;posy];
    
end