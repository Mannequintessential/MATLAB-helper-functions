function [tempdata] = JSONcleaner(data)
%% timestamp thingy
% find the users who have done work
% this section will likely not be necessary when participants are paid to
% do work
notEmpty = [];
for i = 1:length(data)
    if isstruct(data{i,1}.result) || iscell(data{i,1}.result)
        notEmpty = [notEmpty, i];
    end
end
%% parse through weird formats and make it consistent
for i = 1:length(notEmpty)
    clearvars userData;
    if ~iscell(data.activity{notEmpty(i),1}.result)
        data.activity{notEmpty(i),1}.result = struct2cell(data.activity{notEmpty(i),1}.result)';
    end
    found = 0;
    k = 1;
    while found == 0
        if ~isempty(data.activity{notEmpty(i),1}.result{k,1}) %&& ~isempty(fieldnames(data.activity{notEmpty(i),1}.result{k,1}))
%             if strcmp(fieldnames(data.activity{notEmpty(i),1}.result{k,1}),'data.activity_data')
%                 userData = data.activity{notEmpty(i),1}.result{k,1}.data.activity_data;
%                 found = 1;
%             else
                userData = data.activity{notEmpty(i),1}.result{k,1};
                found = 1;
%             end
        else
            k = k + 1;
        end
    end
    for j = k+1:length(data.activity{notEmpty(i),1}.result)
        if  ~isempty(data.activity{notEmpty(i),1}.result{j,1}) %&& ~isempty(fieldnames(data.activity{notEmpty(i),1}.result{j,1})) 
%             if strcmp(fieldnames(data.activity{notEmpty(i),1}.result{j,1}),'data.activity_data')
%                 tempUser = [userData; data.activity{notEmpty(i),1}.result{j,1}.data.activity_data];
%                 clearvars userData;
%                 userData = tempUser;
%                 clearvars tempUser;
%             else
                tempUser = [userData; data.activity{notEmpty(i),1}.result{j,1}];
                clearvars userData;
                userData = tempUser;
                clearvars tempUser;
%             end
        end
    end
    [tempdata(i,1).data] = userData;
end

%% convert timestamp to human readable
for i = 1:length(tempdata)
    for j = 1:length(tempdata(i).data)
        timeTemp = matlabDatetim(tempdata(i).data(j).timestamp);
        tempdata(i).data(j).timeText = datestr(timeTemp);
        clear timeTemp
    end
end