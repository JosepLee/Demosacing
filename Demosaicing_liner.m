function [ imDst ] = Demosaicing_liner( raw )
%去马赛克函数(双线性插值）



%先将原文件复制一份，转换成uint8
wid=352;
hei=288;
bayer = uint8(zeros(hei,wid));
for ver=1:hei;
    for hor=1:wid
        bayer(ver,hor)=raw(ver,hor);
    end
end
%扩展两行两列
bayerPadding = zeros(hei+2,wid+2);
bayerPadding(2:hei+1,2:wid+1) = bayer;
bayerPadding(1,:) = bayerPadding(3,:);
bayerPadding(hei+2,:) = bayerPadding(hei,:);
bayerPadding(:,1) = bayerPadding(:,3);
bayerPadding(:,wid+2) = bayerPadding(:,wid);

%初始化最后的图像文件矩阵
imDst = zeros(hei+2, wid+2, 3);

%GRBG的bayer格式
% GRGRGRGRGR
% BGBGBGBGBG

for ver = 2:hei
    for hor = 2:wid
        if(1 == mod(ver-1,2))%如果是原矩阵的奇数行
            if(1 == mod(hor-1,2))%如果是原矩阵的奇数列
                %此状况对应是GR行的G，G通道为此处值，R通道为左右值的线性插值，B通道为上下值的线性插值
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
                imDst(ver,hor,1) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
            else
                %此状况对应GR行的R,R通道为此处值，G通道为上下左右四个值线性插值，R通道为左上右上左下右下四个值线性插值
                imDst(ver,hor,1) = bayerPadding(ver,hor);
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
            end
        else
            if(1 == mod(hor-1,2))
                 %此状况对应BG行的B,B通道为此处值，G通道为上下左右四个值线性插值，B通道为左上右上左下右下四个值线性插值
                imDst(ver,hor,3) = bayerPadding(ver,hor);
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
            else
                %此状况对应是GB行的G，G通道为此处值，B通道为左右值的线性插值，R通道为上下值的线性插值
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,3) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
            end
        end
    end
end
%将三个通道合为一个三维矩阵返回
imDst = uint8(imDst(2:hei+1,2:wid+1,:));
end

