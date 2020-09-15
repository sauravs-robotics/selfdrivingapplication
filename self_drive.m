%% connect rasberry pi webcam and start video feed
 clc; clear
 r  =  raspberrypi('192.168.86.192','pi','ras');
  %camera right in front of forward wheel used to 
  %find lane lane for steering
 steercam = cameraboard(r, ''); 
 %cam for object detection 
 objcam = webcam(r); 
 
%% Initialize Arduino motors
 a = arduino;
lin_v = 3;
% Motor 1 connections
enA = 'D5';
in1 = 'D24';
in2 = 'D26';
% Motor 2 connections
enB = 'D6';
in3 = 'D28';
in4 = 'D30';
% Motor 3 connections
enC = 'D8';
in5 = 'D34';
in6 = 'D36';
% Motor 4 Connections
enD = 'D9';
in7 = 'D40';
in8 = 'D38';
initMotor(a, in1,in2,in3,in4,in5,in6,in7,in8); 
%% 1d Lookup Info for Motor
r_wheel = 6.2/100; % m
PWM = linspace(0,1,16); PWMplot = PWM(5:16);
RPM = [0 0 0 0 110 200 280 360 417 447 477 500 523 533.4 560 587]; RPMplot = RPM(5:16);
vel = RPM.*pi*r_wheel*2*(1/60); %m/s
axle_length = 16/100; %m

%% Object Detection 

%pretrained network from keras loaded into matlab
modelfile = 'objdetection.h5';
% 1 is stop sign, 2 is yield
classecats = {'1', '2', '3', '4','5','6','7','8','9','10'}
net = importKerasNetwork(modelfile,'Classes',classcats);



%% 1D Loopup Table from lane angle to steering angle
picture_angle = [];
steering_angle = [];
for ii = 1:100
    img = snapshot(mycam);
    objimg = snapshot(objcam); 
    label = classify(net,objimg);
    %response of car based on if traffic sign detected
    %ie if speed limit detected lower total linear velocity 
    sign_throttle = traffic_sign_response(label); 
    %decrease total picture size so less calculations
    %used 
    img = img(0:end/2, (end/3):((2*end)/3)); 
    im = rgb2gray(img);
    g = imgaussfilt(im,0.75);
    %find edges using sobel filter
    ee = edge(g,'sobel');
    %convert edges to angle of lane line
    [H,theta,rho] = hough(ee);
    P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(ee,theta,rho,P,'FillGap',5,'MinLength',7);
    lane_angle = find_lane_angle(lines);
    ang_vel = camera2steering(lane_angle);
    %converting line angle to RPM commands for each
    %left (2x) and right (2x) wheels 
    [throttle_l,throttle_r] = convert_vel(ang_vel,lin_v, axle_length,r_wheel);
    TLarray(ii) = throttle_l * throttleobj; 
    TRarray(ii) = throttle_r * throttleobj;
    setMotor(a, in1,in2, in3, in4, enA, enB, throttle_l)
    setMotor(a, in5,in6, in7, in8, enC, enD, throttle_r)
    
end
