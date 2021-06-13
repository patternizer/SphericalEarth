
close all; clear; clc; radiusEarth=6371;

caxis_start = -4;
caxis_end = 4;
% colormap: bluewhitered

load PolyLattice.mat;

        PolyLattice=PolyLattice(1:5:end,:);

load variable.mat; % 

        VAR=squeeze(variable(:,:));
        % VAR=log10(VAR);
        VAR=VAR';
        VAR(VAR<=caxis_start)=caxis_start;
        VAR(VAR>=caxis_end)=caxis_end;

        [height,width]=size(VAR);
        [x,y]=meshgrid(1:width,1:height);
        cloud=[x(:),y(:),VAR(:)];

        X=cloud(:,1)-180;
        Y=cloud(:,2)-90;
        N=cloud(:,3);

        VAR=cat(2,X,Y,N);
        VAR(any(isnan(VAR),2),:)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Equator=(-180:1:180)';
Equator=cat(2,Equator,zeros(length(Equator),1));

PrimeMeridian=(-90:1:90)';
PrimeMeridian=cat(2,zeros(length(PrimeMeridian),1),PrimeMeridian);

A=load('borderdata.mat');

        Lines=[];

for k=1:246
    
        lon=A.borderdata.lon{k};
        lat=A.borderdata.lat{k};

        lon=cat(2,lon,NaN);
        lat=cat(2,lat,NaN);
        line=cat(2,lon',lat');

        Lines=cat(1,Lines,line);
end

    figure('Position',[120,60,1420,780],'Color','k')    
    hold on; axis off; axis tight; 
    colormap(inferno); 
    caxis([caxis_start,caxis_end]);
    
    scatter(PolyLattice(:,1),PolyLattice(:,2),0.1);
    plot(Lines(:,1),Lines(:,2),'w');
    scatter(VAR(:,1),VAR(:,2),10,VAR(:,3),'filled');
    plot(Equator(:,1),Equator(:,2),'c');
    plot(PrimeMeridian(:,1),PrimeMeridian(:,2),'c');
    %colorbar;

hold off; drawnow; pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(PolyLattice(:,1));
radY=deg2rad(PolyLattice(:,2));
[X,Y,Z]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Lines(:,1));
radY=deg2rad(Lines(:,2));
[iX,iY,iZ]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Equator(:,1));
radY=deg2rad(Equator(:,2));
[arcX,arcY,arcZ]=sph2cart(radX,radY,8000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(VAR(:,1));
radY=deg2rad(VAR(:,2));
radZ=rescale(VAR(:,3).^10,radiusEarth,8000);

PointsVAR=[];

for i=1:length(radX)
    
    [VARx,VARy,VARz]=sph2cart(radX(i,:),radY(i,:),radZ(i,:));
    triplet=cat(2,VARx,VARy,VARz);
    PointsVAR=cat(1,PointsVAR,triplet);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(VAR(:,1));
radY=deg2rad(VAR(:,2));
[VARx,VARy,VARz]=sph2cart(radX,radY,radiusEarth);

    figure('Position',[120,60,1420,780],'Color','k'); view(50,-30);
    set(gca,'CameraViewAngleMode','manual'); colormap(inferno);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
%   plot3(arcZ,arcX,arcY,'c');

    SurfaceVAR=cat(2,VARx,VARy,VARz);
    
    scatter3(SurfaceVAR(:,1),SurfaceVAR(:,2),SurfaceVAR(:,3), 8,VAR(:,3),'filled');

hold off; drawnow; pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colorspace=colormap(inferno(25));
index=rescale(radZ(:,1),1,length(colorspace));
index=round(index);

    figure('Position',[120,60,1420,780],'Color','k'); view(120,-50);
    set(gca,'CameraViewAngleMode','manual'); colormap(inferno);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
%   plot3(arcZ,arcX,arcY,'c');

for i=1:length(radZ)
    
    pointA=cat(2,SurfaceVAR(i,1),SurfaceVAR(i,2),SurfaceVAR(i,3));
    pointB=cat(2,PointsVAR(i,1),PointsVAR(i,2),PointsVAR(i,3));
    line=cat(1,pointA,pointB);
    plot3(line(:,1),line(:,2),line(:,3),'Color',colorspace(index(i,:),:));
    
    b=mod(i,3000);
    if b==0
        drawnow;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colorspace=inferno(length(PointsVAR(:,3)));
index=rescale(radZ(:,1),1,length(radZ));
index=round(index);

    figure('Position',[120,60,1420,780],'Color','k'); view(120,-50);
    set(gca,'CameraViewAngleMode','manual'); colormap(inferno);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
    plot3(arcZ,arcX,arcY,'c');

for i=1:length(radZ)
    
    pointA=cat(2,SurfaceVAR(i,1),SurfaceVAR(i,2),SurfaceVAR(i,3));
    pointB=cat(2,PointsVAR(i,1),PointsVAR(i,2),PointsVAR(i,3));
    line=cat(1,pointA,pointB);
    plot3(line(:,1),line(:,2),line(:,3),'Color',colorspace(index(i,:),:));
    
    b=mod(i,3000);
    if b==0
        drawnow;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colorspace=inferno(length(PointsVAR(:,3)));
index=rescale(radZ(:,1),1,length(radZ));
index=round(index);

    figure('Position',[120,60,1420,780],'Color','k'); view(120,-50);
    set(gca,'CameraViewAngleMode','manual'); colormap(inferno);
    hold on; axis off; axis tight;

    scatter3(X,Y,Z,0.1);
    plot3(iX,iY,iZ,'w');

    plot3(arcX,arcY,arcZ,'c');
    plot3(arcY,arcZ,arcX,'c');
%   plot3(arcZ,arcX,arcY,'c');

for i=1:length(radZ)
    
    pointA=cat(2,SurfaceVAR(i,1),SurfaceVAR(i,2),SurfaceVAR(i,3));
    pointB=cat(2,PointsVAR(i,1),PointsVAR(i,2),PointsVAR(i,3));
    line=cat(1,pointA,pointB);
    plot3(line(:,1),line(:,2),line(:,3),'w');
    
    b=mod(i,3000);
    if b==0
        drawnow;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
