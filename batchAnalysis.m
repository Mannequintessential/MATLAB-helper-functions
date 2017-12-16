%% Core Motion Activity and Step analysis
%% set directory for data import
clear
close all;
dataDirectory = '/Users/iijimjao/Dropbox (adidas)/Monte/queried';
contentFolders = dir(dataDirectory);

%% batch process through all the folders
for folder = 20%:length(contentFolders)
    workFolder = [dataDirectory '/' contentFolders(folder).name];
    mainContent = dir(workFolder);
    data = monteDataFormat(workFolder);
    
    %% create a table with Core Motion step and activity data
    % find the first and last minute bucket
    startTime = max(data.CMactivity.time(1), data.CMsteps.timestamp(1));
    endTime = min(data.CMactivity.time(end), data.CMsteps.timestamp(end));
    
    % find the index of the first and last timestamps
    CMstepStart = find(startTime==data.CMsteps.timestamp);
    CMstepEnd = find(endTime==data.CMsteps.timestamp);
    
    CMactStart = find(startTime==data.CMactivity.time);
    CMactEnd = find(endTime==data.CMactivity.time);
    
    % make a table with the combined activity, step, and distance data
    data.CMall = data.CMactivity(CMactStart:CMactEnd,:);
    data.CMall = [data.CMall data.CMsteps(CMstepStart:CMstepEnd,{'step_count','distance_meters'})];
    
    %% analyze the datas
    % doing a scatter plot of walking durations vs step count is too noisy.
    % This is partially because the step data is convoluted by running times as
    % well. To fix this, find all minute buckets with 60 seconds of walking
    % detected
    walkIdx = find(data.CMall.walking == 60);
    walkAndSteps = data.CMall{walkIdx,'step_count'};
    
    %% this section is commented out because it didn't work
    % a plot of walkAndSteps shows that there is a very high range of steps in
    % minute buckets with 100% walking. I conclude that the minute buckets do
    % not line up between the two sources. There is a non-linear shift in
    % minute buckets so they are not comparable. To work around this, make 5
    % minute buckets. We will lose resolution, but hopefully can create
    % a cleaner regression line
    
    % this takes a rolling 5 minute average of each minute bucket. This
    % will definitely introduce error in the surrounding buckets, but should
    % weight the regression line towards accurate.
    if isfield(data, 'CM5min')
        data = rmfield(data, 'CM5min');
    end
    j = 1;
    for i = 3:height(data.CMall)-3
        data.CM5min(j).time = data.CMall.time(i);
        data.CM5min(j).unknown = sum(data.CMall.unknown(i-2:i+2))/5;
        data.CM5min(j).stationary = sum(data.CMall.stationary(i-2:i+2))/5;
        data.CM5min(j).walking = sum(data.CMall.walking(i-2:i+2))/5;
        data.CM5min(j).running = sum(data.CMall.running(i-2:i+2))/5;
        data.CM5min(j).cycling = sum(data.CMall.cycling(i-2:i+2))/5;
        data.CM5min(j).automotive = sum(data.CMall.automotive(i-2:i+2))/5;
        data.CM5min(j).step_count = sum(data.CMall.step_count(i-2:i+2))/5;
        data.CM5min(j).distance_meters = sum(data.CMall.distance_meters(i-2:i+2))/5;
        j = j + 1;
    end
    data.CM5min = struct2table(data.CM5min);
    
    walkIdx5 = find(data.CM5min.walking > 50);
    walkAndSteps5(:,1) = data.CM5min{walkIdx5, 'walking'};
    walkAndSteps5(:,2) = data.CM5min{walkIdx5, 'step_count'};
    
    %% experiment
    % identify minutes with steps greater than 130 as running
    runMin = find(data.CM5min.step_count > 120);
    runGuess = zeros(height(data.CM5min),1);
    runGuess(runMin) = 60;
    runGuess = array2table(runGuess, 'VariableNames',{'runGuess'});
    
    % create average walking time from step counts and see
    strideRate = 1.25; % units: steps/sec. equivalent of 70 steps/min
    walkGuess = data.CM5min.step_count./strideRate;
    walkGuess(runMin) = 0;
    walkGuess(walkGuess>60) = 60;
    walkGuess = array2table(walkGuess,'VariableNames',{'walkGuess'});
    
    % add calculated columns to table
    data.CM5min = [data.CM5min walkGuess runGuess];
    
    
    %% validate
    % validate the daily summary of calculated data against Core Motion Activity data
    data.CMdaily = daySplit(data.CMall);
    data.CM5mindaily = daySplit(data.CM5min);
    
    % validate the minute buckets of teh calculated data against the Core
    % Motion Activity data. We recognize that Core Motion is prone to error so
    % we will consider times where we report walking or running and Core Motion
    % reports cycling or unknown to be a correct prediction from our algorithm
    
    %% save analyzed data
    save([workFolder '/' data.meta.phoneName '.mat'],'data');
    clearvars -except folder dataDirectory contentFolders
end