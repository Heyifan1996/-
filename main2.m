load 'inital_data';
%通过LBP加直方图先提取特征
% trainvector=zeros(length(train),768);
%  tic;
% for i=1:length(train)
%    
     filename=[imgPath imgDir(i).name];
     tempimage=imread(filename);%读取一张图片
     if size(tempimage,3)==1%把单通道的变为多通道
      temp=zeros(64,64,3);
        for j=1:3
             temp(:,:,j)=tempimage;
        end
      tempimage=uint8(temp);  
     end
%      LBP_image=LBP(tempimage,1); 
%      trainvector(i,:)= countnumber(LBP_image);  
%   
% end
% toc;

trainclass=att_per_class;
for i=1:size(trainclass,1)
    trainclass(i,2:end)=trainclass(i,2:end)/sum(trainclass(i,2:end));
end
load trainvector;
learningrate=0.00001;
% rng(0);
% weight=0.1*randn(768,30);
load weight2;
flag_pre=2;
tic;
for iter=1:1000
    delta_total=zeros(length(train),1);
for i=1:length(train)
tempvector=trainvector(i,:);
result=tempvector*weight;
result=exp(result)/sum(exp(result));
real_vector=trainclass(trainclass(:,1)==train{i,2},2:end);
delta=result-real_vector;
delta_total(i)=norm(delta);
% if norm(delta)<1e-20
%     break
% end
for j=1:length(result)
    tempdelta=tempvector*delta(j);
    weight(:,j)=weight(:,j)-learningrate*tempdelta';
end
end
flag=sum(delta_total)/length(train);

% if flag-flag_pre<0.01
%     break
% else
%     flag_pre=flag;
% end

end
toc;

