function exportDB2csv()

clc
clear

s = load('dbUserInteractionsLocate.mat');
mystruct = s.UserIntLocate;
[hdrline,linebuff] = mylocaldriver(mystruct,'dbUserInteractionsLocate');

s = load('dbUserInteractionsName.mat');
mystruct = s.UserIntName;
[hdrline,linebuff] = mylocaldriver(mystruct,'dbUserInteractionsName');

s = load('dbImageIndex.mat');
mystruct = s.imageIndex;
[hdrline,linebuff] = mylocaldriver(mystruct,'dbImageIndex');

end

function [hdrline,linebuff] = mylocaldriver(mystruct,fbase)

structfields = fieldnames(mystruct);


linebuff = cell(length(mystruct),1);


hdrline = sprintf('%6s','entry');
for j = 1:length(structfields)
  
  hdrline = sprintf('%s,%s',hdrline,structfields{j});
  
end


for i = 1:length(mystruct)
  
  linebuff{i} = sprintf('%6d',i);
  for j = 1:length(structfields)
    entry = mystruct(i).(structfields{j});
    
    if ischar(entry)
      linebuff{i} = sprintf('%s,%s',linebuff{i},entry);
    else
      linebuff{i} = sprintf('%s,%g',linebuff{i},entry);
    end
    
  end
  
end

fid = fopen(sprintf('%s.csv',fbase),'w');
fprintf(fid,'%s\n',hdrline);

for i = 1:length(linebuff)
  fprintf(fid,'%s\n',linebuff{i});
end

fclose(fid);

end