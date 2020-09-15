function throttleobj = traffic_sign_response(label)
%1 is for stop sign
if label ==1 
    throttleobj = 0;
%rest are for speed limit
elseif label ==2 
    throttleobj  = 0.2; 
elseif label==3
    throttleobj = 0.4;
elseif label ==4
    throttleobj = 0.6;
elseif label ==5
    throttleobj = 0.8;
elseif label==6
    throttleobj = 1;
end
return throttleobj; 
end