% Plot_Entity_Maps_All_Years.m
% 20190415
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Create and save maps of counties in the CONUS with their number of utilities,
% number of BAs, primary BA, number of NERC regions, and primary NERC region.

function Plot_Entity_Maps_All_Years(output_summary,year,number_of_utilities_png,number_of_nerc_regions_png,primary_nerc_region_png,number_of_ba_png,primary_ba_png,lat_min,lat_max,lon_min,lon_max)

    % Choose whether or not to save the figures generated (1 = yes):
    save_images = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Load in the Utility to BA to NERC region to county dataset:
    load([output_summary,'.mat']);

    % For plotting purposes, assign a unique 1:n number to all of the BAs that
    % will be plotted:
    County_Metadata_Table(:,12) = NaN.*0;
    Unique_BAs = unique(County_Metadata_Table(find(isnan(County_Metadata_Table(:,9)) == 0),9));
    for row = 1:size(Unique_BAs,1)
        Unique_BAs(row,2) = row;
        [Unique_BA_Labels(row,1).Short_Name,dummy] = BA_Information_From_BA_Code(Unique_BAs(row,1));
        County_Metadata_Table(find(County_Metadata_Table(:,9) == Unique_BAs(row,1)),12) = Unique_BAs(row,2);
        clear dummy
    end
    % Prepare the labels for all of the BAs that will be plotted:
    for i = 1:size(Unique_BA_Labels,1)
        Unique_BA_Label_Strings(1,i) = string(Unique_BA_Labels(i,1).Short_Name);
    end
    clear i row Unique_BAs Unique_BA_Labels

    % For plotting purposes, assign a unique 1:n number to all of the NERC regions that
    % will be plotted:
    County_Metadata_Table(:,13) = NaN.*0;
    Unique_NERC_Regions = unique(County_Metadata_Table(find(isnan(County_Metadata_Table(:,11)) == 0 & County_Metadata_Table(:,11) ~= 1 & County_Metadata_Table(:,11) ~= 2),11));
    for row = 1:size(Unique_NERC_Regions,1)
        Unique_NERC_Regions(row,2) = row;
        [Unique_NERC_Region_Labels(row,1).Short_Name,dummy] = NERC_Region_Information_From_NERC_Region_Code(Unique_NERC_Regions(row,1));
        County_Metadata_Table(find(County_Metadata_Table(:,11) == Unique_NERC_Regions(row,1)),13) = Unique_NERC_Regions(row,2);
        clear dummy
    end
    % Prepare the labels for all of the NERC regions that will be plotted:
    for i = 1:size(Unique_NERC_Region_Labels,1)
        Unique_NERC_Region_Label_Strings(1,i) = string(Unique_NERC_Region_Labels(i,1).Short_Name);
    end
    clear i row Unique_NERC_Regions Unique_NERC_Region_Labels
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PLOTTING SECTION                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the number of utilities operating in each county:
    a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
    ax1 = usamap([lat_min lat_max],[lon_min lon_max]);
    colormap(ax1,jet(15));
    states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
    faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
    geoshow(ax1,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
    for i = 1:size(County_Metadata,1)
    % for i = 1:100
        if isnan(County_Metadata_Table(i,7)) == 0
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',County_Metadata_Table(i,7),'FaceColor','flat');
        else
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,[0.5 0.5 0.5]);
        end
        clear Percent_Complete
    end
    set(gca,'clim',[1,16]);
    colo1 = colorbar('ytick',[1:1:16]);
    tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
    title(['Number of Utilities - ',num2str(year)],'FontSize',27);
    if save_images == 1
       set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
       print(a,'-dpng','-r295',number_of_utilities_png);
       close(a);
    end
    clear a ax1 colo1 i states faceColors


    % Plot the number of NERC regions operating in each county:
    a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
    ax1 = usamap([lat_min lat_max],[lon_min lon_max]);
    colormap(ax1,jet(9));
    states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
    faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
    geoshow(ax1,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
    for i = 1:size(County_Metadata,1)
    % for i = 1:100
        if isnan(County_Metadata_Table(i,10)) == 0
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',County_Metadata_Table(i,10),'FaceColor','flat');
        else
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,[0.5 0.5 0.5]);
        end
        clear Percent_Complete
    end
    set(gca,'clim',[1,10]);
    colo1 = colorbar('ytick',[1:1:10]);
    tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
    title(['Number of NERC Regions - ',num2str(year)],'FontSize',27);
    if save_images == 1
       set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
       print(a,'-dpng','-r295',number_of_nerc_regions_png);
       close(a);
    end
    clear a ax1 colo1 i states faceColors


    % Plot the primary NERC region for each county:
    a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
    ax1 = usamap([lat_min lat_max],[lon_min lon_max]);
    colormap(ax1,jet(size(Unique_NERC_Region_Label_Strings,2)));
    states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
    faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
    geoshow(ax1,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
    for i = 1:size(County_Metadata,1)
    % for i = 1:100
        if isnan(County_Metadata_Table(i,13)) == 0
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',County_Metadata_Table(i,13),'FaceColor','flat');
        else
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,[0.5 0.5 0.5]);
        end
        clear Percent_Complete
    end

    set(gca,'clim',[1,size(Unique_NERC_Region_Label_Strings,2)+1]);
    colo1 = colorbar('ytick',[1.5:1:(size(Unique_NERC_Region_Label_Strings,2)+0.5)],'YTickLabel',Unique_NERC_Region_Label_Strings);
    tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
    title(['Primary NERC Region - ',num2str(year)],'FontSize',27);
    if save_images == 1
       set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
       print(a,'-dpng','-r295',primary_nerc_region_png);
       close(a);
    end
    clear a ax1 colo1 i states faceColors


    % Plot the number of BAs operating in each county:
    a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
    ax1 = usamap([lat_min lat_max],[lon_min lon_max]);
    colormap(ax1,jet(9));
    states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
    faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
    geoshow(ax1,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
    for i = 1:size(County_Metadata,1)
    % for i = 1:100
        if isnan(County_Metadata_Table(i,8)) == 0
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',County_Metadata_Table(i,8),'FaceColor','flat');
        else
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,[0.5 0.5 0.5]);
        end
        clear Percent_Complete
    end
    set(gca,'clim',[1,10]);
    colo1 = colorbar('ytick',[1:1:10]);
    tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
    title(['Number of Balancing Authorities - ',num2str(year)],'FontSize',27);
    if save_images == 1
       set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
       print(a,'-dpng','-r295',number_of_ba_png);
       close(a);
    end
    clear a ax1 colo1 i states faceColors


    % Plot the primary BA for each county:
    a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
    ax1 = usamap([lat_min lat_max],[lon_min lon_max]);
    colormap(ax1,jet(size(Unique_BA_Label_Strings,2)));
    states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
    faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
    geoshow(ax1,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
    for i = 1:size(County_Metadata,1)
    % for i = 1:100
        if isnan(County_Metadata_Table(i,12)) == 0
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',County_Metadata_Table(i,12),'FaceColor','flat');
        else
           patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,[0.5 0.5 0.5]);
        end
        clear Percent_Complete
    end
    set(gca,'clim',[1,size(Unique_BA_Label_Strings,2)+1]);
    colo1 = colorbar('ytick',[1.5:1:(size(Unique_BA_Label_Strings,2)+0.5)],'YTickLabel',Unique_BA_Label_Strings);
    tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
    title(['Primary Balancing Authority - ',num2str(year)],'FontSize',27);
    if save_images == 1
       set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
       print(a,'-dpng','-r295',primary_ba_png);
       close(a);
    end
    clear a ax1 colo1 i states faceColors
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PLOTTING SECTION                  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end