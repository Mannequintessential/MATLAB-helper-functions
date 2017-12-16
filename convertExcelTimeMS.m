function ds = convertExcelTimeMS( unix_time_ms )
    dn = unix_time_ms + 693960;   %# == datenum(1970,1,1)
    ds = datestr(dn,'dd.mm.yyyy-HH:MM:SS:fff');
end