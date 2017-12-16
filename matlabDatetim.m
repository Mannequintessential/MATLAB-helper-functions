function dateNumber = matlabDatetim(unixTime)
% this function converts the commonly used unix time format to matlab time.
% Unix starts counting miliseconds from Jan 1, 1970. Matlab starts counting
% second from Jan 1, 1900. 
%
% unixTime : this is the number of seconds since Jan 1, 1970
%
% dateNumber : this is the number of seconds since Jan 1, 1900
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dateNumber = unixTime/86400000 + datenum(1970,1,1);