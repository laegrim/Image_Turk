function [matches,cnt] = matchObjectName(S , objectName)
  %
  cnt = 0;
  matches = struct([]);
%   S
  for i = 1:length(S)
%     S(i).image_uid
%     image_uid
%     fprintf('%s : %s\n',S(i).image_uid,image_uid)
    
    if strcmp(S(i).objectName,objectName)
%     if S(i).image_uid == image_uid
      
      cnt = cnt + 1;
      
      cellfieldnames = fieldnames(S(i));
      for j = 1:length(cellfieldnames)
        matches(cnt).(cellfieldnames{j}) = S(i).(cellfieldnames{j});
      end
      
    end
    
  end
  
  
end