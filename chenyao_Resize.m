
function g1 = chenyao_Resize(ff,m,n,k)
f=zeros(m,n);      %����ɫͼ��ffת��Ϊ�ڰ�ͼ��f
g1 =zeros(k*m,k*n);  
for i=1:m
    for j=1:n
        f(i,j)=ff(i,j);
    end
end
a=f(1,:);c=f(m,:);             %������ֵͼ�����ǰ�����չ��������,����չ��������
b=[f(1,1),f(1,1),f(:,1)',f(m,1),f(m,1)];d=[f(1,n),f(1,n),f(:,n)',f(m,n),f(m,n)];
a1=[a;a;f;c;c];
a1';
b1=[b;b;a1';d;d];
f=b1';f1=double(f);
for i=1:k*m                 %����˫���β�ֵ��ʽ����ͼ���������ظ�ֵ
  u=rem(i,k)/k; i1=floor(i/k)+2;
  A=[sw(1+u) sw(u) sw(1-u) sw(2-u)];   
  for j=1:k*n
    v=rem(j,k)/k;j1=floor(j/k)+2;
    C=[sw(1+v);sw(v);sw(1-v);sw(2-v)];
    B=[f1(i1-1,j1-1) f1(i1-1,j1) f1(i1-1,j1+1) f1(i1-1,j1+2)
      f1(i1,j1-1)   f1(i1,j1)   f1(i1,j1+1)   f1(i1,j1+2)
      f1(i1,j1-1)   f1(i1+1,j1) f1(i1+1,j1+1) f1(i1+1,j1+2)
      f1(i1+2,j1-1) f1(i1+2,j1) f1(i1+2,j1+1) f1(i1+2,j1+2)];
    g1(i,j)=(A*B*C);
  end
end
