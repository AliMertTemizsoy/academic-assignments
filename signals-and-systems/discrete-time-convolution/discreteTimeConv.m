% Ali Mert Temizsoy 23011018

% ÖDEV PART 1 ----------------------------------------------------------------------------------------

firstLength = input('İlk ayrık zamanlı işaretin boyutunu giriniz: '); % İlk ayrık zamanlı işaretin boyutu
firstStart = input('İlk ayrık zamanlı işaretin başlangıç zamanını giriniz: '); % İlk ayrık zamanlı işaretin başlangıç zamanı
firstEnd = input('İlk ayrık zamanlı işaretin bitiş zamanını giriniz: '); % İlk ayrık zamanlı işaretin bitiş zamanı

x = zeros(1, firstLength); % İlk ayrık zamanlı işaretin dizisi

% kullanıcıdan dizinin elemanlarını alıyoruz
for i = 1:firstLength
    x(i) = input(sprintf('x[%d] elemanını giriniz: ', firstStart + i - 1));
end 

secondLength = input('İkinci ayrık zamanlı işaretin boyutunu giriniz: '); % İkinci ayrık zamanlı işaretin boyutu
secondStart = input('İkinci ayrık zamanlı işaretin başlangıç zamanını giriniz: '); % İkinci ayrık zamanlı işaretin başlangıç zamanı
secondEnd = input('İkinci ayrık zamanlı işaretin bitiş zamanını giriniz: '); % İkinci ayrık zamanlı işaretin bitiş zamanı

y = zeros(1, secondLength); % İkinci ayrık zamanlı işaretin dizisi

% kullanıcıdan dizinin elemanlarını alıyoruz
for i = 1:secondLength 
    y(i) = input(sprintf('y[%d] elemanını giriniz: ', secondStart + i - 1));
end

% Konvolüsyon hesaplaması
answer = myConv(x, firstLength, y, secondLength);

% Konvolüsyon sonucu
disp('Konvolüsyon sonucu:');
disp(answer);

% n=0 konumundaki değeri bulmak için başlangıç ve bitiş zamanlarını kullanıyoruz
zeroIndex = abs(firstStart) + abs(secondStart) + 1;  % n=0 konumunun indeksi
disp('n=0 konumundaki değer: ');
disp(answer(zeroIndex));

% ÖDEV PART 2 ----------------------------------------------------------------------------------------

% Dataset 1
x_1 = [2 1 7 1 5]; % x1 dizisi
y_1 = [6 1 2]; % y1 dizisi

n = length(x_1); % x1 dizisinin boyutu
m = length(y_1); % y1 dizisinin boyutu

x1Start = -2; % x1 dizisinin başlangıç zamanı
y1Start = 1; % y1 dizisinin başlangıç zamanı    

% Dataset 2
x_2 = [1 2 3 1]; % x2 dizisi
y_2 = [4 1 1 2]; % y2 dizisi

k = length(x_2); % x2 dizisinin boyutu
l = length(y_2); % y2 dizisinin boyutu
x2Start = -1; % x2 dizisinin başlangıç zamanı
y2Start = 0; % y2 dizisinin başlangıç zamanı

% Konvolüsyon hesaplamaları

answer1 = myConv(x_1, n, y_1, m); % x1 ve y1 dizileri için benim fonksiyonumdan gelen konvolüsyon sonucu
zeroIndex1 = abs(x1Start) + abs(y1Start) + 1; % n=0 konumunun indeksi
convStart1 = x1Start + y1Start; % Konvolüsyon başlangıç zamanı
convTime1 = convStart1:convStart1+n+m-2; % Konvolüsyon zamanı

answer2 = myConv(x_2, k, y_2, l); % x2 ve y2 dizileri için benim fonksiyonumdan gelen konvolüsyon sonucu
zeroIndex2 = abs(x2Start) + abs(y2Start) + 1; % n=0 konumunun indeksi
convStart2 = x2Start + y2Start; % Konvolüsyon başlangıç zamanı
convTime2 = convStart2:convStart2+k+l-2; % Konvolüsyon zamanı

