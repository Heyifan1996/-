 imgPath = 'D:/���/֮����ͼ����/DatasetA_train_20180813/train/';        % ͼ���·��
 imgDir  = dir([imgPath '*.JPEG']); % ��������jpg��ʽ�ļ�
   for i = 1:length(imgDir)          % �����ṹ��Ϳ���һһ����ͼƬ��
    img = imread([imgPath imgDir(i).name]); %��ȡÿ��ͼƬ
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
   fid=fopen('D:\���\֮����ͼ����\submit.txt','wt');
   for i=1:length(image)
   fprintf(fid,strcat(image{i,1},'\t ZJL%d'),image{i,2});
   fprintf(fid,'\n');
   end
   fclose(fid);
 T1=zeros(length(T),2);
 T1(:,1)=T;
T1(:,2)=total*ones(length(T),1)+0.001*randn(length(T),1);
   