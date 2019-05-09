%%radius为半径，neihbors为邻居个数%%
%img = imread((strcat(file_name,'001.jpg')));
%,imglbp2,imglbp3,imglbp4
%[i,ii,iii,iiii] = LMCP_getCircularLBPFeature(img, 1, 8)
%j = LMCP_getCircularLBPFeature(img, 1, 8)
function [imglbp] = LMCP_getCircularLBPFeature(img, radius, neighbors)
%function [imglbp1,imglbp2,imglbp3,imglbp4] = LMCP_getCircularLBPFeature(img, radius, neighbors)
%img = imread(bl);
imgSize = size(img);
if numel(imgSize) > 2  %如果图片大于2维
   imgG = rgb2gray(img);
else
   imgG = img;
end
[rows, cols] = size(imgG);
rows=int16(rows);
cols=int16(cols);
imglbp = uint8(zeros(rows-2*radius, cols-2*radius));
imglbp1 = uint8(zeros(rows-2*radius, cols-2*radius));%lbp中心点个数，也是提取后的特征规模
imglbp2 = uint8(zeros(rows-2*radius, cols-2*radius));    
imglbp3 = uint8(zeros(rows-2*radius, cols-2*radius));
imglbp4 = uint8(zeros(rows-2*radius, cols-2*radius));
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
            dis_dt(n) =  imgG(i+a{n}(1),j+a{n}(2)) - center;
        end
        [~,label]= sort(dis_dt);
        data_L1 = zeros(1,neighbors);
        data_L2 = zeros(1,neighbors);
        data_L3 = zeros(1,neighbors);
        data_L4 = zeros(1,neighbors);
        data_L1(label(1:2))=1;
        data_L2(label(3:4))=1;
        data_L3(label(5:6))=1;
        data_L4(label(7:8))=1;
        for n = 1:neighbors 
             %bitor（a,b）   对a，b进行异或运算   bitshift（A,1）A向左位移一位,输出为16进制
            imglbp1(i-radius, j-radius) = bitor(imglbp1(i-radius, j-radius), bitshift(data_L1(n), n-1));
            imglbp2(i-radius, j-radius) = bitor(imglbp2(i-radius, j-radius), bitshift(data_L2(n), n-1));
            imglbp3(i-radius, j-radius) = bitor(imglbp3(i-radius, j-radius), bitshift(data_L3(n), n-1));
            imglbp4(i-radius, j-radius) = bitor(imglbp4(i-radius, j-radius), bitshift(data_L4(n), n-1));
%         num_L1(i-radius,j-radius) = Bt16(data_L1,8);
%         num_L2(i,j) = Bt16(data_L2,8);
%         num_L3(i,j) = Bt16(data_L3,8);
%         num_L4(i,j) = Bt16(data_L4,8);
       imglbp(i-radius,j-radius) = 0.4*imglbp1(i-radius, j-radius)+0.3*imglbp2(i-radius, j-radius)+0.2*imglbp3(i-radius, j-radius)+0.1*imglbp4(i-radius, j-radius);
 
        end
    end
end

