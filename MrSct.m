%
% July 30, 2020
% LV_Embedded
% Github: https://github.com/vien20010
% Email: nguyenlamvien0110@gmail.com
%

clc;
clear all;
close all;
fprintf('BAI TOAN 1\n');

%OUTPUT
%Zx Vx Ix
%Gamma_x :he so phan xa tai x
%Pinc :incident power
%Pref :reflection power
%Pt :transmitted power (time average)
%VSWR
%bung() :vi tri bung song
%nut() :vi tri nut song

%NHAP THONG SO CHO TRUOC
%Nguon VS
VS=input('Moi nhap nguon ap VS= ');

%Tro khang noi cua nguon ZS
ZS=input('\nMoi nhap tro khang nguon ZS= ');


%Tro khang dac tinh duong day Zo
Zo=input('\nMoi nhap tro khang dac tinh Zo= ');

%Chieu dai duong day
L=input('\nMoi nhap chieu dai duong day (don vi m) L= ');

%Tro khang tai ZL
ZL=input('\nMoi nhap tro khang tai ZL= ');

%vi tri diem x
x=input('\nMoi nhap vi tri can tim cac thong so (don vi m) x= ');
d=L-x;

%he so truyen tai
gamma=input('\nMoi nhap he so truyen tai (lossless: anpha=0) gamma= anpha + beta*i=');

%TINH TOAN THONG SO THEO YEU CAU
fprintf('\n Tro khang tai diem x ');
Zx=Zo*(ZL+Zo*tanh(gamma*d))/(Zo+ZL*tanh(gamma*d))

Gamma_L=(ZL-Zo)/(ZL+Zo);
Gamma_in=Gamma_L*exp(-2*gamma*L);
Zin=Zo*(1+Gamma_in)/(1-Gamma_in);
Vin=VS*Zin/(Zin+ZS);
Vo_plus=Vin/(1+Gamma_in);
Vo_minus=Gamma_in*Vo_plus;

fprintf('dien ap tai diem x ');
Vx=Vo_plus*exp(-gamma*x)+Vo_minus*exp(gamma*x)
modun_Vx=abs(Vx);
argumen_Vx=angle(Vx)*180/pi;

fprintf('dong dien tai diem x ');
Ix=Vx/Zx
modun_Ix=abs(Ix);
argumen_Ix=angle(Ix)*180/pi;

fprintf('he so phan xa tai diem x ');
Gamma_x=Gamma_L*exp(-2*gamma*d)

fprintf('incident power tai diem x ');
Pinc=(abs(Vo_plus)^2*exp(-2*real(gamma)*x))/(2*Zo)

fprintf('reflected power tai diem x ');
Pref=(abs(Vo_minus)^2*exp(2*real(gamma)*x))/(2*Zo)

fprintf('transmitted power tai diem x ');
Pt=Pinc-Pref

fprintf('he so song dung');
VSWR=(1+abs(Gamma_L))/(1-abs(Gamma_L))

a=1;
lamda=2*pi/imag(gamma);

if imag(Gamma_L)>0 | imag(Gamma_L)==0 & real(Gamma_L)>0
    d1=angle(Gamma_L)/(2*imag(gamma));
    while d1<L
        bung(a)=L-d1;
        d1=d1+lamda/4;
        if d1<L
            nut(a)=L-d1;
            d1=d1+lamda/4;
        end
        a=a+1;
    end
end

if imag(Gamma_L)<0 | imag(Gamma_L)==0 & real(Gamma_L)<0
    d1=(angle(Gamma_L)+pi)/(2*imag(gamma));
    while d1<L
        nut(a)=L-d1;
        d1=d1+lamda/4;
        if d1<L
            bung(a)=L-d1;
            d1=d1+lamda/4;
        end
        a=a+1;
    end
end

if Gamma_L==0
    fprintf('khong co song phan xa, khong xuat hien song dung');
end
 fprintf('vi tri cac bung song ');
t1=size(bung);
t2=1:t1(1,2);
bung(t2)
fprintf('vi tri cac nut song ');
t3=size(nut);
t4=1:t3(1,2);
nut(t4)

%Goi ham tao file latex fileID 

%Create_Latex_File

fileID=fopen('../Result/Exercise1.tex','w');
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
fprintf(fileID,'$V_S = %6.1f V$\n\n',VS);
fprintf(fileID,'$Z_S = %6.1f \\Omega$\n\n',ZS);
fprintf(fileID,'$Z_0 = %6.1f \\Omega$\n\n',Zo);
fprintf(fileID,'$L = %6.1f  m$\n\n',L);
fprintf(fileID,'$Z_L = %6.1f + (%6.1f)i \\Omega$\n\n',real(ZL),imag(ZL));
fprintf(fileID,'Vi tri can tim $x = %6.2f$ m\n\n',x);
fprintf(fileID,'He so truyen tai $\\gamma=\\alpha+i\\beta=%6.2f + %6.2fi$\n\n',real(gamma),imag(gamma));
%Xuat Output
fprintf(fileID,'Output\n\n');
fprintf(fileID,'$Z_x = %6.4f + %6.4fi \\Omega$\n\n',real(Zx),imag(Zx));
fprintf(fileID,'$V_x = %6.4f + %6.4fi V$\n\n',real(Vx),imag(Vx));
fprintf(fileID,'$I_x = %6.4f + %6.4fi A$\n\n',real(Ix),imag(Ix));
fprintf(fileID,'$\\Gamma_x = %6.4f + %6.4fi $\n\n',real(Gamma_x),imag(Gamma_x));
fprintf(fileID,'$P_{inc} = %6.4f W$\n\n',Pinc);
fprintf(fileID,'$P_{refl} = %6.4f W$\n\n',Pref);
fprintf(fileID,'$P_t = %6.4f W$\n\n',Pt);
fprintf(fileID,'$VSWR = %6.4f$\n\n',VSWR);
fprintf(fileID,'$V_{max}$ location \n\n');
fprintf(fileID,'$');
fprintf(fileID,'%s',latex(vpa(sym(bung),6)));
fprintf(fileID,'$\n\n');

fprintf(fileID,'$V_{min}$ location \n\n');
fprintf(fileID,'$');
fprintf(fileID,'%s',latex(vpa(sym(nut),6)));
fprintf(fileID,'$\n\n');
fprintf(fileID,'\\end{document}');