clear all
train = csvread('train_full.txt');
test = csvread('test_full.txt');

fs = 500;
t_step = 1/fs;
t = 0:t_step:6-0.002;
len = size(train);
len = len(1);
N = 200;
for i=1:len
    X = fft(train(i,2:end),N);
    X = X(1:N/2); %restricts X to positive domain only
    X1 = abs(X); %magnitude
    X1 = X1(2:end);
    k = 0:(N/2)-1;
    f = (k*fs)/N; %frequency vector
    f = f(2:end);
    full = [f',X1'];
    full_sort = sortrows(full,-2);
    peaks = full_sort(1:3,1)';
    train_frequencies(i,:) = peaks;
end

for i=1:len
    X = fft(test(i,2:end),N);
    X = X(1:N/2); %restricts X to positive domain only
    X1 = abs(X); %magnitude
    X1 = X1(2:end);
    k = 0:(N/2)-1;
    f = (k*fs)/N; %frequency vector
    f = f(2:end);
    full = [f',X1'];
    full_sort = sortrows(full,-2);
    peaks = full_sort(1:3,1)';
    test_frequencies(i,:) = peaks;
end

for i=1:len
    train_means(i,1) = rms(train(i,2:end));
    test_means(i,1) = rms(test(i,2:end));
end

for i=1:len
    temp = sort(train(i,2:end),'descend');
    train_maxV(i,:) = temp(1:3);
    temp2 = sort(test(i,2:end),'descend');
    test_maxV(i,:) = temp2(1:3);
end

train_features = [train_maxV,train_frequencies,train_means,train(:,1)];
test_features = [test_maxV,test_frequencies,test_means,test(:,1)];

csvwrite('train_features.txt',train_features)
csvwrite('test_features.txt',test_features)

%{
figure
stem(f(2:end),X1(2:end)) %does not include first large spike so we can see the actual peaks more easily
title('Magnitude spectrum')
xlabel('Frequency (Hz)')
ylabel('Abs(X(f))')
%}


