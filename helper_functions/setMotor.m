function [] = setMotor(a, d1,d2,d3, d4, p1, p2, speed)
writeDigitalPin(a, d1, 1);
writeDigitalPin(a, d2, 0);
writeDigitalPin(a, d3, 1);
writeDigitalPin(a, d4, 0);
writePWMDutyCycle(a,p1, speed)
writePWMDutyCycle(a,p2, speed)
end
