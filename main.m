%去马赛克大作业代码
% LZX 2018.12.22
%想要成功处理请将GRGB形式的bayer文件正确填写在第6行
clear
clc
fid=fopen('mosaiced_foreman.raw','r');
row=352;
col=288;
frames=90;
%这部分用来生成视频，语句中都有writeVideo(myObj,XX);
%如果要调用生成不同结果请注意每次只写出一结果个视频，每次都修改myObj的名字
%或者多生成几个Obj

% myObj = VideoWriter('Demosaicing_Orign.avi');%初始化一个avi文件
% myObj.FrameRate = 25;%设置帧频

%open(myObj);
%循环读完90帧
for i=1:frames
   %读取一帧 
    Y1=(fread(fid,[row,col]))';
    YY=uint8(Y1);

%生成相对应的视频，我只保留了一个生成原视频的语句 
%    writeVideo(myObj,YY);
%窗口1-4分别是原视频，双线性插值，双三次插值，边缘敏感
%  显示原视频
    subplot(2,2,1)
    imshow(Y1,[]);
%  显示双线性插值去马赛克 
    Y2=Demosaicing_liner(Y1);
    subplot(2,2,3)
    imshow(Y2,[]);
    %writeVideo(myObj,Y3);
%  显示双三次插值去马赛克
    Y3=Demosaicing_bicubic(Y1);
    subplot(2,2,2);
    imshow(Y3); 
    %writeVideo(myObj,Y3);
%  显示边缘敏感双线性插值去马赛克
    Y4=DemosaicingEdge(Y1);

    subplot(2,2,4);
    imshow(Y4);
    %writeVideo(myObj,Y4);
    pause(0.01)
end


%close(myObj);
