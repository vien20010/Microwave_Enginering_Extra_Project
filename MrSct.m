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
L=input('\nMoi nhap chieu dai duong day L= ');

%Tro khang tai ZL
ZL=input('\nMoi nhap tro khang tai ZL= ');

%vi tri diem x
x=input('\nMoi nhap vi tri can tim cac thong so x= ');
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
modun_Vx=abs(Vx)
argumen_Vx=angle(Vx)*180/pi

fprintf('dong dien tai diem x ');
Ix=Vx/Zx
modun_Ix=abs(Ix)
argumen_Ix=angle(Ix)*180/pi

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
Create_Latex_File
%Xuat Input
fprintf(fileID,'Input\n\n');
fprintf(fileID,'$V_S = %6.1f V$\n\n',VS);
fprintf(fileID,'$Z_S = %6.1f \\Omega$\n\n',ZS);
fprintf(fileID,'$Z_0 = %6.1f \\Omega$\n\n',Zo);
fprintf(fileID,'$L = %6.1f  m$\n\n',L);
fprintf(fileID,'$Z_L = %6.1f + (%6.1f)i \\Omega$\n\n',real(ZL),imag(ZL));
fprintf(fileID,'\\end{document}');