function [ value ] = transfer( matrix)
value=2^7*matrix(3,3)+2^6*matrix(3,2)+2^5*matrix(3,1)+2^4*matrix(2,1)+2^3*matrix(1,1)+2^2*matrix(1,2)+2*matrix(1,3)+matrix(2,3);
end

