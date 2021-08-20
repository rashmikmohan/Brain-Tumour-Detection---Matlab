clc;
clear all;
close all;

while(1)
 ch=menu('BRAIN TUMOUR SEGMENTATION','Input Image','Preprocessing','Feature Extraction','Data Analysis','Tumour Localization','Morphological Operation','Classifier','Exit');
 if(ch==1)
        [I,path]=uigetfile('*.jpg','select a input image');
        str=strcat(path,I);
        s=imread(str);   
        figure,imshow(s),title('Input image');
 end
 
 if(ch==2)
    num_iter = 10;
    delta_t = 1/7;
    kappa = 15;
    option = 2;
    ede=im2bw(s);
    imie=edge(ede,'canny');
    disp('Preprocessing image please wait . . .');
    ad = process(s,num_iter,delta_t,kappa,option);  
    adj=uint8(ad);
    figure, 
    subplot 121, imshow(s,[]),title('Input image');
    subplot 122, imshow(adj,[]),title('Fitered image');
 end
 if(ch==3)
 GLCMS = graycomatrix(s,'Offset',[2 0;0 2]);
stats1 = graycoprops(GLCMS,{'contrast','homogeneity','Energy','Correlation'});
 x1 = stats1.Correlation(1);
 disp(x1);
 x2 = stats1.Correlation(2);
  disp(x2);
 x3 = stats1.Energy(1);
  disp(x3);
 x4 = stats1.Energy(2);
  disp(x4);
 x5 = stats1.Contrast(1);
  disp(x5);
 x6 = stats1 .Contrast(2);
  disp(x6);
x7=stats1.Homogeneity(1);
disp(x7);
x8=stats1.Homogeneity(2);
disp(x8);
 end
 if ch(ch==4)
   features = extractHOGFeatures(s)
   figure,imshow(features)
  
 end   
 if(ch==5)
     cex=im2bw(s,0.8);
     hlex=strel('disk',1,0);
     cex=imclose(cex,hlex);
     c1loc=bwareaopen(cex,250);
     c2les=bwboundaries(c1loc);
     figure,imshow(s),title('Tumour Boundary')
     hold on

    for i=1:length(c2les)
         v=c2les{i};
         plot(v(:,2),v(:,1),'r','LineWidth',0.2);
    end;
 end
 
 if(ch==6)
     figure;
     gh=strel('disk',5,0);
     sel=imdilate(imie,gh);
     imshow(sel);title('morphology...')
     pause(0.6);
     thg=strel('disk',3,0);
     selus=imerode(sel,thg);
     imshow(selus);title('morphology...')
     pause(0.2);
     thg1=strel('disk',1,0);
     selu1=imopen(selus,thg1);
     imshow(selu1);title('morphology...')
     dct=bwconncomp(selu1);
 end
 
 if(ch==7)
     m = zeros(size(ad,1),size(ad,2));        
     m(90:100,110:135) = 1; 
     ad = imresize(ad,.5);  
     m = imresize(m,.5); 
    figure, title('Segmentation');
    seg = svm_c(ad, m, 50,.2,true,dct);
    figure,imshow(seg); title('Segmented Tumor');
 end
 
 if(ch==8)
     break;
 end
end