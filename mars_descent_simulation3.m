%火星�?陆器下降模拟
%此代码模拟�?�设置动画�?�分析冲击力并保存视频文�?
%火星�?陆器的降落伞降落。在动画中，蓝色表示降落伞展�?，绿色代表撞击生存，红色代表碰撞事故�?
clear; close all;
% �?陆器和行星参数设�?
L1= 4000; % 动画中着陆器的尺寸（不影响计算）, m
g= 3.711; % 重力加�?�度, m/s^2
A= 12.56; % 立方体卫星的投影面积, m^2
Cd= 1.05; % 阻力系数（立方体�?1.05�?
m= 1285; % �?陆器质量, kg
rho= 0.0044; % 大气初始密度, kg/m^3
% 初始阻力, N

mars_mass= 6.39*10^23; % 火星质量, kg
G= 6.67*10^(-11); % 引力常数
mars_radius= 3.39 * 10^6; % 火星半径, m
para_altitude= 11600;% 降落伞展�?高度, m
power_altitude=1500; % 动力下降高度，m

% 初始条件
y0= 125000; % 初始高度, m
v0= 956;% 初始垂直速度, m/s
v1=4694.61;%初始水平速度, m/s
pressure1= 0.0405
temp1= 136.83

yAcc= 3.7; % 初始加�?�度, m/s^2
yVel= v0; % 垂直速度, m/s
xVel=v1; %水平速度，m/s
Vel=sqrt(xVel.^2+yVel.^2); %合�?�度，m/s
y= y0; % 海拔高度, m
pressure=pressure1;
temp=temp1;


ydata= [];
xdata= [];
yVeldata= [];
Veldata=[];
xVeldata= [];
yAccdata= [];
xAccdata= [];
time= [];
density= [];
gravity= [];
dragdata= [];
dragxdata= [];
dragydata= [];

frame_size= y0 + L1; % 动画的外部帧

% 时间设置
duration= 890; % 模拟持续时间, s
delta_t= 0.01; % 模拟的增量时�?, s
time_steps= round(duration/delta_t); % 时间步数
frameRate= 2; % 动画帧�?�率，帧/s
framePeriod= 1./frameRate; % �?帧周�?, s

% Draw initial figure
fig= figure(1);
axs=axes('Parent',fig);

%打开电影文件
vidObj= VideoWriter('mars_descent_simulation.avi');
vidObj.FrameRate= frameRate;
open(vidObj);

% 牵引�?陆器
cubesat= rectangle('Position', [0, -(frame_size - 1)*L1, L1, L1], 'Curvature', [0,0]);
border= line([-frame_size/2, -frame_size/2, frame_size/2, frame_size/2, -frame_size/2],...
    [0, frame_size, frame_size, 0, 0]);
axis(axs, [-frame_size/2, frame_size/2, 0, frame_size]);
axis(axs, 'square');
axis(axs, 'on'); % 打开轴�??
set(axs,'XTick',[]); % 关闭x�?
ylabel('Altitude (m)');
pressure_change= line([-frame_size, frame_size], [7000,7000], 'Color', 'green'); ...
    pressure_change= line([-frame_size, frame_size], [11600,11600], 'Color', 'red'); ...
    pressure_change= line([-frame_size, frame_size], [1500,1500], 'Color', 'red'); 
    % 在大气密度变化的位置绘制�?条线

% 视频生成
for i= 1:time_steps
    t= (i-1)*delta_t;
    
    % 根据海拔高度计算重力加�?�度
    g= G*mars_mass/(y + mars_radius)^2;
    
    if y<=0 % 落地时停�?
        break;
    end
    
    if y>para_altitude
        set(cubesat, 'Position', [-L1/2, y, L1, L1], 'FaceColor', 'black');
        Cd= 1.05; % �?陆器的阻力系�?
        A= 12.56; % 仅着陆器的表面积
    end 
    if (power_altitude<y)&&(y<=para_altitude)
        set(cubesat, 'Position', [-L1/2, y, L1, L1], 'FaceColor', 'blue');
        Cd= 0.43; % 降落伞阻力系�?
        A= 200; % 降落伞的表面�?, m^2
    end  
    
    % 根据海拔高度计算大气密度
    if(80000<y)&&(y<125000)
        temp=136.83;
        pressure=0.0405;
    end
    if(20000<y)&&(y<80000)
        temp=202.0;
        pressure=262.78;
    end
    if (7000<y)&&(y<20000)
        temp=249.5- 0.00222*y;
        pressure=700*exp(-0.00009*y);
    end
    if y<7000
        temp=241.0 - 0.000998*y;
        pressure= 700*exp(-0.00009*y);
    end
    rho= pressure./(188.9*(temp));
    
    % 重置TIG视频数据并获取位�?/速度
    if (mod(t,framePeriod) == 0)
        currFrame= getframe;
        writeVideo(vidObj, currFrame);
        time= [time t];
        ydata= [ydata y];
        yVeldata= [yVeldata yVel];
        yAccdata= [yAccdata yAcc];
        density= [density rho];
        gravity= [gravity g];
    end
    Vel=sqrt(xVel.^2+yVel.^2);    
    drag=A/2*Cd*rho*Vel^2;%阻力，N
    dragx=drag*xVel./Vel;% 水平方向的阻�?, N
    dragy=drag*yVel./Vel;% 竖直方向的阻�?, N
    yAcc= (dragy - m*g)./m; % 考虑垂直阻力的加速度, m/s^2
    xAcc=(dragx)./m;% 考虑水平阻力的加速度, m/s^2
    yVel= yVel - yAcc*delta_t; % 考虑垂直阻力的�?�度, m/s
    xVel= xVel - xAcc*delta_t; % 考虑水平阻力的�?�度, m/s
    y= y - yVel*delta_t; % 考虑阻力的高�?, m
end

% 影响计算
s= 0.001; % 碰撞后减速距�?, m
impactForce= 1/2*m*yVel^2/s; % 冲击�?, N
impactStress= impactForce/0.01; % 冲击应力, Pa

if impactStress<276*10^6
    set(cubesat, 'Position', [-L1/2, y, L1, L1], 'FaceColor', 'green');
    disp('Cubesat survived the land.');
end
if impactStress>=276*10^6
    set(cubesat, 'Position', [-L1/2, y, L1, L1], 'FaceColor', 'red');
    disp('Cubesat did not survive the land.');
end

elapsedTime= t;
disp('The descent and landing process took (in seconds):');
disp(elapsedTime);

%关闭电影文件
close(vidObj);

% 绘图时间与高�?
figure(2);
plot(time, ydata);
xlabel('Time (s)');
ylabel('Altitude (m)');
line([0, t], [7000,7000], 'Color', 'red');

% 绘图时间与�?�度
figure(3);
plot(time, yVeldata);
xlabel('Time (s)');
ylabel('Velocity (m/s)');

% 绘图时间与加速度
figure(4)
plot(time, yAccdata);
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');

% 绘图时间与大气密�?
figure(5)
plot(time, density);
xlabel('Time (s)');
ylabel('Air density (kg/m^3)');

% 绘图时间与重�?
figure(6)
plot(time, gravity);
xlabel('Time (s)');
ylabel('Gravity Acceleration (m/s^2)');