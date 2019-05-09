%%radius为半径，neihbors为邻居个数%%
function imglbp = getCircularLBPFeature(img, radius, neighbors)
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

    for k=0:neighbors-1
%       计算采样点对于中心点坐标的偏移量rx，ry       偏移点按照半径为radius逆时针选取 
        rx = radius * cos(2.0 * pi * k / neighbors);
        ry = -radius * sin(2.0 * pi * k / neighbors);
%       对采样点偏移量分别进行上下取整        
        x1 = floor(rx);  %floor向下取整
        x2 = ceil(rx);   %ceil向上取证
        y1 = floor(ry);
        y2 = ceil(ry);
%       将坐标偏移量映射到0-1之间        
        tx = rx - x1;
        ty = ry - y1;
%       根据0-1之间的x，y的权重计算公式计算权重，权重与坐标具体位置无关，与坐标间的差值有关
        w1 = (1-tx) * (1-ty);
        w2 = tx * (1-ty);
        w3 = (1-tx) * ty;
        w4 = tx * ty;
%计算LBP值
        for i=radius+1:rows-radius
            for j=radius+1:cols-radius
                center = imgG(i, j);%确定中心点位置
%               根据双线性插值公式计算第k个采样点的灰度值                
                neighbor = imgG(i+x1, j+y1)*w1 + imgG(i+x1, j+y2)*w2 + imgG(i+x2, j+y1)*w3 + imgG(i+x2, j+y2)*w4;
%               LBP特征图像的每个邻居的LBP值累加，累加通过与操作完成，对应的LBP值通过移位取得
                if neighbor > center
                    flag = 1;
                else
                    flag = 0;
                end
                %bitor（a,b）   对a，b进行异或运算   bitshift（A,1）A向左位移一位,输出为16进制
                imglbp(i-radius, j-radius) = bitor(imglbp(i-radius, j-radius), bitshift(flag, neighbors-k-1));
            end
        end
    end
end

