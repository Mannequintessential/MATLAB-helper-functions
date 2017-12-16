% rounds the vector x to d significant digits
function y = roundToDec(x,d)
    inte = round(x);
    deci = x - inte;
    newdeci = round(deci*(10^d));
    y = inte + newdeci/(10^d);
end
 