%ȥ�����˴���ҵ����
% LZX 2018.12.22
%��Ҫ�ɹ������뽫GRGB��ʽ��bayer�ļ���ȷ��д�ڵ�6��
clear
clc
fid=fopen('mosaiced_foreman.raw','r');
row=352;
col=288;
frames=90;
%�ⲿ������������Ƶ������ж���writeVideo(myObj,XX);
%���Ҫ�������ɲ�ͬ�����ע��ÿ��ֻд��һ�������Ƶ��ÿ�ζ��޸�myObj������
%���߶����ɼ���Obj

% myObj = VideoWriter('Demosaicing_Orign.avi');%��ʼ��һ��avi�ļ�
% myObj.FrameRate = 25;%����֡Ƶ

%open(myObj);
%ѭ������90֡
for i=1:frames
   %��ȡһ֡ 
    Y1=(fread(fid,[row,col]))';
    YY=uint8(Y1);

%�������Ӧ����Ƶ����ֻ������һ������ԭ��Ƶ����� 
%    writeVideo(myObj,YY);
%����1-4�ֱ���ԭ��Ƶ��˫���Բ�ֵ��˫���β�ֵ����Ե����
%  ��ʾԭ��Ƶ
    subplot(2,2,1)
    imshow(Y1,[]);
%  ��ʾ˫���Բ�ֵȥ������ 
    Y2=Demosaicing_liner(Y1);
    subplot(2,2,3)
    imshow(Y2,[]);
    %writeVideo(myObj,Y3);
%  ��ʾ˫���β�ֵȥ������
    Y3=Demosaicing_bicubic(Y1);
    subplot(2,2,2);
    imshow(Y3); 
    %writeVideo(myObj,Y3);
%  ��ʾ��Ե����˫���Բ�ֵȥ������
    Y4=DemosaicingEdge(Y1);

    subplot(2,2,4);
    imshow(Y4);
    %writeVideo(myObj,Y4);
    pause(0.01)
end


%close(myObj);
