% clear;clc;
% load data;
% imgPath = 'D:/���/֮����ͼ����/DatasetA_train_20180813/train/';        % ͼ���·��
%  imgDir  = dir([imgPath '*.JPEG']); % ��������jpg��ʽ�ļ�
%  %��ʼ������
%  layer_c1_num=10;%��һ���������
%  layer_c2_num=10;%�ڶ����������
%  layer_f1_num=100;%ȫ���Ӳ����
%  layer_output_num=30;%�����������ά��
%  %��ʼ������
%  yita=0.001;
%  %��ʼ��ƫ��
%  bias_c1=(2*rand(1,10)-ones(1,10))*sqrt(3/10);%��һ������ƫ��
%  bias_c2=(2*rand(1,10)-ones(1,10))*sqrt(3/10);%�ڶ��ξ����ƫ��
%  bias_f1=(2*rand(1,100)-ones(1,100))*sqrt(3/100);%ȫ���Ӳ��ƫ��
%  %����˳�ʼ��
%  kernel_c1=init_kernel(5,5,3,layer_c1_num);
%  kernel_c2=init_kernel(5,5,layer_c1_num,layer_c2_num);
%  kernel_f1=init_kernel(13,13,100,1);%��ʼ��
%  kernel_f1=kernel_f1(:,:,:,1);
%  %��ʼ���ػ����ֵ�ػ�
%  pooling_a=ones(2,2)/4;
%  %ȫ���Ӳ��Ȩֵ��ʼ��
%  weight_f1=(2*rand(10,100)-ones(10,100))*sqrt(3/1000);
%  weight_output=(2*rand(100,30)-ones(100,30))*sqrt(1/1000);
load 'inital_data';
 disp('�����ʼ�����');
 for iter=1:1
     tic;
     for i=1:length(train)
         filename=[imgPath imgDir(i).name];
         tempimage=imread(filename);%��ȡһ��ͼƬ
%          tempimage=imread('D:\QQ\664003807\FileRecv\001.jpg');
         if size(tempimage,3)==1
             continue
         else
        
         
         tempimage=double(tempimage);
         [x,y,z]=size(tempimage);
         mean=sum(sum(sum(tempimage)))/(x*y*z);
         tempimage=tempimage-mean;
         templabel=train{i,2};
         tempatt_vector=att_per_class(att_per_class(:,1)==templabel,:);
         tempatt_vector=tempatt_vector(2:end);%�õ���ǰͼƬ����������������
         state_c1=zeros(60,60,10);
         state_s1=zeros(30,30,10);
         for k=1:layer_c1_num
            
            state_c1(:,:,k)=convolution(tempimage,kernel_c1(:,:,:,k));%3��ͨ����10����ͬ�ľ���˽��о�������õ�60*60*30
            %���뼤������
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));%ʹ��������������
            %����pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);%�ػ�������30*30*30
             
         end
         state_c2=zeros(26,26,10);
         state_s2=zeros(13,13,10);
         for k=1:layer_c2_num
            state_c2(:,:,k)=convolution(state_s1,kernel_c2(:,:,:,k));%10�ŵ�һ������Ľ����10����ͬ�ľ���˽��о�������õ�26*26*300
            %���뼤������
            state_c2(:,:,k)=tanh(state_c2(:,:,k)+bias_c2(1,k));%ʹ��������������
            %����pooling1
            state_s2(:,:,k)=pooling(state_c2(:,:,k),pooling_a);%�ػ�������13*13*300
             
         end
          %����f1��
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s2,kernel_f1,weight_f1);
         %���뼤������
         state_f1=zeros(1,layer_f1_num);
        for nn=1:layer_f1_num
            state_f1(nn)=tanh(state_f1_pre(nn)+bias_f1(1,nn));
        end
        
          %����softmax��
         output=zeros(1,layer_output_num);
        for nn=1:layer_output_num
            output(nn)=exp(state_f1*weight_output(:,nn))/sum(exp(state_f1*weight_output));
        end
        
   [kernel_c1,kernel_c2,kernel_f1,weight_f1,weight_output,bias_c1,bias_c2,bias_f1]=CNN_upweight(yita,tempimage,tempatt_vector,state_c1,state_c2,state_s1,state_s2,state_f1,state_f1_temp,output,kernel_c1,kernel_c2,kernel_f1,weight_f1,weight_output,bias_c1,bias_c2,bias_f1);
        end
      end
     toc;
 end
 train_iter=num2str(iter);
 train_iter=['pamarter' train_iter];
 save (train_iter,'kernel_c1',' kernel_c2',' kernel_f1',' weight_f1',' weight_output',' bias_c1',' bias_c2',' bias_f1')
 
 
 disp('ѵ����ɣ���ʼԤ��');
 testPath= 'D:\���\֮����ͼ����\DatasetA_test_20180813\DatasetA_test\test\'; 
 test_label=zeros(length(image),1);
 for i =1:length(image)
     tic;
     filename=[testPath image{i}];
     tempimage=imread(filename);%��ȡһ��ͼƬ
      if size(tempimage,3)==1
             continue
         else
        
     tempimage=double(tempimage);
     [x,y,z]=size(tempimage);
     mean=sum(sum(sum(tempimage)))/(x*y*z);
     tempimage=tempimage-mean;
     state_c1=zeros(60,60,10);
         state_s1=zeros(30,30,10);
         for k=1:layer_c1_num
            
            state_c1(:,:,k)=convolution(tempimage,kernel_c1(:,:,:,k));%3��ͨ����10����ͬ�ľ���˽��о�������õ�60*60*30
            %���뼤������
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));%ʹ��������������
            %����pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);%�ػ�������30*30*30
             
         end
         state_c2=zeros(26,26,10);
         state_s2=zeros(13,13,10);
         for k=1:layer_c2_num
            state_c2(:,:,k)=convolution(state_s1,kernel_c2(:,:,:,k));%10�ŵ�һ������Ľ����10����ͬ�ľ���˽��о�������õ�26*26*300
            %���뼤������
            state_c2(:,:,k)=tanh(state_c2(:,:,k)+bias_c2(1,k));%ʹ��������������
            %����pooling1
            state_s2(:,:,k)=pooling(state_c2(:,:,k),pooling_a);%�ػ�������13*13*300
             
         end
          %����f1��
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s2,kernel_f1,weight_f1);
         %���뼤������
         state_f1=zeros(1,layer_f1_num);
        for nn=1:layer_f1_num
            state_f1(nn)=tanh(state_f1_pre(nn)+bias_f1(1,nn));
        end
        
          %����softmax��
         output=zeros(1,layer_output_num);
        for nn=1:layer_output_num
            output(nn)=exp(state_f1*weight_output(:,nn))/sum(exp(state_f1*weight_output));
        end
        distance=zeros(size(class,1),1);
        for C=1:size(class,1)
            distance(C)=norm(output-class(C,2:end));
        end
        [~,index]=min(distance);
        test_label(i)=class(index,1);
        toc;
      end
 end
 
 for i=1:length(image)
     image{i,2}=test_label(i);
 end
 