readyAnswer1 = conv(x_1, y_1); % x1 ve y1 dizileri için hazır MATLAB konvolüsyon sonucu
readyZeroIndex1 = abs(x1Start) + abs(y1Start) + 1; % n=0 konumunun indeksi
readyConvStart1 = x1Start + y1Start; % Konvolüsyon başlangıç zamanı
readyConvTime1 = readyConvStart1:readyConvStart1+n+m-2; % Konvolüsyon zamanı

readyAnswer2 = conv(x_2, y_2); % x2 ve y2 dizileri için hazır MATLAB konvolüsyon sonucu
readyZeroIndex2 = abs(x2Start) + abs(y2Start) + 1; % n=0 konumunun indeksi
readyConvStart2 = x2Start + y2Start; % Konvolüsyon başlangıç zamanı
readyConvTime2 = readyConvStart2:readyConvStart2+k+l-2; % Konvolüsyon zamanı

% Grafiklerin çizimi

% Dataset 1 için grafikler
figure;
t = tiledlayout(2,2);
title(t, 'Dataset 1 için Konvolüsyon Grafik Sonuçları');

% x1 dizisinin grafiği
nexttile
stem(x1Start:x1Start+n-1, x_1, 'r', 'LineWidth', 2);
title('x1 Dizisi');
ylabel('x1[n]');
xlabel('n');

% y1 dizisinin grafiği
nexttile
stem(y1Start:y1Start+m-1, y_1, 'b', 'LineWidth', 2);
title('y1 Dizisi');
ylabel('y1[n]');
xlabel('n');

%Benim konvolüsyon sonucumun grafiği
nexttile
stem(convTime1, answer1, 'g', 'LineWidth', 2);
title('Benim fonksiyonumdan gelen konvolüsyon sonucu');
ylabel('y[n]');
xlabel('n');

% hazır MATLAB konvolüsyon sonucunun grafiği
nexttile
stem(readyConvTime1, readyAnswer1, 'm', 'LineWidth', 2);
title('MATLAB hazır fonksiyonundan gelen konvolüsyon sonucu');
ylabel('y[n]');
xlabel('n');

% Dataset 2 için grafikler
figure;
t = tiledlayout(2,2);
title(t, 'Dataset 2 için Konvolüsyon Grafik Sonuçları');

% x2 dizisinin grafiği
nexttile    
stem(x2Start:x2Start+k-1, x_2, 'r', 'LineWidth', 2);
title('x2 Dizisi');
ylabel('x2[n]');
xlabel('n');

% y2 dizisinin grafiği
nexttile
stem(y2Start:y2Start+l-1, y_2, 'b', 'LineWidth', 2);
title('y2 Dizisi');
ylabel('y2[n]');
xlabel('n');

% Benim konvolüsyon sonucumun grafiği
nexttile
stem(convTime2, answer2, 'g', 'LineWidth', 2);
title('Benim fonksiyonumdan gelen konvolüsyon sonucu');
ylabel('y[n]');
xlabel('n');

% hazır MATLAB konvolüsyon sonucunun grafiği
nexttile
stem(readyConvTime2, readyAnswer2, 'm', 'LineWidth', 2);
title('MATLAB hazır fonksiyonundan gelen konvolüsyon sonucu');
ylabel('y[n]');
xlabel('n');

% Vektörel gösterim için dizileri ve konvolüsyon sonuçlarını yazdırma
fprintf('\n--- VEKTÖREL GÖSTERİM ---\n\n');

% Dataset 1 için dizileri ve konvolüsyon sonuçlarını yazdırma
fprintf('DataSet 1 için:\n\n');

% x1 dizisi
fprintf('x1 dizisi: ');
fprintf('İndisler (n): ');
for i = x1Start:x1Start+n-1
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:n
    fprintf('%d ', x_1(i));
end

fprintf('\n\n');

% y1 dizisi
fprintf('y1 dizisi: ');
fprintf('İndisler (n): ');
for i = y1Start:y1Start+m-1
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:m
    fprintf('%d ', y_1(i));
end
fprintf('\n\n');

