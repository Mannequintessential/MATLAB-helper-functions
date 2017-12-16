function ds = convertUnixTimeMS( unix_time_ms )
    dn = unix_time_ms/86400000 + 719529;   %# == datenum(1970,1,1)\
    ds = datestr(dn,'dd.mm.yyyy-HH:MM:SS:fff');
end