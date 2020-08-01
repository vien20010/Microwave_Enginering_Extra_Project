%
% July 30, 2020
% LV_Embedded
% Github: https://github.com/vien20010
% Email: nguyenlamvien0110@gmail.com
%

clc;
clear all;
close all;
fprintf('BAI TOAN 2\n');
sm1=smithchart;

%OUTPUT
%ZL - gamma_ZL
%YL - gamma_YL
%a, b :giao diem cua vong tron dang vswr va vong tron dang r=1 (dung de tim
%impedance matching) - denormalized
%X, Y :thong so phan tu tap trung can dung (lumped elements)
%Sa, Sb :X, Y duoc chuan hoa voi tro khang dac tinh Z1 (stub-line)

%NHAP THONG SO CHO TRUOC
%Tro khang dac tinh duong day Zo
Zo=input('\nMoi nhap tro khang dac tinh Zo= ');

%Tro khang tai ZL
ZL=input('\nMoi nhap tro khang tai ZL= ');

%tan so f
f=input('\nMoi nhap tan so f= ');
beta=2*pi*f/3e8;

%Tro khang dac tinh day chem Z1
Z1=input('\nMoi nhap tro khang dac tinh day chem ngan mach Z1= ');

%MATCHING IMPEDANCE WITH PARALLEL LUMPED ELEMENTS
fprintf('MATCHING IMPEDANCE WITH PARALLEL LUMPED ELEMENTS\n');

gamma_ZL=(ZL-Zo)/(ZL+Zo); 
gamma_YL=-gamma_ZL;

%ve vong tron dang r=1
z=Zo+Zo*i*(-20:0.1:20);
gamma=z2gamma(z,Zo);
hold all;
dang_r1=smithchart(gamma);

%ve vong tron dang VSWR (lossless)
r=abs(gamma_ZL); 
alpha=0:2*pi/100:2*pi;                                       
hold all;
dang_vswr=plot(gca,r*cos(alpha),r*sin(alpha),'-','LineWidth',.5,'Color',[1 .2 0],'DisplayName','dang vswr');

%ve ZL va YL
hold all;
plot(gca,real(gamma_ZL),imag(gamma_ZL),'ro','LineWidth',1.5,'DisplayName','ZL');
hold all;
plot(gca,real(gamma_YL),imag(gamma_YL),'bo','LineWidth',1.5,'DisplayName','YL');

%tim giao diem giua vong tron dang VSWR va dang r=1
[xi,yi] = polyxpoly(dang_r1.XData,dang_r1.YData,dang_vswr.XData,dang_vswr.YData);
a = xi(1,1) + yi(1,1)*i;
hold all;
plot(gca,real(a),imag(a),'go','LineWidth',1.5,'DisplayName','match imp 1');
b = xi(2,1) + yi(2,1)*i;
hold all;
plot(gca,real(b),imag(b),'co','LineWidth',1.5,'DisplayName','match imp 2');


%tinh toan vi tri phan tu tap trung dat cach tai
if imag(gamma_YL)>0
    d1=(angle(gamma_YL)-angle(a))/(4*pi);
    d2=(angle(gamma_YL)-angle(b))/(4*pi);
elseif imag(gamma_YL)<0
    d1=((2*pi)+angle(gamma_YL)-angle(a))/(4*pi);
    d2=((2*pi)+(angle(gamma_YL)-angle(b)))/(4*pi);
end

%tim phan tu can su dung (cuon cam hay tu dien)
a1=gamma2z(a,Zo)/Zo;
X=-imag(a1); 
if X<0
    L=-Zo/(2*pi*f*X);
    fprintf('phan tu cuon cam %d henry',L);
    fprintf(' dat cach tai %d lambda\n',d1);
elseif X>0
    C=X/(2*pi*f*Zo);
    fprintf('phan tu tu dien %d fara',C);
    fprintf(' dat cach tai %d lambda\n',d1);
end
plot(gca,real(z2gamma(X*Zo*i)),imag(z2gamma(X*Zo*i)),'g*','LineWidth',1.5,'DisplayName','lumped ele1');

