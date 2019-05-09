% clear;clc;
% load data;
% imgPath = 'D:/天池/之江杯图像处理/DatasetA_train_20180813/train/';        % 图像库路径
%  imgDir  = dir([imgPath '*.JPEG']); % 遍历所有jpg格式文件
%  %初始化网络
%  layer_c1_num=10;%第一层卷积层个数
%  layer_c2_num=10;%第二层卷积层个数
%  layer_f1_num=100;%全连接层个数
%  layer_output_num=30;%输出的向量的维数
%  %初始化步长
%  yita=0.001;
%  %初始化偏差
%  bias_c1=(2*rand(1,10)-ones(1,10))*sqrt(3/10);%第一层卷积层偏差
%  bias_c2=(2*rand(1,10)-ones(1,10))*sqrt(3/10);%第二次卷积层偏差
%  bias_f1=(2*rand(1,100)-ones(1,100))*sqrt(3/100);%全连接层的偏差
%  %卷积核初始化
%  kernel_c1=init_kernel(5,5,3,layer_c1_num);
%  kernel_c2=init_kernel(5,5,layer_c1_num,layer_c2_num);
%  kernel_f1=init_kernel(13,13,100,1);%初始化
%  kernel_f1=kernel_f1(:,:,:,1);
%  %初始化池化层均值池化
%  pooling_a=ones(2,2)/4;
%  %全连接层的权值初始化
%  weight_f1=(2*rand(10,100)-ones(10,100))*sqrt(3/1000);
%  weight_output=(2*rand(100,30)-ones(100,30))*sqrt(1/1000);
load 'inital_data';
 disp('网络初始化完成');
 for iter=1:1
     tic;
     for i=1:length(train)
         filename=[imgPath imgDir(i).name];
         tempimage=imread(filename);%读取一张图片
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
         tempatt_vector=tempatt_vector(2:end);%得到当前图片所属类别的特征向量
         state_c1=zeros(60,60,10);
         state_s1=zeros(30,30,10);
         for k=1:layer_c1_num
            
            state_c1(:,:,k)=convolution(tempimage,kernel_c1(:,:,:,k));%3个通道和10个不同的卷积核进行卷积操作得到60*60*30
            %进入激励函数
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));%使正负数间距离更大
            %进入pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);%池化操作后30*30*30
             
         end
         state_c2=zeros(26,26,10);
         state_s2=zeros(13,13,10);
         for k=1:layer_c2_num
            state_c2(:,:,k)=convolution(state_s1,kernel_c2(:,:,:,k));%10张第一层卷积后的结果和10个不同的卷积核进行卷积操作得到26*26*300
            %进入激励函数
            state_c2(:,:,k)=tanh(state_c2(:,:,k)+bias_c2(1,k));%使正负数间距离更大
            %进入pooling1
            state_s2(:,:,k)=pooling(state_c2(:,:,k),pooling_a);%池化操作后13*13*300
             
         end
          %进入f1层
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s2,kernel_f1,weight_f1);
         %进入激励函数
         state_f1=zeros(1,layer_f1_num);
        for nn=1:layer_f1_num
            state_f1(nn)=tanh(state_f1_pre(nn)+bias_f1(1,nn));
        end
        
          %进入softmax层
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
 
 
 disp('训练完成，开始预测');
 testPath= 'D:\天池\之江杯图像处理\DatasetA_test_20180813\DatasetA_test\test\'; 
 test_label=zeros(length(image),1);
 for i =1:length(image)
     tic;
     filename=[testPath image{i}];
     tempimage=imread(filename);%读取一张图片
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
            
            state_c1(:,:,k)=convolution(tempimage,kernel_c1(:,:,:,k));%3个通道和10个不同的卷积核进行卷积操作得到60*60*30
            %进入激励函数
            state_c1(:,:,k)=tanh(state_c1(:,:,k)+bias_c1(1,k));%使正负数间距离更大
            %进入pooling1
            state_s1(:,:,k)=pooling(state_c1(:,:,k),pooling_a);%池化操作后30*30*30
             
         end
         state_c2=zeros(26,26,10);
         state_s2=zeros(13,13,10);
         for k=1:layer_c2_num
            state_c2(:,:,k)=convolution(state_s1,kernel_c2(:,:,:,k));%10张第一层卷积后的结果和10个不同的卷积核进行卷积操作得到26*26*300
            %进入激励函数
            state_c2(:,:,k)=tanh(state_c2(:,:,k)+bias_c2(1,k));%使正负数间距离更大
            %进入pooling1
            state_s2(:,:,k)=pooling(state_c2(:,:,k),pooling_a);%池化操作后13*13*300
             
         end
          %进入f1层
        [state_f1_pre,state_f1_temp]=convolution_f1(state_s2,kernel_f1,weight_f1);
         %进入激励函数
         state_f1=zeros(1,layer_f1_num);
        for nn=1:layer_f1_num
            state_f1(nn)=tanh(state_f1_pre(nn)+bias_f1(1,nn));
        end
        
          %进入softmax层
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
 
