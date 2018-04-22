%% SCRIPT transDataset.m 
%   将SDP中的数据格式转换成当前框架中的格式

clear; clc;

%选择数据集的主目录
mainDir=uigetdir('请选择数据集的主目录...注意更改datasetName字符串');


%数据集的名称
%datasetName='AEEEM';
%datasetName='MORPH';
%datasetName='Relink';
%datasetName='softlab';
datasetName='Eclipse';




%构造数据集全路径
fileLists=dir(fullfile(mainDir,datasetName));
fileNums=length(fileLists)-2;

%创建训练数据和类标数据的cell
%X=cell(1,fileNums);
%Y=cell(1,fileNums);
X=cell(fileNums,1);
Y=cell(fileNums,1);

%循环读入当前数据集下的所有的项目，然后创建一个cell
index = 1;
for i =1 : length(fileLists)
        if(isequal(fileLists(i).name, '.')||...
           isequal(fileLists(i).name, '..')||...
           fileLists(i).isdir)
            %fprintf("continued: %d\r ",i);    
            continue;
        end
        
        
        % fprintf("file name is:%s \r",fileLists(i));
        currentFile=fullfile(mainDir,datasetName,fileLists(i).name);
        
        project=xlsread(currentFile);

        projectX=project(:,1:(size(project,2)-1));
        projectY=project(:,size(project,2)); 
        
        %X{1,index}=projectX;
        %Y{1,index}=projectY;
        X{index,1}=projectX;
        Y{index,1}=projectY;
        
        index=index+1;
end

%最后将两个cell合成一个struct

%s=sprintf(strcat('save',32,datasetName,' X',' Y'));
%eval(s);

eval(['save ',' data\SDPdata\',datasetName,' X',' Y']);
fprintf('save the data successfully!\r');

        
        



