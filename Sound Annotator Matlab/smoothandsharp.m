clc
clear all;
% input image
orig = imread('/Users/Roshan/Creative Cloud Files/moon.jpg');
[rows, cols] = size(orig);
imshow(orig);

newimg=uint8(zeros(rows,cols));

%filter1=[0 1 0;1 -4 1; 0 1 0];
%filter1=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9;];
%filter1=[-1 -1 -1;-1 9 -1; -1 -1 -1];
filter1=[0 -1 0;-1 5 -1; 0 -1 0];
[frows, fcols] = size(filter1);
xmarg=(frows-1)/2;
ymarg=(fcols-1)/2;
%add black margin
olddog=uint8(zeros(rows+frows-1,cols+fcols-1));
olddog((1+xmarg):(xmarg+rows),(1+ymarg):(ymarg+cols))=orig;
figure(1),imshow(olddog);

for n = 1:numel(newimg)
    % current coordinate
    [x, y] = ind2sub([rows cols], n);
    oldpiece=olddog(x:(x+2*ymarg),y:(y+2*xmarg));
    sumup=sum(sum(double(oldpiece).*filter1));
    newimg(x,y)=sum(sumup);
end
imshow(newimg);
figure(2),imshow(uint8(orig-newimg));