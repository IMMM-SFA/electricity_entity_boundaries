% Process_County_Data_2018.m
% 20200410
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Convert the "County_Metadata_2018.xlsx" Excel spreadsheet into a Matlab
% structure by extracting relevant metadata. The spreadsheet was made in
% house and gives the FIPS code, county name, state information, population-weighted
% latitude, population-weighted longitude, area, and total population
% estimated by the census bureau in 2019 for all counties in the United
% States.

function Process_County_Data_2018(county_metadata_xlsx, county_metadata_mat, county_shapefile)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read the raw data from the spreadsheet into a cell structure:
    [~,~,Raw_Data] = xlsread(county_metadata_xlsx,'Counties','A2:G3143');
    Raw_Data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data)) = {''};

    % Loop over all of the counties to extract relevant metadata:
    for row = 1:size(Raw_Data,1)
        Metadata(row,1).County_FIPS = Raw_Data{row,1}; % County FIPS
        Metadata(row,1).State = Raw_Data{row,2}; % State String
        Metadata(row,1).County = Raw_Data{row,3}; % County String

        Metadata(row,1).Pop_Lat = Raw_Data{row,4}; % Population-weighted latitude
        Metadata(row,1).Pop_Lon = Raw_Data{row,5}; % Population-weighted longitude
        if isempty(Raw_Data{row,6}) == 0
           Metadata(row,1).Area = Raw_Data{row,6}; % Total area in square miles
        else;
           Metadata(row,1).Area = NaN.*0;
        end
        Metadata(row,1).Population = Raw_Data{row,7}; % Estimated population in 2017

        % Extract key variables into a table which is easier to search/filter:
        if isempty(Metadata(row,1).County_FIPS) == 0; Metadata_Table(row,1) = Metadata(row,1).County_FIPS; else; Metadata_Table(row,1) = NaN.*0; end
        if isempty(Metadata(row,1).Pop_Lat) == 0; Metadata_Table(row,3) = Metadata(row,1).Pop_Lat; else; Metadata_Table(row,3) = NaN.*0; end
        if isempty(Metadata(row,1).Pop_Lon) == 0; Metadata_Table(row,4) = Metadata(row,1).Pop_Lon; else; Metadata_Table(row,4) = NaN.*0; end
        if isempty(Metadata(row,1).Area) == 0; Metadata_Table(row,5) = Metadata(row,1).Area; else; Metadata_Table(row,5) = NaN.*0; end
        if isempty(Metadata(row,1).Population) == 0; Metadata_Table(row,6) = Metadata(row,1).Population; else; Metadata_Table(row,6) = NaN.*0; end
    end
    clear row Raw_Data

    % Back-calculate the state FIPS by rounding the county FIPS code. Fix
    % rounding errors in a few states (damn it, Texas):
    Metadata_Table(:,2) = roundn(Metadata_Table(:,1),3);
    Metadata_Table(find(Metadata_Table(:,2) == 52000),2) = 51000;
    Metadata_Table(find(Metadata_Table(:,1) == 48501),2) = 48000;
    Metadata_Table(find(Metadata_Table(:,1) == 48503),2) = 48000;
    Metadata_Table(find(Metadata_Table(:,1) == 48505),2) = 48000;
    Metadata_Table(find(Metadata_Table(:,1) == 48507),2) = 48000;
    for row = 1:size(Metadata_Table,1)
        Metadata(row,1).State_FIPS = Metadata_Table(row,2);
        [State_Abbreviation,State_String] = State_Information_From_State_FIPS(Metadata(row,1).State_FIPS);
        Metadata(row,1).State_Abbreviation = State_Abbreviation;
        clear State_Abbreviation State_String
    end
    clear row

    % Read in a dataset of shapefiles that contain the geographic boundaries for all
    % counties:
    [S,A] = shaperead(county_shapefile,'UseGeoCoords',true);
    for i = 1:size(A,1)
        FIPS(i,1) = A(i,1).CombiFIPS;
    end
    clear i

    % Loop over all of the counties to assign the geographic boundaries from
    % the shapefile read in above:
    for row = 1:size(Metadata,1)
        if isempty(find(FIPS(:,1) == Metadata_Table(row,1))) == 0 & size(find(FIPS(:,1) == Metadata_Table(row,1)),1) == 1
           Metadata(row,1).Latitude_Vector = S(find(FIPS(:,1) == Metadata_Table(row,1)),1).Lat; % Latitude vector of the county perimeter
           Metadata(row,1).Longitude_Vector = S(find(FIPS(:,1) == Metadata_Table(row,1)),1).Lon; % Longitude vector of the county perimeter
           Metadata(row,1).Geo_Lat = A(find(FIPS(:,1) == Metadata_Table(row,1)),1).CNTRDLAT; % Geographic-weighted latitude
           Metadata(row,1).Geo_Lon = A(find(FIPS(:,1) == Metadata_Table(row,1)),1).CNTRDLONG; % Geographic-weighted longitude
        elseif isempty(find(FIPS(:,1) == Metadata_Table(row,1))) == 0 & size(find(FIPS(:,1) == Metadata_Table(row,1)),1) > 1
           B = find(FIPS(:,1) == Metadata_Table(row,1));
           for i = 1:size(find(FIPS(:,1) == Metadata_Table(row,1)),1)
               if i == 1
                  Lon = S(B(i,1),1).Lon;
                  Lat = S(B(i,1),1).Lat;
               else
                  Lon = cat(2,Lon,S(B(i,1),1).Lon);
                  Lat = cat(2,Lat,S(B(i,1),1).Lat);
               end
           end
           Metadata(row,1).Latitude_Vector = Lat;
           Metadata(row,1).Longitude_Vector = Lon;
           Metadata(row,1).Geo_Lat = A(find(FIPS(:,1) == Metadata_Table(row,1)),1).CNTRDLAT;
           Metadata(row,1).Geo_Lon = A(find(FIPS(:,1) == Metadata_Table(row,1)),1).CNTRDLONG;
           clear B i Lon Lat
        else
           Metadata(row,1).Latitude_Vector = NaN.*0;
           Metadata(row,1).Longitude_Vector = NaN.*0;
           Metadata(row,1).Geo_Lat = NaN.*0;
           Metadata(row,1).Geo_Lon = NaN.*0;
        end
    end
    clear A FIPS S row

    % Loop over the counties and order the metadata fields alphebetically:
    for row = 1:size(Metadata,1)
        Dummy(row,1) = orderfields(Metadata(row,1));
    end
    Metadata = Dummy;
    clear row Dummy

    % Rename the two key variables and save the output:
    County_Metadata = Metadata; clear Metadata
    County_Metadata_Table = Metadata_Table; clear Metadata_Table
    save(county_metadata_mat,'County_Metadata','County_Metadata_Table');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
