function [ imDst ] = Demosaicing_bicubic( raw )
%ȥ�����˺���
%   �˴���ʾ��ϸ˵��


wid=352;
hei=288;
bayer = uint8(zeros(hei,wid));
for ver=1:hei;
    for hor=1:wid
        bayer(ver,hor)=raw(ver,hor);
    end
end
%���������ĸ�����չ��������
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

%��������ͼ����Ϣ����
imDst = zeros(hei+2, wid+2, 3);

%��ֵ���֣�����SW������������Ȩ�صģ�����B��������
for ver = 4:hei+3
    for hor = 4:wid+3    
        if(1 == mod(ver-1,2))%�����ԭ�����������
            if(1 == mod(hor-1,2))%�����ԭ�����������
                %��״����Ӧ��GR�е�G��Gͨ��Ϊ�˴�ֵ��Rͨ��Ϊ����ֵ�����β�ֵ��Bͨ��Ϊ����ֵ�����β�ֵ
                imDst(ver,hor,2) = bayerPadding(ver,hor);
                %Ȩ������
                A_B=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                %B��Ϣ������
                B_B=[bayerPadding(ver-3,hor)
                    bayerPadding(ver-1,hor) 
                    bayerPadding(ver+1,hor)
                    bayerPadding(ver+3,hor)];
                %Ȩ������
                 A_R=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                 %R��Ϣ������
                B_R=[bayerPadding(ver,hor-3)
                    bayerPadding(ver,hor-1) 
                    bayerPadding(ver,hor+1)
                    bayerPadding(ver,hor+3)];
                imDst(ver,hor,1) = A_R*B_R;
                imDst(ver,hor,3) = A_B*B_B;
            else
                %��״����ӦGR�е�R,Rͨ��Ϊ�˴�ֵ��Gͨ��Ϊ��Χ16��ֵ��˫���β�ֵ��Bͨ��ΪΪ��Χ16��ֵ��˫���β�ֵ
                imDst(ver,hor,1) = bayerPadding(ver,hor);
                %Ȩ������
                A=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                C=[sw(1.5);sw(0.5);sw(0.5);sw(1.5)];
                %16��B������
                    B=[bayerPadding(ver-3,hor-3) bayerPadding(ver-3,hor-1) bayerPadding(ver-3,hor+1) bayerPadding(ver-3,hor+3)
                       bayerPadding(ver-1,hor-3) bayerPadding(ver-1,hor-1) bayerPadding(ver-1,hor+1) bayerPadding(ver-1,hor+3)
                       bayerPadding(ver+1,hor-3) bayerPadding(ver+1,hor-1) bayerPadding(ver+1,hor+1) bayerPadding(ver+1,hor+3)
                       bayerPadding(ver+3,hor-3) bayerPadding(ver+3,hor-1) bayerPadding(ver+3,hor+1) bayerPadding(ver+3,hor+3)];
               %Ȩ������
                A_G=[sw(1.5) sw(0.5) sw(0.5) sw(1.5)];
                C_G=[sw(1.5);sw(0.5);sw(0.5);sw(1.5)];
                %16��G��Ϣ������
                  B_G=[bayerPadding(ver-3,hor) bayerPadding(ver-2,hor+1) bayerPadding(ver-1,hor+2) bayerPadding(ver,hor+3)
                       bayerPadding(ver-2,hor-1) bayerPadding(ver-1,hor) bayerPadding(ver,hor+1) bayerPadding(ver+1,hor+2)
                       bayerPadding(ver-1,hor-2) bayerPadding(ver,hor-1) bayerPadding(ver+1,hor) bayerPadding(ver+2,hor+1)
                       bayerPadding(ver,hor-3) bayerPadding(ver+1,hor-2) bayerPadding(ver+2,hor-1) bayerPadding(ver+3,hor)];
                   
                imDst(ver,hor,2) =A_G*B_G*C_G ;
                imDst(ver,hor,3) = A*B*C;
            end
        else
            if(1 == mod(hor-1,2))
                %��״����ӦBG�е�B,Bͨ��Ϊ�˴�ֵ��Gͨ��Ϊ��Χ16��ֵ��˫���β�ֵ��Rͨ��ΪΪ��Χ16��ֵ��˫���β�ֵ
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
                %��״����Ӧ��GR�е�G��Gͨ��Ϊ�˴�ֵ��Rͨ��Ϊ����ֵ�����β�ֵ��Bͨ��Ϊ����ֵ�����β�ֵ
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