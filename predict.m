clc;
clear;
load weight3;
load inital_data image class;
% %ͨ��LBP��ֱ��ͼ����ȡ����
% testpath='D:\���\֮����ͼ����\DatasetA_test_20180813\DatasetA_test\test\';
% testvector=zeros(length(image),768);
%  tic;
% for i=1:length(image)
%    
%      filename=[testpath image{i}];
%      tempimage=imread(filename);%��ȡһ��ͼƬ
%      if size(tempimage,3)==1%�ѵ�ͨ���ı�Ϊ��ͨ��
%       temp=zeros(64,64,3);
%         for j=1:3
%              temp(:,:,j)=tempimage;
%         end
%       tempimage=uint8(temp);  
%      end
%      LBP_image=LBP(tempimage,1); 
%      testvector(i,:)= countnumber(LBP_image);  
%   
% end
% toc;
load testvector;
testclass=class;
for i=1:size(testclass,1)
    testclass(i,2:end)=testclass(i,2:end)/sum(testclass(i,2:end));
end
 %testclass(13,:)=[];
test_label=zeros(length(image),1);
tic;
for i=1:length(image)
    tempvector=testvector(i,:);
    result=tempvector*weight;
    result=exp(result)/sum(exp(result));
     distance=zeros(size(testclass,1),1);
        for C=1:size(testclass,1)
            distance(C)=norm(result-testclass(C,2:end));
        end
%         distance=distance/sum(distance);%��һ��
%         pro=1-distance;
        [~,index]=min(distance);
        test_label(i)=testclass(index,1);
end
toc;
% unique(test_label);
% length(find(test_label==213));
 for i=1:length(image)
     image{i,2}=test_label(i);
 end
 fid=fopen('D:\���\֮����ͼ����\submit.txt','wt');
   for i=1:length(image)
   fprintf(fid,strcat(image{i,1},'\t ZJL%d'),image{i,2});
   fprintf(fid,'\n');
   end
   fclose(fid);
 