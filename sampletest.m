load inital_data
load weight3
load trainvector
trainclass=att_per_class;
for i=1:size(trainclass,1)
    trainclass(i,2:end)=trainclass(i,2:end)/sum(trainclass(i,2:end));
end

sampletest_label=zeros(length(train),1);
tic;
for i=1:length(train)
    tempvector=trainvector(i,:);
    result=tempvector*weight;
    result=exp(result)/sum(exp(result));
     distance=zeros(size(trainclass,1),1);
        for C=1:size(trainclass,1)
            distance(C)=norm(result-trainclass(C,2:end));
        end
%         distance=distance/sum(distance);%πÈ“ªªØ
%         pro=1-distance;
        [~,index]=min(distance);
        sampletest_label(i)=trainclass(index,1);
end
toc;
count=0;
for i=1:length(train)
    if sampletest_label(i)==train{i,2}
        count=count+1;
    end
end
rate=count/length(train);