% Benim konvolüsyon sonucumun dizisi
fprintf('Benim Fonksiyonumun Konvolüsyon sonucu: ');
fprintf('İndisler (n): ');

for i = convStart1:convStart1+n+m-2
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:n+m-1
    fprintf('%d ', answer1(i));
end

% Hazır MATLAB konvolüsyon sonucunun dizisi
fprintf('\n\n');
fprintf('Hazır MATLAB konvolüsyon sonucu: ');
fprintf('İndisler (n): ');
for i = readyConvStart1:readyConvStart1+n+m-2
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:n+m-1
    fprintf('%d ', readyAnswer1(i));
end

fprintf('\n\n');

% Dataset 2 için dizileri ve konvolüsyon sonuçlarını yazdırma
fprintf('DataSet 2 için:\n\n');

% x2 dizisi
fprintf('x2 dizisi: ');
fprintf('İndisler (n): ');
for i = x2Start:x2Start+k-1
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:k
    fprintf('%d ', x_2(i));
end

fprintf('\n\n');

% y2 dizisi
fprintf('y2 dizisi: ');
fprintf('İndisler (n): ');
for i = y2Start:y2Start+l-1
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:l
    fprintf('%d ', y_2(i));
end

fprintf('\n\n');

% Benim konvolüsyon sonucumun dizisi
fprintf('Benim Fonksiyonumun Konvolüsyon sonucu: ');
fprintf('\nİndisler (n): ');
for i = convStart2:convStart2+k+l-2
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:k+l-1
    fprintf('%d ', answer2(i));
end

fprintf('\n\n');

% Hazır MATLAB konvolüsyon sonucunun dizisi
fprintf('Hazır MATLAB konvolüsyon sonucu: ');
fprintf('İndisler (n): ');
for i = readyConvStart2:readyConvStart2+k+l-2
    fprintf('%d ', i);
end

fprintf('\nDeğerler: ');
for i = 1:k+l-1
    fprintf('%d ', readyAnswer2(i));
end

fprintf('\n\n');

% ÖDEV PART 3 ve 4 ----------------------------------------------------------------------------------------

% 5 Saniye Ses kaydetme
recObj = audiorecorder; %% kayıt başlatma nesnesi
disp('Start speaking.') %% ekrana mesaj
recordblocking(recObj, 5); %% kayıt işlemi - süre 5 saniye
disp('End of Recording.'); %% ekrana mesaj
X1 = getaudiodata(recObj)'; %% kaydedilen sesi X1 değişkenine saklama
% myConv fonksiyonuna uygun hale getirmek için transpoze ettik

% 10 Saniye Ses kaydetme
recObj = audiorecorder; %% kayıt başlatma nesnesi
disp('Start speaking.') %% ekrana mesaj
recordblocking(recObj, 10); %% kayıt işlemi - süre 10 saniye
disp('End of Recording.'); %% ekrana mesaj
X2 = getaudiodata(recObj)'; %% kaydedilen sesi X2 değişkenine saklama
% myConv fonksiyonuna uygun hale getirmek için transpoze ettik

A = 0.5; % A sabiti

% Birim impuls ile çarpma yöntemiyle impuls cevabını hesaplama
% M=3 için dürtü yanıtı
M1 = 3;
maxElement1 = 400*M1;  % En büyük gecikme değeri
delta = zeros(1, maxElement1+1);  % Birim impuls girişi
delta(1) = 1;  % delta[0] = 1 (MATLAB'da indeksler 1'den başlar)

% Sistem denklemini birim impuls ile çözerek h[n]'i hesaplama
myY1 = zeros(1, maxElement1+1);  % h[n] için dizi
for n = 0:maxElement1
    idx = n + 1;  % MATLAB indeksleri 1'den başlar
    myY1(idx) = delta(idx);  % delta[n] terimi
    for k = 1:M1
        if (n - 400*k) >= 0
            delta_idx = (n - 400*k) + 1;  % delta[n-400*k] için indeks
            myY1(idx) = myY1(idx) + A*k*delta(delta_idx);
        end
    end
end

