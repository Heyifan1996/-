%%radiusΪ�뾶��neihborsΪ�ھӸ���%%
function imglbp = getCircularLBPFeature(img, radius, neighbors)
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

    for k=0:neighbors-1
%       ���������������ĵ������ƫ����rx��ry       ƫ�Ƶ㰴�հ뾶Ϊradius��ʱ��ѡȡ 
        rx = radius * cos(2.0 * pi * k / neighbors);
        ry = -radius * sin(2.0 * pi * k / neighbors);
%       �Բ�����ƫ�����ֱ��������ȡ��        
        x1 = floor(rx);  %floor����ȡ��
        x2 = ceil(rx);   %ceil����ȡ֤
        y1 = floor(ry);
        y2 = ceil(ry);
%       ������ƫ����ӳ�䵽0-1֮��        
        tx = rx - x1;
        ty = ry - y1;
%       ����0-1֮���x��y��Ȩ�ؼ��㹫ʽ����Ȩ�أ�Ȩ�����������λ���޹أ��������Ĳ�ֵ�й�
        w1 = (1-tx) * (1-ty);
        w2 = tx * (1-ty);
        w3 = (1-tx) * ty;
        w4 = tx * ty;
%����LBPֵ
        for i=radius+1:rows-radius
            for j=radius+1:cols-radius
                center = imgG(i, j);%ȷ�����ĵ�λ��
%               ����˫���Բ�ֵ��ʽ�����k��������ĻҶ�ֵ                
                neighbor = imgG(i+x1, j+y1)*w1 + imgG(i+x1, j+y2)*w2 + imgG(i+x2, j+y1)*w3 + imgG(i+x2, j+y2)*w4;
%               LBP����ͼ���ÿ���ھӵ�LBPֵ�ۼӣ��ۼ�ͨ���������ɣ���Ӧ��LBPֵͨ����λȡ��
                if neighbor > center
                    flag = 1;
                else
                    flag = 0;
                end
                %bitor��a,b��   ��a��b�����������   bitshift��A,1��A����λ��һλ,���Ϊ16����
                imglbp(i-radius, j-radius) = bitor(imglbp(i-radius, j-radius), bitshift(flag, neighbors-k-1));
            end
        end
    end
end

