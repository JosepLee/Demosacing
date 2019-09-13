function [ imDst ] = Demosaicing_liner( raw )
%ȥ�����˺���(˫���Բ�ֵ��



%�Ƚ�ԭ�ļ�����һ�ݣ�ת����uint8
wid=352;
hei=288;
bayer = uint8(zeros(hei,wid));
for ver=1:hei;
    for hor=1:wid
        bayer(ver,hor)=raw(ver,hor);
    end
end
%��չ��������
bayerPadding = zeros(hei+2,wid+2);
bayerPadding(2:hei+1,2:wid+1) = bayer;
bayerPadding(1,:) = bayerPadding(3,:);
bayerPadding(hei+2,:) = bayerPadding(hei,:);
bayerPadding(:,1) = bayerPadding(:,3);
bayerPadding(:,wid+2) = bayerPadding(:,wid);

%��ʼ������ͼ���ļ�����
imDst = zeros(hei+2, wid+2, 3);

%GRBG��bayer��ʽ
% GRGRGRGRGR
% BGBGBGBGBG

for ver = 2:hei
    for hor = 2:wid
        if(1 == mod(ver-1,2))%�����ԭ�����������
            if(1 == mod(hor-1,2))%�����ԭ�����������
                %��״����Ӧ��GR�е�G��Gͨ��Ϊ�˴�ֵ��Rͨ��Ϊ����ֵ�����Բ�ֵ��Bͨ��Ϊ����ֵ�����Բ�ֵ
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
                imDst(ver,hor,1) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
            else
                %��״����ӦGR�е�R,Rͨ��Ϊ�˴�ֵ��Gͨ��Ϊ���������ĸ�ֵ���Բ�ֵ��Rͨ��Ϊ�����������������ĸ�ֵ���Բ�ֵ
                imDst(ver,hor,1) = bayerPadding(ver,hor);
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
                imDst(ver,hor,3) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
            end
        else
            if(1 == mod(hor-1,2))
                 %��״����ӦBG�е�B,Bͨ��Ϊ�˴�ֵ��Gͨ��Ϊ���������ĸ�ֵ���Բ�ֵ��Bͨ��Ϊ�����������������ĸ�ֵ���Բ�ֵ
                imDst(ver,hor,3) = bayerPadding(ver,hor);
                imDst(ver,hor,2) = (bayerPadding(ver-1,hor) + bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1) + bayerPadding(ver+1,hor)) / 4;
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor-1) + bayerPadding(ver-1,hor+1) + bayerPadding(ver+1,hor-1) + bayerPadding(ver+1,hor+1)) / 4;
            else
                %��״����Ӧ��GB�е�G��Gͨ��Ϊ�˴�ֵ��Bͨ��Ϊ����ֵ�����Բ�ֵ��Rͨ��Ϊ����ֵ�����Բ�ֵ
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                imDst(ver,hor,3) = (bayerPadding(ver,hor-1) + bayerPadding(ver,hor+1)) / 2;
                imDst(ver,hor,1) = (bayerPadding(ver-1,hor) + bayerPadding(ver+1,hor)) / 2;
            end
        end
    end
end
%������ͨ����Ϊһ����ά���󷵻�
imDst = uint8(imDst(2:hei+1,2:wid+1,:));
end

