 imgPath = 'D:/天池/之江杯图像处理/DatasetA_train_20180813/train/';        % 图像库路径
 imgDir  = dir([imgPath '*.JPEG']); % 遍历所有jpg格式文件
   for i = 1:length(imgDir)          % 遍历结构体就可以一一处理图片了
    img = imread([imgPath imgDir(i).name]); %读取每张图片
   end
   
   temp2=class(:,1);
   for i =1:length(image)
       if image{i,2}==0
         tempid=randperm(length(temp2),1);
         image{i,2}=temp2(tempid);
       else
           continue
       end
       
   end
   fid=fopen('D:\天池\之江杯图像处理\submit.txt','wt');
   for i=1:length(image)
   fprintf(fid,strcat(image{i,1},'\t ZJL%d'),image{i,2});
   fprintf(fid,'\n');
   end
   fclose(fid);
 T1=zeros(length(T),2);
 T1(:,1)=T;
T1(:,2)=total*ones(length(T),1)+0.001*randn(length(T),1);
   