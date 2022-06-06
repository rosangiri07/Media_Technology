

[rows, columns, numberOfColorBands] = size(A);
subplot(3, 2, 1);
imshow(A, []);
title('Original Colour Image');
%set(gcf, 'Position', get(0,'Screensize')); % MAximize figure.

redPlane = A(:, :, 1);
greenPlane = A(:, :, 2);
bluePlane = A(:, :, 3);
grayscale=rgb2gray(A);

% Let's get its histograms.
[pixelCountR, grayLevelsR] = imhist(redPlane);
subplot(3, 2, 2);
stem(pixelCountR, 'r');
title('Histogram of red plane');
xlim([0 grayLevelsR(end)]); % Scale x Axis manually. end indicates last ArrAy index

[pixelCountG, grayLevelsG] = imhist(greenPlane);
subplot(3, 2, 3);
stem(pixelCountG, 'g');
title('Histogram of green plane');
xlim([0 grayLevelsG(end)]); % Scale x Axis manually.

[pixelCountB, grayLevelsB] = imhist(bluePlane);
subplot(3, 2, 4);
stem(pixelCountB, 'b');
title('Histogram of blue plane');
xlim([0 grayLevelsB(end)]); % Scale x Axis manually.

[pixelCountgray, grayLevelsgray] = imhist(grayscale);
subplot(3, 2, 5);
stem(pixelCountgray, 'black');
title('Histogram of grayscale image');
xlim([0 grayLevelsgray(end)]); % Scale x Axis manually.