function[odleglosc, odleglosc_lr] = readArrayImg(img_bin_do_por)

pathname = uigetdir();
if isequal(pathname,0)
        msgbox('U�ytkownik nacisna� anuluj');  
end

cd(pathname);

images = dir('*.jpg');
%images(1) 
len = length(dir('*.jpg'));

[x,y] = size(img_bin_do_por);
for j = 1:x 
    h_poziomy(j) = sum(img_bin_do_por(j,:));
end 
for j = 1:y 
    h_pionowy(j) = sum(img_bin_do_por(:,j));
end

h_pionowy = h_pionowy/max(h_pionowy);
h_poziomy = h_poziomy/max(h_poziomy);
h_pio = h_pionowy;
h_poz = h_poziomy;

h_suma_do_por = [h_pio((h_pio>0)) h_poz((h_poz>0))];
figure(3);
subplot(3,ceil(len/2),13);
imshow(img_bin_do_por);
title('Badany obiekt');
for i=1:len 

    array(:,:,i) = imread(images(i).name);
    
    img_bin = array(:,:,i);
    
    subplot(3,ceil(len/2),i);
    imshow(img_bin);
    title(num2str(i));
    [x,y] = size(img_bin);
    for j = 1:x 
        h_poziomy(j,i) = sum(img_bin(j,:));
    end 
    for j = 1:y 
        h_pionowy(j,i) = sum(img_bin(:,j));
    end
    h_pionowy(:,i) = h_pionowy(:,i)/max(h_pionowy(:,i));
    h_poziomy(:,i) = h_poziomy(:,i)/max(h_poziomy(:,i));
    h_pio = h_pionowy(:,i)';
    h_poz = h_poziomy(:,i)';
    
    
    h_suma = [h_pio((h_pio>0)) h_poz((h_poz>0))];
    odleglosc(i) = dtw3(h_suma,h_suma_do_por,0);
   
    
end

cd ..


for i = 1:1:90
    img_bin_rot_l = imrotate(img_bin_do_por,-i,'bilinear','crop');
    img_bin_rot_r = imrotate(img_bin_do_por,i,'bilinear','crop');
    [x,y] = size(img_bin_rot_l);
    for j = 1:x 
        h_rot_l_poz(j) = sum(img_bin_rot_l(j,:));
        h_rot_r_poz(j) = sum(img_bin_rot_r(j,:));
    end 
    for j = 1:y 
        h_rot_l_pio(j) = sum(img_bin_rot_l(:,j));
        h_rot_r_pio(j) = sum(img_bin_rot_r(:,j));
    end    
    
    h_rot_l_poz = h_rot_l_poz/max(h_rot_l_poz);
    h_rot_l_pio = h_rot_l_pio/max(h_rot_l_pio);
    h_rot_r_poz = h_rot_r_poz/max(h_rot_r_poz);
    h_rot_r_pio = h_rot_r_pio/max(h_rot_r_pio);
    
    h_suma_l = [h_rot_l_pio((h_rot_l_pio>0)) h_rot_l_poz((h_rot_l_poz>0))];
    h_suma_r = [h_rot_r_pio((h_rot_r_pio>0)) h_rot_r_poz((h_rot_r_poz>0))];
    odleglosc_l(i) = dtw3(h_suma,h_suma_l,0);
    odleglosc_r(i) = dtw3(h_suma,h_suma_r,0);
end

odleglosc_lr = [fliplr(odleglosc_l) dtw3(h_suma,h_suma,0) odleglosc_r];


end