b1=gamma2z(b,Zo)/Zo;
Y=-imag(b1); 
if Y<0
    L=-Zo/(2*pi*f*Y);
    fprintf('phan tu cuon cam %d henry',L);
    fprintf(' dat cach tai %d lambda\n',d2);
elseif Y>0
    C=Y/(2*pi*f*Zo);
    fprintf('phan tu tu dien %d fara',C);
    fprintf(' dat cach tai %d lambda\n',d2);
end
plot(gca,real(z2gamma(Y*Zo*i)),imag(z2gamma(Y*Zo*i)),'c*','LineWidth',1.5,'DisplayName','lumped ele2');
%MATCHING IMPEDANCE WITH PARALLEL SHORTED STUB LINE Z1
fprintf('MATCHING IMPEDANCE WITH PARALLEL SHORTED STUB LINE Z1\n');
Sa= z2gamma(X*Zo*i,Z1);
Sb= z2gamma(Y*Zo*i,Z1);

if imag(Sa)<0
    l1=-angle(Sa)/(4*pi);
elseif imag(Sa)>0
    l1=(2*pi-angle(Sa))/(4*pi);
end
fprintf('doan day chem ngan mach chieu dai %d lambda',l1);
fprintf(' dat cach tai %d lambda\n',d1);
plot(gca,real(Sa),imag(Sa),'g+','LineWidth',1.5,'DisplayName','shorted stub Z1 1');

if imag(Sb)<0
    l2=-angle(Sb)/(4*pi);
elseif imag(Sb)>0
    l2=(2*pi-angle(Sb))/(4*pi);
end
fprintf('doan day chem ngan mach chieu dai %d lambda',l2);
fprintf(' dat cach tai %d lambda\n',d2);
plot(gca,real(Sb),imag(Sb),'c+','LineWidth',1.5,'DisplayName','shorted stub Z1 2');

legend('r=1')
saveas(gca,'../Result/SmithChart.fig');
saveas(gca,'../Result/SmithChart.png');

%Goi ham tao file latex fileID 

%Create_Latex_File

fileID=fopen('../Result/Exercise2.tex','w');
fprintf(fileID,'\\documentclass[13pt,a4paper]{article}\n');
fprintf(fileID,'\\usepackage[utf8]{vietnam}\n');
fprintf(fileID,'\\usepackage{amsmath}\n');
fprintf(fileID,'\\usepackage{amsfonts}\n');
fprintf(fileID,'\\usepackage{amssymb}\n');
fprintf(fileID,'\\usepackage{graphicx}\n');
fprintf(fileID,'\\usepackage[left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}\n');
fprintf(fileID,'\\usepackage[unicode]{hyperref}\n');
fprintf(fileID,'\\setlength{\\parindent}{0pt}\n');
fprintf(fileID,'\\begin{document}\n');

%Xuat Input

fprintf(fileID,'Input\n\n');
fprintf(fileID,'$Z_0 = %6.1f \\Omega$\n\n',Zo);
fprintf(fileID,'$Z_L = %6.1f + (%6.1f)i \\Omega$\n\n',real(ZL),imag(ZL));
fprintf(fileID,'$ f = %6.1f Hz$\n\n',f);
fprintf(fileID,'Tro khang dac tinh cua day chem ngan mach: $Z_1 = %6.1f$\n\n',Z1);

%Xuat Output

fprintf(fileID,'Output\n\n');
fprintf(fileID,'Matching Impedance with parallel lumped elements:\n\n');
fprintf(fileID,'$ L = %6.4f nH, d = %6.4f \\lambda$\n\n',L*10^9,d1);
fprintf(fileID,'$ C = %6.4f nF, d= %6.4f \\lambda$\n\n',C*10^9,d2);
fprintf(fileID,'Matching impedance with parallel shorted stub line Z1\n\n');
fprintf(fileID,'$ l = %6.4f \\lambda, d = %6.4f \\lambda$\n\n',l1,d1);
fprintf(fileID,'$ l = %6.4f \\lambda, d = %6.4f \\lambda$\n\n',l2,d2);
fprintf(fileID,' \\includegraphics{SmithChart}\n\n');

fprintf(fileID,'\\end{document}');