% M=4 için dürtü yanıtı
M2 = 4;
maxElement2 = 400*M2;  % En büyük gecikme değeri
delta = zeros(1, maxElement2+1);  % Birim impuls girişi
delta(1) = 1;  % delta[0] = 1

% Sistem denklemini birim impuls ile çözerek h[n]'i hesaplama
myY2 = zeros(1, maxElement2+1);
for n = 0:maxElement2
    idx = n + 1; % MATLAB indeksleri 1'den başlar
    myY2(idx) = delta(idx); % delta[n] terimi
    for k = 1:M2
        if (n - 400*k) >= 0
            delta_idx = (n - 400*k) + 1; % delta[n-400*k] için indeks
            myY2(idx) = myY2(idx) + A*k*delta(delta_idx);
        end
    end
end

% M=5 için dürtü yanıtı
M3 = 5;
maxElement3 = 400*M3;  % En büyük gecikme değeri
delta = zeros(1, maxElement3+1);  % Birim impuls girişi
delta(1) = 1;  % delta[0] = 1

% Sistem denklemini birim impuls ile çözerek h[n]'i hesaplama
myY3 = zeros(1, maxElement3+1);
for n = 0:maxElement3
    idx = n + 1; % MATLAB indeksleri 1'den başlar
    myY3(idx) = delta(idx); % delta[n] terimi
    for k = 1:M3
        if (n - 400*k) >= 0
            delta_idx = (n - 400*k) + 1; % delta[n-400*k] için indeks
            myY3(idx) = myY3(idx) + A*k*delta(delta_idx);
        end
    end
end

% Konvolüsyon işlemleri
myFuncX1ForM1 = myConv(X1, length(X1), myY1, length(myY1)); % X1 girdisi ve M=3 için kendi hesapladığım konvolüsyon sonucu
myFuncX1ForM2 = myConv(X1, length(X1), myY2, length(myY2)); % X1 girdisi ve M=4 için kendi hesapladığım konvolüsyon sonucu
myFuncX1ForM3 = myConv(X1, length(X1), myY3, length(myY3)); % X1 girdisi ve M=5 için kendi hesapladığım konvolüsyon sonucu
myFuncX2ForM1 = myConv(X2, length(X2), myY1, length(myY1)); % X2 girdisi ve M=3 için kendi hesapladığım konvolüsyon sonucu
myFuncX2ForM2 = myConv(X2, length(X2), myY2, length(myY2)); % X2 girdisi ve M=4 için kendi hesapladığım konvolüsyon sonucu
myFuncX2ForM3 = myConv(X2, length(X2), myY3, length(myY3)); % X2 girdisi ve M=5 için kendi hesapladığım konvolüsyon sonucu

readyFuncX1ForM1 = conv(X1, myY1); % X1 girdisi ve M=3 için hazır MATLAB konvolüsyon sonucu
readyFuncX1ForM2 = conv(X1, myY2); % X1 girdisi ve M=4 için hazır MATLAB konvolüsyon sonucu
readyFuncX1ForM3 = conv(X1, myY3); % X1 girdisi ve M=5 için hazır MATLAB konvolüsyon sonucu
readyFuncX2ForM1 = conv(X2, myY1); % X2 girdisi ve M=3 için hazır MATLAB konvolüsyon sonucu
readyFuncX2ForM2 = conv(X2, myY2); % X2 girdisi ve M=4 için hazır MATLAB konvolüsyon sonucu
readyFuncX2ForM3 = conv(X2, myY3); % X2 girdisi ve M=5 için hazır MATLAB konvolüsyon sonucu

%İlk önce giriş sinyali dinlenir

disp('X1 sinyali dinleniyor...');
sound(X1); % X1 ses kaydını dinletme
pause(5); % 5 saniye bekleme süresi
disp('X2 sinyali dinleniyor...');
sound(X2); % X2 ses kaydını dinletme
pause(10); % 10 saniye bekleme süresi

% Konvolüsyon sonuçları dinletilir
disp('Konvolüsyon sonuçları dinletiliyor...');
disp('X1 girdisi sonuçları...');

