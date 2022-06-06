% input image
input_matrix = rgb2gray(imread('/Users/Roshan/Creative Cloud Files/download1.bmp'));
[rows, cols] = size(input_matrix);

% rotation
degree = 15;
radians = (pi * degree) / 180; 
theta = radians;

% output matrix
t_matrix = uint8(zeros(rows,cols));
t_matrix2 = uint8(zeros(rows,cols));
t_matrix3 = uint8(zeros(rows,cols));

% transformation matrix
T = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 1; 0 0 1];

% inverse transformation matrix
IVT=inv(T);

% loop over each input_matrix coordinate
for n = 1:numel(input_matrix)
    % current coordinate
    [x, y] = ind2sub([rows cols], n);
    v = [x;y;1];

    % homogeneous coordinate
    v = T*v;
    
    % only integer values
    a = floor(v(1));
    b = floor(v(2));

    if a > 0 && b > 0
        % replace in t_matrix
        t_matrix(a,b) = input_matrix(x,y);
    end
end

for n = 1:numel(t_matrix)

    % current coordinate
    [x, y] = ind2sub([rows cols], n);

    % transpose
    v = [x;y;1];

    % homogeneous coordinate
    v = IVT*v;

    % only integer values
    a = floor(v(1));
    b = floor(v(2));

    if rows>a && a > 0 && cols>b && b > 0
        % replace in t_matrix
        t_matrix2(x,y) = input_matrix(a,b);
    end
end

for n = 1:numel(t_matrix)

    % current coordinate
    [x, y] = ind2sub([rows cols], n);

    % transpose
    v = [x;y;1];

    % homogeneous coordinate
    v = IVT*v;
    a=v(1);
    b=v(2);

    a1 = floor(a);
    a2 = ceil(a);
    b1 = floor(b);
    b2 = ceil(b);
    
    if rows>a2 && a1 > 0 && cols>b2 && b1 > 0
    
    z11=double(input_matrix(a1,b1));
    z12=double(input_matrix(a1,b2));
    z21=double(input_matrix(a2,b1));
    z22=double(input_matrix(a2,b2));
    
    z1=z11+(b-b1)*(z12-z11)/(b2-b1);
    z2=z21+(b-b1)*(z22-z21)/(b2-b1);
    z=z1+(z2-z1)*(a-a1)/(a2-a1);

    t_matrix3(x,y) = uint8(z);
    
    end
end

figure(1); imshow(input_matrix); % original image
figure(2); imshow(t_matrix);
figure(3); imshow(t_matrix2);
figure(4); imshow(t_matrix3);