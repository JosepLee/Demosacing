function [ imDst ] = Demosaicing_bicubic( raw )
%去马赛克函数
%   此处显示详细说明


wid=352;
hei=288;
bayer = uint8(zeros(hei,wid));
for ver=1:hei;
    for hor=1:wid
        bayer(ver,hor)=raw(ver,hor);
    end
end
%上下左右四个边扩展三行三列
bayerPadding = zeros(hei+6,wid+6);
bayerPadding(4:hei+3,4:wid+3) = bayer;
bayerPadding(1,:) = bayerPadding(5,:);
bayerPadding(2,:) = bayerPadding(6,:);
bayerPadding(3,:) = bayerPadding(7,:);
bayerPadding(hei+4,:) = bayerPadding(hei+2,:);
bayerPadding(hei+5,:) = bayerPadding(hei+3,:);
bayerPadding(hei+6,:) = bayerPadding(hei+4,:);
bayerPadding(:,1) = bayerPadding(:,5);
bayerPadding(:,2) = bayerPadding(:,6);
bayerPadding(:,3) = bayerPadding(:,7);
bayerPadding(:,wid+4) = bayerPadding(:,wid+2);
bayerPadding(:,wid+5) = bayerPadding(:,wid+3);
bayerPadding(:,wid+6) = bayerPadding(:,wid+4);

%建立最终图像信息矩阵
imDst = zeros(hei+2, wid+2, 3);

%插值部分，其中SW函数是用来算权重的，用了B样条函数
for ver = 4:hei+3
    for hor = 4:wid+3    
        if(1 == mod(ver-1,2))%如果是原矩阵的奇数行
            if(1 == mod(hor-1,2))%如果是原矩阵的奇数列
                %此状况对应是GR行的G，G通道为此处值，R通道为左右值的三次插值，B通道为上下值的三次插值
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                %权重向量
                A_B=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                %B信息的向量
                B_B=[bayerPadding(ver-3,hor)
                    bayerPadding(ver-1,hor) 
                    bayerPadding(ver+1,hor)
                    bayerPadding(ver+3,hor)];
                %权重向量
                 A_R=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                 %R信息的向量
                B_R=[bayerPadding(ver,hor-3)
                    bayerPadding(ver,hor-1) 
                    bayerPadding(ver,hor+1)
                    bayerPadding(ver,hor+3)];
                imDst(ver,hor,1) = A_R*B_R;
                imDst(ver,hor,3) = A_B*B_B;
            else
                %此状况对应GR行的R,R通道为此处值，G通道为周围16个值的双三次插值，B通道为为周围16个值的双三次插值
                imDst(ver,hor,1) = bayerPadding(ver,hor);
                %权重向量
                A=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                C=[sw(1.5);sw(0.5);sw(0.5);sw(1.5)];
                %16个B的向量
                    B=[bayerPadding(ver-3,hor-3) bayerPadding(ver-3,hor-1) bayerPadding(ver-3,hor+1) bayerPadding(ver-3,hor+3)
                       bayerPadding(ver-1,hor-3) bayerPadding(ver-1,hor-1) bayerPadding(ver-1,hor+1) bayerPadding(ver-1,hor+3)
                       bayerPadding(ver+1,hor-3) bayerPadding(ver+1,hor-1) bayerPadding(ver+1,hor+1) bayerPadding(ver+1,hor+3)
                       bayerPadding(ver+3,hor-3) bayerPadding(ver+3,hor-1) bayerPadding(ver+3,hor+1) bayerPadding(ver+3,hor+3)];
               %权重向量
                A_G=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                C_G=[sw(1.5);sw(0.5);sw(0.5);sw(1.5)];
                %16个G信息的向量
                  B_G=[bayerPadding(ver-3,hor) bayerPadding(ver-2,hor+1) bayerPadding(ver-1,hor+2) bayerPadding(ver,hor+3)
                       bayerPadding(ver-2,hor-1) bayerPadding(ver-1,hor) bayerPadding(ver,hor+1) bayerPadding(ver+1,hor+2)
                       bayerPadding(ver-1,hor-2) bayerPadding(ver,hor-1) bayerPadding(ver+1,hor) bayerPadding(ver+2,hor+1)
                       bayerPadding(ver,hor-3) bayerPadding(ver+1,hor-2) bayerPadding(ver+2,hor-1) bayerPadding(ver+3,hor)];
                   
                imDst(ver,hor,2) =A_G*B_G*C_G ;
                imDst(ver,hor,3) = A*B*C;
            end
        else
            if(1 == mod(hor-1,2))
                %此状况对应BG行的B,B通道为此处值，G通道为周围16个值的双三次插值，R通道为为周围16个值的双三次插值
                imDst(ver,hor,3) = bayerPadding(ver,hor);
                A=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                C=[sw(1.5);sw(0.5);sw(0.5);sw(1.5)];
                    B=[bayerPadding(ver-3,hor-3) bayerPadding(ver-3,hor-1) bayerPadding(ver-3,hor+1) bayerPadding(ver-3,hor+3)
                       bayerPadding(ver-1,hor-3) bayerPadding(ver-1,hor-1) bayerPadding(ver-1,hor+1) bayerPadding(ver-1,hor+3)
                       bayerPadding(ver+1,hor-3) bayerPadding(ver+1,hor-1) bayerPadding(ver+1,hor+1) bayerPadding(ver+1,hor+3)
                       bayerPadding(ver+3,hor-3) bayerPadding(ver+3,hor-1) bayerPadding(ver+3,hor+1) bayerPadding(ver+3,hor+3)];
                A_G=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                C_G=[sw(1.5);sw(0.5);sw(0.5);sw(1.5)];
                  B_G=[bayerPadding(ver-3,hor) bayerPadding(ver-2,hor+1) bayerPadding(ver-1,hor+2) bayerPadding(ver,hor+3)
                       bayerPadding(ver-2,hor-1) bayerPadding(ver-1,hor) bayerPadding(ver,hor+1) bayerPadding(ver+1,hor+2)
                       bayerPadding(ver-1,hor-2) bayerPadding(ver,hor-1) bayerPadding(ver+1,hor) bayerPadding(ver+2,hor+1)
                       bayerPadding(ver,hor-3) bayerPadding(ver+1,hor-2) bayerPadding(ver+2,hor-1) bayerPadding(ver+3,hor)];
                   
                imDst(ver,hor,2) =A_G*B_G*C_G ;
                imDst(ver,hor,1) =A*B*C;
            else
                %此状况对应是GR行的G，G通道为此处值，R通道为左右值的三次插值，B通道为上下值的三次插值
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                A_B=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                B_B=[bayerPadding(ver-3,hor)
                    bayerPadding(ver-1,hor) 
                    bayerPadding(ver+1,hor)
                    bayerPadding(ver+3,hor)];
                 A_R=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                B_R=[bayerPadding(ver,hor-3)
                    bayerPadding(ver,hor-1) 
                    bayerPadding(ver,hor+1)
                    bayerPadding(ver,hor+3)];
                imDst(ver,hor,1) = A_B*B_B;
                imDst(ver,hor,3) = A_R*B_R;

            end
        end
    end
end
imDst = uint8(imDst(2:hei+1,2:wid+1,:));
end