disp('M=3 için benim hesapladığım konvolüsyon sonucu dinleniyor...');
sound(myFuncX1ForM1); % X1 ve M=3 için benim fonksiyonumun h1 konvolüsyonunu dinletme
pause(7); % 7 saniye bekleme süresi

disp('M=3 için hazır MATLAB konvolüsyon sonucu dinleniyor...');
sound(readyFuncX1ForM1); % X1 ve M=3 için hazır MATLAB konvolüsyonunu dinletme
pause(7); % 7 saniye bekleme süresi

disp('M=4 için benim hesapladığım konvolüsyon sonucu dinleniyor...');
sound(myFuncX1ForM2); % X1 ve M=4 için benim fonksiyonumun h2 konvolüsyonu dinletme
pause(7); % 7 saniye bekleme süresi

disp('M=4 için hazır MATLAB konvolüsyon sonucu dinleniyor...');
sound(readyFuncX1ForM2); % X1 ve M=4 için hazır MATLAB konvolüsyonu dinletme
pause(7); % 7 saniye bekleme süresi

disp('M=5 için benim hesapladığım konvolüsyon sonucu dinleniyor...');
sound(myFuncX1ForM3); % X1 ve M=5 için benim fonksiyonumun h3 konvolüsyonu dinletme
pause(7); % 7 saniye bekleme süresi

disp('M=5 için hazır MATLAB konvolüsyon sonucu dinleniyor...');
sound(readyFuncX1ForM3); % X1 ve M=5 için hazır MATLAB konvolüsyonu dinletme
pause(7); % 7 saniye bekleme süresi

disp('X2 girdisi sonuçları...');

disp('M=3 için benim hesapladığım konvolüsyon sonucu dinleniyor...');
sound(myFuncX2ForM1); % X2 ve M=3 için benim fonksiyonumun h1 konvolüsyonu dinletme
pause(12); % 12 saniye bekleme süresi

disp('M=3 için hazır MATLAB konvolüsyon sonucu dinleniyor...');
sound(readyFuncX2ForM1); % X2 ve M=3 için hazır MATLAB konvolüsyonu dinletme
pause(12); % 12 saniye bekleme süresi

disp('M=4 için benim hesapladığım konvolüsyon sonucu dinleniyor...');
sound(myFuncX2ForM2); % X2 ve M=4 için benim fonksiyonumun h2 konvolüsyonu dinletme
pause(12); % 12 saniye bekleme süresi

disp('M=4 için hazır MATLAB konvolüsyon sonucu dinleniyor...');
sound(readyFuncX2ForM2); % X2 ve M=4 için hazır MATLAB konvolüsyonu dinletme
pause(12); % 12 saniye bekleme süresi

disp('M=5 için benim hesapladığım konvolüsyon sonucu dinleniyor...');
sound(myFuncX2ForM3); % X2 ve M=5 için benim fonksiyonumun h3 konvolüsyonu dinletme
pause(12); % 12 saniye bekleme süresi

disp('M=5 için hazır MATLAB konvolüsyon sonucu dinleniyor...');
sound(readyFuncX2ForM3); % X2 ve M=5 için hazır MATLAB konvolüsyonu dinletme

% Konvolüsyon hesaplaması için kullandığım fonksiyon - myConv
function [answer] = myConv(x, n, y, m)
    % Konvolüsyon hesaplaması için y dizisini tersine çeviriyoruz
    y = fliplr(y);

    tempZeros = zeros(1, m - 1); % Geçici sıfır dizisi oluşturuyoruz
    tempX = [tempZeros x tempZeros]; 
    % Y dizisi X dizisinin altında kayacağı için geçici bir X dizisi oluşturup sağına ve soluna 0 ekliyoruz
    lengthTemp = length(tempZeros) + length(x); % Geçici dizinin uzunluğunu hesaplıyoruz

    % Konvolüsyon sonucu için dizi oluşturuyoruz
    answer = zeros(1, n + m - 1);
    
    % Konvolüsyon hesaplaması
    for i = 1:lengthTemp
        for j = 1:m
            answer(i) = answer(i) + tempX(i+j-1) * y(j);
        end
    end
end