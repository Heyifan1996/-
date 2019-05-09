%%radiusΪ�뾶��neihborsΪ�ھӸ���%%
function imglbp = normal_LBP(img,radius,neighbors)
imgSize = size(img);
if numel(imgSize) > 2  %���ͼƬ����2ά
   imgG = rgb2gray(img);
else
   imgG = img;
end
[rows, cols] = size(imgG);
rows=int16(rows);
cols=int16(cols);
imglbp = uint8(zeros(rows-2*radius, cols-2*radius));%lbp���ĵ������Ҳ����ȡ���������ģ
for i=radius+1:rows-radius
    for j=radius+1:cols-radius      
%---------------------------------LMCP---------------------------------%
        center = imgG(i, j);%ȷ�����ĵ�λ��
%               ����˫���Բ�ֵ��ʽ�����k��������ĻҶ�ֵ                
%               neighbor = imgG(i+x1, j+y1)*w1 + imgG(i+x1, j+y2)*w2 + imgG(i+x2, j+y1)*w3 + imgG(i+x2, j+y2)*w4;
%               LBP����ͼ���ÿ���ھӵ�LBPֵ�ۼӣ��ۼ�ͨ���������ɣ���Ӧ��LBPֵͨ����λȡ��
        dis_dt = zeros(1,neighbors);
        a = cell(1,8);
        for k=0:neighbors-1
            rx = radius * cos(2.0 * pi * k / neighbors);
            ry = radius * sin(2.0 * pi * k / neighbors);
                
            x1 = round(rx);  %round��������
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
             %bitor��a,b��   ��a��b�����������   bitshift��A,1��A����λ��һλ,���Ϊ16����
                imglbp(i-radius, j-radius) = bitor(imglbp(i-radius, j-radius), bitshift(flag, n-1));
        end

        
        
        end
end
end


