%create the cam object

cam = webcam('HP Truevision HD');
n = 0;
m = 20; %no of times the loop will run

while(n <= m )

%capture image
im = snapshot(cam);

%seperate layers

R=im(:,:,1);
G=im(:,:,2);
B=im(:,:,3);

%plot original image

subplot(2,2,1);
imshow(im);
title('Original');

%get the size of image

[r,c,~]=size(R);

%binarize Green layer

binGreen=zeros(r,c);
for i=1:r
    for j=1:c
        if R(i,j)<=100 && G(i,j)>=100&&B(i,j)<=100
            binGreen(i,j)=255;
        end
    end
end

%filter noise

binGreenfilter = bwareaopen(binGreen,6000);

%plot Green layer

subplot(2,2,4);
imshow(binGreenfilter);
title('Green');

%binarize Blue layer

binBlue=zeros(r,c);
for i=1:r
    for j=1:c
        if R(i,j)<=40 && G(i,j)<=100&&B(i,j)>=120
            binBlue(i,j)=255;
        end
    end
end

%filter noise

binBluefilter  = bwareaopen(binBlue,6000);

%plot Blue layer

subplot(2,2,3);
imshow(binBluefilter);
title('Blue');

%binarize Red layer

binRed=zeros(r,c);
for i=1:r
    for j=1:c
        if R(i,j)>=100 && G(i,j)<=80&&B(i,j)<=80
            binRed(i,j)=255;
        end
    end
end

%filter noise

binRedfilter  = bwareaopen(binRed,6000);

%plot Red layer

subplot(2,2,2);
imshow(binRedfilter);
title('Red');

%get the areas of differnt layers

bluearea = bwarea(binBluefilter);
redarea = bwarea(binRedfilter);
greenarea = bwarea(binGreenfilter);


%area Comaparison

if bluearea > 18000 && redarea < bluearea && greenarea < bluearea
    fprintf(arduino,'%c','b');
end
if redarea > 18000 && bluearea < redarea && greenarea < redarea
    fprintf(arduino,'%c','r');
end

if greenarea > 18000 && redarea < greenarea && bluearea < greenarea
    fprintf(arduino,'%c','g');
end

n = n+1;

%pause the loop

pause(2);

end

%clear the cam object

clear('cam');