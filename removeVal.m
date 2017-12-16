function [vectorout] = removeVal(vectorin, value)

vectorout=vectorin;

for i=1:length(vectorin)
	if vectorin(i) == value
		vectorout(i) = 0;
	end
end

end

