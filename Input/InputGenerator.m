Ut = zeros(2,200);
t = 1;
while (t <= 200)
    if t <= 50
        Ut(:,t) = [-0.05; 0.05];
    elseif t >50 && t <= 100
        Ut(:,t) = [0.05; 0.05];
    elseif t>100 && t <= 150
        Ut(:,t) = [0.05; -0.05];
    else
        Ut(:,t) = [-0.05; -0.05];
    end
    t = t + 1;
end

x0 = 2.5; y0 = 0;
pos = zeros(2,201);
pos(:,1) = [x0; y0];
for t = 2:201
    pos(:,t) = pos(:,t-1) + Ut(:,t-1);
end
pos = pos(:,2:end);

lm = [2 3 4; 3 3 3];
Zt = zeros(3,200);
for t = 1:200
    Zt(1,t) = sqrt((pos(1,t)-2)^2+(pos(2,t)-3)^2);
    Zt(2,t) = sqrt((pos(1,t)-3)^2+(pos(2,t)-3)^2);
    Zt(3,t) = sqrt((pos(1,t)-4)^2+(pos(2,t)-3)^2);
end









    
    