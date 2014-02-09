clc
clear


% initialize the image index
filelist0 = dir('imgs');
filelist = filelist0(3:end);

for i = 1:length(filelist)
  imageIndex(i).uid = i;
  imageIndex(i).path = sprintf('%s/%s/%s',pwd,'imgs',filelist(i).name);
  imageIndex(i).timestamp = system('date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s"');
  imageIndex
end

save('dbImageIndex.mat','imageIndex')

% initialize the interactions database

UserIntName = struct([]);
UserIntLocate = struct([]);
save('dbUserInteractionsName.mat','UserIntName')
save('dbUserInteractionsLocate.mat','UserIntLocate')