function filtData = movingAverage(data, x)
 
% initialize counter j
j=1;
filtData=zeros(length(data),size(data,2));
for i = 1:length(data)
% taking the mean of the first x points
    if i <= x
        filtData(j,:)=mean(data(1:i+x,:));
% taking the mean of the last x points
    elseif i >= length(data)-x
        filtData(j,:)=mean(data(i-x:length(data),:));
% taking the mean of all other points   
    else
        filtData(j,:)=mean(data(i-x:i+x,:));
    end
% increment the counter   
    j=j+1;
end
 