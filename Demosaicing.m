function [ imDst ] = Demosaicing_liner( raw )
%去马赛克函数(双线性插值）
%   此处显示详细说明


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
imDst = zeros(hei+2, wid+2, 3);

for ver = 2:hei
    for hor = 2:wid
        if(1 == mod(ver-1,2))
            if(1 == mod(hor-1,2))
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
                imDst(ver,hor,1) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
            else
                imDst(ver,hor,1) = bayerPadding(ver,hor);
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
            end
        else
            if(1 == mod(hor-1,2))
                imDst(ver,hor,3) = bayerPadding(ver,hor);
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
            else
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,3) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
            end
        end
    end
end
imDst = uint8(imDst(2:hei+1,2:wid+1,:));
end

