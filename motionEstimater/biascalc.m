
function [biasx, biasy, biasz,gpsbias, station] = biascalc(accfile, gpsfile)
    acc = csvread(accfile,1);
    gps = csvread(gpsfile,1);
    ax = acc(:,2);
    ay = acc(:,3);
    az = acc(:,4);
    gps = gps(:,6);
    gpsbias = mean(gps);
    station  = sqrt(ax.^2 + ay.^2 + az.^2);
%     figure(1);
%     plot(acc(:,1)./1000,[ax,ay,az,station])
     station = mean(station);
%     figure(2);
    ax = ax.*(9.82/station);
    ay = ay.*(9.82/station);
    az = az.*(9.82/station);
%     plot(acc(:,1)./1000,[ax,ay,az])
    biasx = sum(ax)./size(acc,1);
    biasy = (sum(ay))/size(acc,1)-station;
    biasz = sum(az)./size(acc,1);
end
% random walk
% ak1 = ak + w; % w = random walk (0,w)
% y = ak 