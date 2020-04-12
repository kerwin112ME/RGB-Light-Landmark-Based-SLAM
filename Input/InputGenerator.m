Ut = zeros(2,200);
t = 1;
for t = 1:200
    xsign = -0.5 + rand;
    xsign = xsign / abs(xsign);
    ysign = -0.5 + rand;
    ysign = ysign / abs(ysign);
    
    Ut(:,t) = [xsign*(0.8*0.15*rand + 0.8*0.1); ysign*(0.8*0.15*rand + 0.8*0.1)];
end

x0 = 3; y0 = 3;
pos = zeros(2,201);
pos(:,1) = [x0; y0];
for t = 2:201
    pos(:,t) = pos(:,t-1) + Ut(:,t-1);
end
pos = pos(:,2:end);

lm = [2 3 4; 3 3 3];
Zt = zeros(3,200);
for t = 1:200
    Zt(1,t) = sqrt((pos(1,t)-2)^2+(pos(2,t)-3)^2) + (rand*0.1-0.05);
    Zt(2,t) = sqrt((pos(1,t)-3)^2+(pos(2,t)-3)^2) + (rand*0.1-0.05);
    Zt(3,t) = sqrt((pos(1,t)-4)^2+(pos(2,t)-3)^2) + (rand*0.1-0.05);
end

plot(pos(1,:), pos(2,:))
axis([0 5 0 5])







    
    