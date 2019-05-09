function [feature_image] = LBP( image ,r)
%     imgSize = size(image);
%     if numel(imgSize) > 2  %如果图片大于2维
%        image= rgb2gray(image);
%     end
feature_image=zeros(size(image,1)-2*r,size(image,2)-2*r,3);
for channel=1:3
    for row=1:size(feature_image,1)
        for col=1:size(feature_image,2)
            tempblock=image(row:row+2*r,col:col+2*r,channel);
            hold=tempblock(r+1,r+1);
            compare=zeros(size(tempblock));
            for k=1:(2*r+1)^2
                if tempblock(k)<=hold
                     compare(k)=0;
                else
                    compare(k)=1;
                end
            end
            
            feature_image(row,col,channel)=transfer(compare);
        end
    end   
end
end

