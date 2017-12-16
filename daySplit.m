function splitData = daySplit(data)
% this function takes minute buckets and aggregates it into  daily 
% summaries of the data. 

%% create new variable 
% extract the day of the month from timestamp
days = day(data.time);
% find the unique days of the month
datesUniq = unique(days);
% create variable with table headers
varNames = data.Properties.VariableNames;
for i = 1:length(datesUniq)
    dayIdx = find(days==datesUniq(i));
    [y,m,d] = ymd(data.time(dayIdx(1)));
    dataDate(i,1) = datetime(y,m,d);
    dailySums(i,:) = sum(data{dayIdx,2:end},1);
end
splitData = [table(dataDate) array2table(dailySums)];
splitData.Properties.VariableNames = varNames;