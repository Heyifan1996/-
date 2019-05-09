%%radius为半径，neihbors为邻居个数%%
function imglbp = normal_LBP(img,radius,neighbors)
imgSize = size(img);
if numel(imgSize) > 2  %如果图片大于2维
   imgG = rgb2gray(img);
else
   imgG = img;
end
[rows, cols] = size(imgG);
rows=int16(rows);
cols=int16(cols);
imglbp = uint8(zeros(rows-2*radius, cols-2*radius));%lbp中心点个数，也是提取后的特征规模
for i=radius+1:rows-radius
    for j=radius+1:cols-radius      
%---------------------------------LMCP---------------------------------%
        center = imgG(i, j);%确定中心点位置
%               根据双线性插值公式计算第k个采样点的灰度值                
%               neighbor = imgG(i+x1, j+y1)*w1 + imgG(i+x1, j+y2)*w2 + imgG(i+x2, j+y1)*w3 + imgG(i+x2, j+y2)*w4;
%               LBP特征图像的每个邻居的LBP值累加，累加通过与操作完成，对应的LBP值通过移位取得
        dis_dt = zeros(1,neighbors);
        a = cell(1,8);
        for k=0:neighbors-1
            rx = radius * cos(2.0 * pi * k / neighbors);
            ry = radius * sin(2.0 * pi * k / neighbors);
                
            x1 = round(rx);  %round四舍五入
            y1 = round(ry);  
            a{k+1}=[x1,y1];
        end
        a = {a{3:end},a{1:2}};
        for n = 1:neighbors 
            if (imgG(i+a{n}(1),j+a{n}(2)) > center)
                flag = 1;
            else
                flag = 0;
            end
             %bitor（a,b）   对a，b进行异或运算   bitshift（A,1）A向左位移一位,输出为16进制
                imglbp(i-radius, j-radius) = bitor(imglbp(i-radius, j-radius), bitshift(flag, n-1));
        end

        
        
        end
end
end


