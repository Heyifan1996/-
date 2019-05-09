function [ vector ] = countnumber( X )
channel=size(X,3);
row=size(X,1);
col=size(X,2);
vector=zeros(256,3);
for i=1:channel
    temp=X(:,:,i);
    for j=1:row*col
        vector(temp(j)+1,i)= vector(temp(j)+1,i)+1;
        
    end
end
vector=reshape(vector,1,256*3);
end

