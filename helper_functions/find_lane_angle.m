function theta = find_lane_angle(lines)
max_len = 0;
for k = 1:length(lines)
   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      theta = lines(k).theta;
   end
end