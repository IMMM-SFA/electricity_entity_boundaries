% Preprocess_Service_Territory_Data_All_Years.m
% 20200414
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Convert the "Service_Territory_YYYY.xlsx" Excel spreadsheet into a Matlab
% structure by extracting relevant metadata.

function Preprocess_Service_Territory_Data_All_Years(service_territory_xlsx,service_territory_mat,county_metadata_mat,year)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Define how many rows to read in based on the year being processed:
    if year == 2016
       rows = 11953;
    elseif year == 2017
       rows = 11828;
    elseif year == 2018
       rows = 11827;
    end
    
    % Load in the county metadata file processed using the "Process_County_Data_All_Years.m" script:
    load(county_metadata_mat);

    % Read the raw data from the spreadsheet into a cell structure:
    if year == 2016
       [~,~,Raw_Data] = xlsread(service_territory_xlsx,'Counties',['B2:E',num2str(rows)]);
    else
       [~,~,Raw_Data] = xlsread(service_territory_xlsx,'Counties_States',['B2:E',num2str(rows)]);
    end
    Raw_Data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data)) = {''};

    % Loop over all of the utilities to extract relevant metadata:
    for row = 1:size(Raw_Data,1)
        % Look up state information from the state abbreviation:
        [State_FIPS,State_String] = State_FIPS_From_Abbreviations(Raw_Data{row,3});

        % Extract the metadata into a structure:
        Territory(row,1).Utility_Number = Raw_Data{row,1}; % EIA Utility #
        Territory(row,1).State_FIPS = State_FIPS; % State FIPS
        Territory(row,1).State_String = State_String; % State String
        Territory(row,1).State_Abbreviation = Raw_Data{row,3}; % State Abbreviation
        Territory(row,1).Utility_Name = Raw_Data{row,2}; % EIA Utility Name
        Territory(row,1).County = Raw_Data{row,4}; % County Name

        % Extract key variables into a table which is easier to search/filter:
        if isempty(Territory(row,1).Utility_Number) == 0; Territory_Table(row,1) = Territory(row,1).Utility_Number; else; Territory_Table(row,1) = NaN.*0; end
        if isempty(Territory(row,1).State_FIPS) == 0; Territory_Table(row,2) = Territory(row,1).State_FIPS; else; Territory_Table(row,2) = NaN.*0; end

        clear State_FIPS State_String
    end
    clear row Raw_Data

    % Loop over all of the utilities match the county listed to a county from the "County_Metadata" structure:
    for row = 1:size(Territory,1)
        % Try to string match the county and state to a matched pair from the "County_Metadata" structure:
        if isempty(Territory(row,1).State_FIPS) == 0 & isempty(Territory(row,1).County) == 0
           State_Table = County_Metadata_Table(find(County_Metadata_Table(:,2) == Territory(row,1).State_FIPS),:);
           State = County_Metadata(find(County_Metadata_Table(:,2) == Territory(row,1).State_FIPS),:);
           County = Territory(row,1).County;
           for i = 1:size(State,1)
               if size(State(i,1).County,2) > size(County,2)
                  X = strcmpi(County,{State(i,1).County(1,1:size(County,2))});
                  if X == 1
                     Territory(row,1).County_Name = State(i,1).County;
                     Territory(row,1).County_FIPS = State(i,1).County_FIPS;
                     Territory_Table(row,3) = State(i,1).County_FIPS;
                  end
                  clear X
               end
           end
           if Territory_Table(row,3) == 0
              Territory_Table(row,3) = NaN.*0;
           end
           clear i State_Table State County
        else
           Territory_Table(row,3) = NaN.*0;
        end
    end
    clear row

    % There are a ton of initial mismatches due to the simplified way I do the
    % string matching. Most of them involve some peculiarity of the county name
    % (e.g., "St." instead of "St") while some of them are mismatches between
    % cities and counties (damn it, Virginia). Mismatches were identified and
    % corrected manually. The reason for each correction is appended as a
    % comment on the end of each line. The specific line numbers vary by
    % year which requires the manual fixes to be conditioned on the year
    % you're processing. This could be fixed, but I don't have time right
    % now.
    if year == 2017
    Territory(108,1).County_Name = 'St. Clair County'; Territory(108,1).County_FIPS = 1117; Territory_Table(108,3) = 1117; % String mismatch
    Territory(123,1).County_Name = 'Prince of Wales-Hyder Census Area'; Territory(123,1).County_FIPS = 2201; Territory_Table(123,3) = 2201; % String mismatch
    Territory(124,1).County_Name = 'Skagway Municipality'; Territory(124,1).County_FIPS = 2232; Territory_Table(124,3) = 2232; % String mismatch
    Territory(125,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(125,1).County_FIPS = 2290; Territory_Table(125,3) = 2290; % String mismatch
    Territory(133,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(133,1).County_FIPS = 2290; Territory_Table(133,3) = 2290; % String mismatch
    Territory(246,1).County_Name = 'Bedford County'; Territory(246,1).County_FIPS = 51019; Territory_Table(246,3) = 51019; % String mismatch
    Territory(257,1).County_Name = 'Franklin County'; Territory(257,1).County_FIPS = 51067; Territory_Table(257,3) = 51067; % String mismatch
    Territory(258,1).County_Name = 'Carroll County'; Territory(258,1).County_FIPS = 51035; Territory_Table(258,3) = 51035; % https://en.wikipedia.org/wiki/Galax,_Virginia
    Territory(262,1).County_Name = 'Lynchburg City'; Territory(262,1).County_FIPS = 51680; Territory_Table(262,3) = 51680; % String mismatch
    Territory(268,1).County_Name = 'Roanoke County'; Territory(268,1).County_FIPS = 51161; Territory_Table(268,3) = 51161; % String mismatch
    Territory(269,1).County_Name = 'Roanoke City'; Territory(269,1).County_FIPS = 51770; Territory_Table(269,3) = 51770; % String mismatch
    Territory(378,1).County_Name = 'St. Francis County'; Territory(378,1).County_FIPS = 5123; Territory_Table(378,3) = 5123; % String mismatch
    Territory(407,1).County_Name = 'Lake County'; Territory(407,1).County_FIPS = 27075; Territory_Table(407,3) = 27075; % String mismatch
    Territory(469,1).County_Name = 'Baltimore City'; Territory(469,1).County_FIPS = 24510; Territory_Table(469,3) = 24510; % String mismatch
    Territory(475,1).County_Name = 'Prince Georges County'; Territory(475,1).County_FIPS = 24033; Territory_Table(475,3) = 24033; % String mismatch
    Territory(564,1).County_Name = 'Bedford County'; Territory(564,1).County_FIPS = 51019; Territory_Table(564,3) = 51019; % String mismatch
    Territory(739,1).County_Name = 'Valdez-Cordova Census Area'; Territory(739,1).County_FIPS = 2261; Territory_Table(739,3) = 2261; % String mismatch
    Territory(740,1).County_Name = 'St. Louis County'; Territory(740,1).County_FIPS = 27137; Territory_Table(740,3) = 27137; % String mismatch
    Territory(918,1).County_Name = 'Bristol City'; Territory(918,1).County_FIPS = 51520; Territory_Table(918,3) = 51520; % String mismatch
    Territory(924,1).County_Name = 'Green County'; Territory(924,1).County_FIPS = 55045; Territory_Table(924,3) = 55045; % String mismatch
    Territory(963,1).County_Name = 'St. Louis County'; Territory(963,1).County_FIPS = 27137; Territory_Table(963,3) = 27137; % String mismatch
    Territory(1114,1).County_Name = 'White County'; Territory(1114,1).County_FIPS = 17193; Territory_Table(1114,3) = 17193; % String mismatch
    Territory(1321,1).County_Name = 'De Soto Parish'; Territory(1321,1).County_FIPS = 22031; Territory_Table(1321,3) = 22031; % String mismatch
    Territory(1332,1).County_Name = 'St. Landry Parish'; Territory(1332,1).County_FIPS = 22097; Territory_Table(1332,3) = 22097; % String mismatch
    Territory(1333,1).County_Name = 'St. Martin Parish'; Territory(1333,1).County_FIPS = 22099; Territory_Table(1333,3) = 22099; % String mismatch
    Territory(1334,1).County_Name = 'St. Mary Parish'; Territory(1334,1).County_FIPS = 22101; Territory_Table(1334,3) = 22101; % String mismatch
    Territory(1335,1).County_Name = 'St. Tammany Parish'; Territory(1335,1).County_FIPS = 22103; Territory_Table(1335,3) = 22103; % String mismatch
    Territory(1484,1).County_Name = 'Wrangell City and Borough'; Territory(1484,1).County_FIPS = 2280; Territory_Table(1484,3) = 2280; % String mismatch
    Territory(1509,1).County_Name = 'Valdez-Cordova Census Area'; Territory(1509,1).County_FIPS = 2261; Territory_Table(1509,3) = 2261; % String mismatch
    Territory(1544,1).County_Name = 'Queen Annes County'; Territory(1544,1).County_FIPS = 24035; Territory_Table(1544,3) = 24035; % String mismatch
    Territory(1588,1).County_Name = 'St. Francois County'; Territory(1588,1).County_FIPS = 29187; Territory_Table(1588,3) = 29187; % String mismatch
    Territory(1589,1).County_Name = 'Ste. Genevieve County'; Territory(1589,1).County_FIPS = 29186; Territory_Table(1589,3) = 29186; % String mismatch
    Territory(1702,1).County_Name = 'St. Clair County'; Territory(1702,1).County_FIPS = 17163; Territory_Table(1702,3) = 17163; % String mismatch
    Territory(1851,1).County_Name = 'Will County'; Territory(1851,1).County_FIPS = 17197; Territory_Table(1851,3) = 17197; % String mismatch
    Territory(1856,1).County_Name = 'Suffolk City'; Territory(1856,1).County_FIPS = 51800; Territory_Table(1856,3) = 51800; % String mismatch
    Territory(1964,1).County_Name = 'St. Joseph County'; Territory(1964,1).County_FIPS = 26149; Territory_Table(1964,3) = 26149; % String mismatch
    Territory(2007,1).County_Name = 'St. Clair County'; Territory(2007,1).County_FIPS = 1117; Territory_Table(2007,3) = 1117; % String mismatch
    Territory(2009,1).County_Name = 'Valdez-Cordova Census Area'; Territory(2009,1).County_FIPS = 2261; Territory_Table(2009,3) = 2261; % String mismatch
    Territory(2013,1).County_Name = 'Lake County'; Territory(2013,1).County_FIPS = 27075; Territory_Table(2013,3) = 27075; % String mismatch
    Territory(2014,1).County_Name = 'St. Louis County'; Territory(2014,1).County_FIPS = 27137; Territory_Table(2014,3) = 27137; % String mismatch
    Territory(2018,1).County_Name = 'De Witt County'; Territory(2018,1).County_FIPS = 17039; Territory_Table(2018,3) = 17039; % String mismatch
    Territory(2080,1).County_Name = 'Roanoke County'; Territory(2080,1).County_FIPS = 51161; Territory_Table(2080,3) = 51161; % String mismatch
    Territory(2168,1).County_Name = 'St. Charles County'; Territory(2168,1).County_FIPS = 29183; Territory_Table(2168,3) = 29183; % String mismatch
    Territory(2216,1).County_Name = 'Danville City'; Territory(2216,1).County_FIPS = 51590; Territory_Table(2216,3) = 51590; % String mismatch
    Territory(2300,1).County_Name = 'Queen Annes County'; Territory(2300,1).County_FIPS = 24035; Territory_Table(2300,3) = 24035; % String mismatch
    Territory(2312,1).County_Name = 'Collin County'; Territory(2312,1).County_FIPS = 48085; Territory_Table(2312,3) = 48085; % String mismatch
    Territory(2341,1).County_Name = 'St. Clair County'; Territory(2341,1).County_FIPS = 26147; Territory_Table(2341,3) = 26147; % String mismatch
    Territory(2364,1).County_Name = 'St. Helena Parish'; Territory(2364,1).County_FIPS = 22091; Territory_Table(2364,3) = 22091; % String mismatch
    Territory(2467,1).County_Name = 'Chester County'; Territory(2467,1).County_FIPS = 45023; Territory_Table(2467,3) = 45023; % String mismatch
    Territory(2488,1).County_Name = 'St. Croix County'; Territory(2488,1).County_FIPS = 55109; Territory_Table(2488,3) = 55109; % String mismatch
    Territory(2516,1).County_Name = 'St. Clair County'; Territory(2516,1).County_FIPS = 17163; Territory_Table(2516,3) = 17163; % String mismatch
    Territory(2638,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(2638,1).County_FIPS = 2290; Territory_Table(2638,3) = 2290; % String mismatch
    Territory(2679,1).County_Name = 'St. Louis County'; Territory(2679,1).County_FIPS = 27137; Territory_Table(2679,3) = 27137; % String mismatch
    Territory(2698,1).County_Name = 'St. Clair County'; Territory(2698,1).County_FIPS = 29185; Territory_Table(2698,3) = 29185; % String mismatch
    Territory(2722,1).County_Name = 'Chester County'; Territory(2722,1).County_FIPS = 45023; Territory_Table(2722,3) = 45023; % String mismatch
    Territory(2744,1).County_Name = 'Green County'; Territory(2744,1).County_FIPS = 55045; Territory_Table(2744,3) = 55045; % String mismatch
    Territory(2780,1).County_Name = 'Collin County'; Territory(2780,1).County_FIPS = 48085; Territory_Table(2780,3) = 48085; % String mismatch
    Territory(2796,1).County_Name = 'Collin County'; Territory(2796,1).County_FIPS = 48085; Territory_Table(2796,3) = 48085; % String mismatch
    Territory(2816,1).County_Name = 'De Witt County'; Territory(2816,1).County_FIPS = 17039; Territory_Table(2816,3) = 17039; % String mismatch
    Territory(2821,1).County_Name = 'Green County'; Territory(2821,1).County_FIPS = 21087; Territory_Table(2821,3) = 21087; % String mismatch
    Territory(2835,1).County_Name = 'Collin County'; Territory(2835,1).County_FIPS = 48085; Territory_Table(2835,3) = 48085; % String mismatch
    Territory(2838,1).County_Name = 'St. Francois County'; Territory(2838,1).County_FIPS = 29187; Territory_Table(2838,3) = 29187; % String mismatch
    Territory(2970,1).County_Name = 'Miami-Dade County'; Territory(2970,1).County_FIPS = 12086; Territory_Table(2970,3) = 12086; % String mismatch
    Territory(2980,1).County_Name = 'St. Johns County'; Territory(2980,1).County_FIPS = 12109; Territory_Table(2980,3) = 12109; % String mismatch
    Territory(2981,1).County_Name = 'St. Lucie County'; Territory(2981,1).County_FIPS = 12111; Territory_Table(2981,3) = 12111; % String mismatch
    Territory(3039,1).County_Name = 'Jack County'; Territory(3039,1).County_FIPS = 48237; Territory_Table(3039,3) = 48237; % String mismatch
    Territory(3048,1).County_Name = 'St. Lucie County'; Territory(3048,1).County_FIPS = 12111; Territory_Table(3048,3) = 12111; % String mismatch
    Territory(3077,1).County_Name = 'Franklin City'; Territory(3077,1).County_FIPS = 51620; Territory_Table(3077,3) = 51620; % String mismatch
    Territory(3080,1).County_Name = 'Suffolk City'; Territory(3080,1).County_FIPS = 51800; Territory_Table(3080,3) = 51800; % String mismatch
    Territory(3100,1).County_Name = 'St. Clair County'; Territory(3100,1).County_FIPS = 17163; Territory_Table(3100,3) = 17163; % String mismatch
    Territory(3144,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3144,1).County_FIPS = 2290; Territory_Table(3144,3) = 2290; % String mismatch
    Territory(3217,1).County_Name = 'Clay County'; Territory(3217,1).County_FIPS = 13061; Territory_Table(3217,3) = 13061; % String mismatch
    Territory(3355,1).County_Name = 'St. Louis County'; Territory(3355,1).County_FIPS = 27137; Territory_Table(3355,3) = 27137; % String mismatch
    Territory(3397,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3397,1).County_FIPS = 2290; Territory_Table(3397,3) = 2290; % String mismatch
    Territory(3467,1).County_Name = 'Gray County'; Territory(3467,1).County_FIPS = 48179; Territory_Table(3467,3) = 48179; % String mismatch
    Territory(3459,1).County_Name = 'Collin County'; Territory(3459,1).County_FIPS = 48085; Territory_Table(3459,3) = 48085; % String mismatch
    Territory(3470,1).County_Name = 'Roberts County'; Territory(3470,1).County_FIPS = 48393; Territory_Table(3470,3) = 48393; % String mismatch
    Territory(3571,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3571,1).County_FIPS = 2290; Territory_Table(3571,3) = 2290; % String mismatch
    Territory(3744,1).County_Name = 'St. Louis County'; Territory(3744,1).County_FIPS = 27137; Territory_Table(3744,3) = 27137; % String mismatch
    Territory(3773,1).County_Name = 'St. Clair County'; Territory(3773,1).County_FIPS = 17163; Territory_Table(3773,3) = 17163; % String mismatch
    Territory(3843,1).County_Name = 'Miami-Dade County'; Territory(3843,1).County_FIPS = 12086; Territory_Table(3843,3) = 12086; % String mismatch
    Territory(3881,1).County_Name = 'Harris County'; Territory(3881,1).County_FIPS = 48201; Territory_Table(3881,3) = 48201; % String mismatch
    Territory(3905,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3905,1).County_FIPS = 2290; Territory_Table(3905,3) = 2290; % String mismatch
    Territory(3924,1).County_Name = 'Ada County'; Territory(3924,1).County_FIPS = 16001; Territory_Table(3924,3) = 16001; % String mismatch
    Territory(3953,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3953,1).County_FIPS = 2290; Territory_Table(3953,3) = 2290; % String mismatch
    Territory(4030,1).County_Name = 'St. Joseph County'; Territory(4030,1).County_FIPS = 18141; Territory_Table(4030,3) = 18141; % String mismatch
    Territory(4040,1).County_Name = 'St. Joseph County'; Territory(4040,1).County_FIPS = 26149; Territory_Table(4040,3) = 26149; % String mismatch
    Territory(4081,1).County_Name = 'Clay County'; Territory(4081,1).County_FIPS = 19041; Territory_Table(4081,3) = 19041; % String mismatch
    Territory(4150,1).County_Name = 'Jack County'; Territory(4150,1).County_FIPS = 48237; Territory_Table(4150,3) = 48237; % String mismatch
    Territory(4154,1).County_Name = 'Clay County'; Territory(4154,1).County_FIPS = 19041; Territory_Table(4154,3) = 19041; % String mismatch
    Territory(4240,1).County_Name = 'St. Johns County'; Territory(4240,1).County_FIPS = 12109; Territory_Table(4240,3) = 12109; % String mismatch
    Territory(4244,1).County_Name = 'St. Johns County'; Territory(4244,1).County_FIPS = 12109; Territory_Table(4244,3) = 12109; % String mismatch
    Territory(4368,1).County_Name = 'St. Joseph County'; Territory(4368,1).County_FIPS = 18141; Territory_Table(4368,3) = 18141; % String mismatch
    Territory(4505,1).County_Name = 'Green County'; Territory(4505,1).County_FIPS = 21087; Territory_Table(4505,3) = 21087; % String mismatch
    Territory(4555,1).County_Name = 'Norton City'; Territory(4555,1).County_FIPS = 51720; Territory_Table(4555,3) = 51720; % String mismatch
    Territory(4586,1).County_Name = 'St. Louis City'; Territory(4586,1).County_FIPS = 29510; Territory_Table(4586,3) = 29510; % String mismatch
    Territory(4739,1).County_Name = 'Lake County'; Territory(4739,1).County_FIPS = 27075; Territory_Table(4739,3) = 27075; % String mismatch
    Territory(4741,1).County_Name = 'St. Louis County'; Territory(4741,1).County_FIPS = 27137; Territory_Table(4741,3) = 27137; % String mismatch
    Territory(4876,1).County_Name = 'Chester County'; Territory(4876,1).County_FIPS = 45023; Territory_Table(4876,3) = 45023; % String mismatch
    Territory(4938,1).County_Name = 'Jefferson County'; Territory(4938,1).County_FIPS = 22051; Territory_Table(4938,3) = 22051; % String mismatch
    Territory(4955,1).County_Name = 'St. Helena Parish'; Territory(4955,1).County_FIPS = 22091; Territory_Table(4955,3) = 22091; % String mismatch
    Territory(4956,1).County_Name = 'St. Bernard Parish'; Territory(4956,1).County_FIPS = 22087; Territory_Table(4956,3) = 22087; % String mismatch
    Territory(4957,1).County_Name = 'St. Charles Parish'; Territory(4957,1).County_FIPS = 22089; Territory_Table(4957,3) = 22089; % String mismatch
    Territory(4958,1).County_Name = 'St. James Parish'; Territory(4958,1).County_FIPS = 22093; Territory_Table(4958,3) = 22093; % String mismatch
    Territory(4959,1).County_Name = 'St. John the Baptist Parish'; Territory(4959,1).County_FIPS = 22095; Territory_Table(4959,3) = 22095; % String mismatch
    Territory(4960,1).County_Name = 'St. Landry Parish'; Territory(4960,1).County_FIPS = 22097; Territory_Table(4960,3) = 22097; % String mismatch
    Territory(4961,1).County_Name = 'St. Martin Parish'; Territory(4961,1).County_FIPS = 22099; Territory_Table(4961,3) = 22099; % String mismatch
    Territory(4962,1).County_Name = 'St. Tammany Parish'; Territory(4962,1).County_FIPS = 22103; Territory_Table(4962,3) = 22103; % String mismatch
    Territory(5097,1).County_Name = 'Manassas City'; Territory(5097,1).County_FIPS = 51683; Territory_Table(5097,3) = 51683; % String mismatch
    Territory(5146,1).County_Name = 'St. Joseph County'; Territory(5146,1).County_FIPS = 18141; Territory_Table(5146,3) = 18141; % String mismatch
    Territory(5149,1).County_Name = 'Martinsville City'; Territory(5149,1).County_FIPS = 51690; Territory_Table(5149,3) = 51690; % String mismatch
    Territory(5156,1).County_Name = 'St. Clair County'; Territory(5156,1).County_FIPS = 17163; Territory_Table(5156,3) = 17163; % String mismatch
    Territory(5170,1).County_Name = 'St. Lawrence County'; Territory(5170,1).County_FIPS = 36089; Territory_Table(5170,3) = 36089; % String mismatch
    Territory(5172,1).County_Name = 'Matanuska-Susitna Borough'; Territory(5172,1).County_FIPS = 02170; Territory_Table(5172,3) = 02170; % String mismatch
    Territory(5217,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(5217,1).County_FIPS = 2290; Territory_Table(5217,3) = 2290; % String mismatch
    Territory(5291,1).County_Name = 'Charlotte County'; Territory(5291,1).County_FIPS = 51037; Territory_Table(5291,3) = 51037; % String mismatch
    Territory(5408,1).County_Name = 'St. Joseph County'; Territory(5408,1).County_FIPS = 18141; Territory_Table(5408,3) = 18141; % String mismatch
    Territory(5414,1).County_Name = 'St. Joseph County'; Territory(5414,1).County_FIPS = 26149; Territory_Table(5414,3) = 26149; % String mismatch
    Territory(5418,1).County_Name = 'Prince of Wales-Hyder Census Area'; Territory(5418,1).County_FIPS = 2201; Territory_Table(5418,3) = 2201; % String mismatch
    Territory(5590,1).County_Name = 'Lake County'; Territory(5590,1).County_FIPS = 27075; Territory_Table(5590,3) = 27075; % String mismatch
    Territory(5594,1).County_Name = 'St. Louis County'; Territory(5594,1).County_FIPS = 27137; Territory_Table(5594,3) = 27137; % String mismatch
    Territory(5609,1).County_Name = 'St. Joseph County'; Territory(5609,1).County_FIPS = 18141; Territory_Table(5609,3) = 18141; % String mismatch
    Territory(5630,1).County_Name = 'Jefferson County'; Territory(5630,1).County_FIPS = 28063; Territory_Table(5630,3) = 28063; % String mismatch
    Territory(5715,1).County_Name = 'St. Clair County'; Territory(5715,1).County_FIPS = 29185; Territory_Table(5715,3) = 29185; % String mismatch
    Territory(5785,1).County_Name = 'St. Clair County'; Territory(5785,1).County_FIPS = 17163; Territory_Table(5785,3) = 17163; % String mismatch
    Territory(5863,1).County_Name = 'St. Mary Parish'; Territory(5863,1).County_FIPS = 22101; Territory_Table(5863,3) = 22101; % String mismatch
    Territory(5903,1).County_Name = 'St. Louis County'; Territory(5903,1).County_FIPS = 27137; Territory_Table(5903,3) = 27137; % String mismatch
    Territory(5957,1).County_Name = 'Will County'; Territory(5957,1).County_FIPS = 17197; Territory_Table(5957,3) = 17197; % String mismatch
    Territory(6076,1).County_Name = 'St. Joseph County'; Territory(6076,1).County_FIPS = 18141; Territory_Table(6076,3) = 18141; % String mismatch
    Territory(6079,1).County_Name = 'Green County'; Territory(6079,1).County_FIPS = 55045; Territory_Table(6079,3) = 55045; % String mismatch
    Territory(6104,1).County_Name = 'St. Croix County'; Territory(6104,1).County_FIPS = 55109; Territory_Table(6104,3) = 55109; % String mismatch
    Territory(6226,1).County_Name = 'St. Lawrence County'; Territory(6226,1).County_FIPS = 36089; Territory_Table(6226,3) = 36089; % String mismatch
    Territory(6241,1).County_Name = 'Fairfax County'; Territory(6241,1).County_FIPS = 51059; Territory_Table(6241,3) = 51059; % String mismatch
    Territory(6244,1).County_Name = 'Manassas Park City'; Territory(6244,1).County_FIPS = 51685; Territory_Table(6244,3) = 51685; % String mismatch
    Territory(6262,1).County_Name = 'Green County'; Territory(6262,1).County_FIPS = 21087; Territory_Table(6262,3) = 21087; % String mismatch
    Territory(6358,1).County_Name = 'St. Louis County'; Territory(6358,1).County_FIPS = 27137; Territory_Table(6358,3) = 27137; % String mismatch
    Territory(6405,1).County_Name = 'St. Joseph County'; Territory(6405,1).County_FIPS = 18141; Territory_Table(6405,3) = 18141; % String mismatch
    Territory(6415,1).County_Name = 'Roberts County'; Territory(6415,1).County_FIPS = 48393; Territory_Table(6415,3) = 48393; % String mismatch
    Territory(6426,1).County_Name = 'Richmond County'; Territory(6426,1).County_FIPS = 51159; Territory_Table(6426,3) = 51159; % String mismatch
    Territory(6454,1).County_Name = 'St. Croix County'; Territory(6454,1).County_FIPS = 55109; Territory_Table(6454,3) = 55109; % String mismatch
    Territory(6883,1).County_Name = 'St. Clair County'; Territory(6883,1).County_FIPS = 29185; Territory_Table(6883,3) = 29185; % String mismatch
    Territory(7191,1).County_Name = 'De Soto Parish'; Territory(7191,1).County_FIPS = 22031; Territory_Table(7191,3) = 22031; % String mismatch
    Territory(7449,1).County_Name = 'Petersburg Census Area'; Territory(7449,1).County_FIPS = 02195; Territory_Table(7449,3) = 02195; % String mismatch
    Territory(7490,1).County_Name = 'St. Croix County'; Territory(7490,1).County_FIPS = 55109; Territory_Table(7490,3) = 55109; % String mismatch
    Territory(7590,1).County_Name = 'District of Columbia'; Territory(7590,1).County_FIPS = 11000; Territory_Table(7590,3) = 11000; % String mismatch
    Territory(7592,1).County_Name = 'Prince Georges County'; Territory(7592,1).County_FIPS = 24033; Territory_Table(7592,3) = 24033; % String mismatch
    Territory(7639,1).County_Name = 'St. Croix County'; Territory(7639,1).County_FIPS = 55109; Territory_Table(7639,3) = 55109; % String mismatch
    Territory(7676,1).County_Name = 'St. Louis County'; Territory(7676,1).County_FIPS = 27137; Territory_Table(7676,3) = 27137; % String mismatch
    Territory(7912,1).County_Name = 'Radford City'; Territory(7912,1).County_FIPS = 51750; Territory_Table(7912,3) = 51750; % String mismatch
    Territory(8036,1).County_Name = 'St. Croix County'; Territory(8036,1).County_FIPS = 55109; Territory_Table(8036,3) = 55109; % String mismatch
    Territory(8079,1).County_Name = 'Green County'; Territory(8079,1).County_FIPS = 55045; Territory_Table(8079,3) = 55045; % String mismatch
    Territory(8186,1).County_Name = 'Roanoke County'; Territory(8186,1).County_FIPS = 51161; Territory_Table(8186,3) = 51161; % String mismatch
    Territory(8174,1).County_Name = 'St. Clair County'; Territory(8174,1).County_FIPS = 29185; Territory_Table(8174,3) = 29185; % String mismatch
    Territory(8187,1).County_Name = 'Salem City'; Territory(8187,1).County_FIPS = 51775; Territory_Table(8187,3) = 51775; % String mismatch
    Territory(8281,1).County_Name = 'Harris County'; Territory(8281,1).County_FIPS = 48201; Territory_Table(8281,3) = 48201; % String mismatch
    Territory(8312,1).County_Name = 'Green County'; Territory(8312,1).County_FIPS = 55045; Territory_Table(8312,3) = 55045; % String mismatch
    Territory(8411,1).County_Name = 'Collin County'; Territory(8411,1).County_FIPS = 48085; Territory_Table(8411,3) = 48085; % String mismatch
    Territory(8475,1).County_Name = 'Frederick County'; Territory(8475,1).County_FIPS = 51069; Territory_Table(8475,3) = 51069; % String mismatch
    Territory(8484,1).County_Name = 'Winchester City'; Territory(8484,1).County_FIPS = 51840; Territory_Table(8484,3) = 51840; % String mismatch
    Territory(8495,1).County_Name = 'Carson City'; Territory(8495,1).County_FIPS = 32510; Territory_Table(8495,3) = 32510; % String mismatch
    Territory(8524,1).County_Name = 'Clay County'; Territory(8524,1).County_FIPS = 19041; Territory_Table(8524,3) = 19041; % String mismatch
    Territory(8685,1).County_Name = 'St. Martin Parish'; Territory(8685,1).County_FIPS = 22099; Territory_Table(8685,3) = 22099; % String mismatch
    Territory(8686,1).County_Name = 'St. Mary Parish'; Territory(8686,1).County_FIPS = 22101; Territory_Table(8686,3) = 22101; % String mismatch
    Territory(8706,1).County_Name = 'White County'; Territory(8706,1).County_FIPS = 17193; Territory_Table(8706,3) = 17193; % String mismatch
    Territory(8773,1).County_Name = 'Prince Georges County'; Territory(8773,1).County_FIPS = 24033; Territory_Table(8773,3) = 24033; % String mismatch
    Territory(8774,1).County_Name = 'St. Marys County'; Territory(8774,1).County_FIPS = 24037; Territory_Table(8774,3) = 24037; % String mismatch
    Territory(8839,1).County_Name = 'Jefferson County'; Territory(8839,1).County_FIPS = 28063; Territory_Table(8839,3) = 28063; % String mismatch
    Territory(8848,1).County_Name = 'St. Landry Parish'; Territory(8848,1).County_FIPS = 22097; Territory_Table(8848,3) = 22097; % String mismatch
    Territory(8849,1).County_Name = 'St. Martin Parish'; Territory(8849,1).County_FIPS = 22099; Territory_Table(8849,3) = 22099; % String mismatch
    Territory(8888,1).County_Name = 'St. Clair County'; Territory(8888,1).County_FIPS = 17163; Territory_Table(8888,3) = 17163; % String mismatch
    Territory(8906,1).County_Name = 'De Soto Parish'; Territory(8906,1).County_FIPS = 22031; Territory_Table(8906,3) = 22031; % String mismatch
    Territory(8921,1).County_Name = 'Gray County'; Territory(8921,1).County_FIPS = 48179; Territory_Table(8921,3) = 48179; % String mismatch
    Territory(8972,1).County_Name = 'Gray County'; Territory(8972,1).County_FIPS = 48179; Territory_Table(8972,3) = 48179; % String mismatch
    Territory(8991,1).County_Name = 'Roberts County'; Territory(8991,1).County_FIPS = 48393; Territory_Table(8991,3) = 48393; % String mismatch
    Territory(9002,1).County_Name = 'Clay County'; Territory(9002,1).County_FIPS = 19041; Territory_Table(9002,3) = 19041; % String mismatch
    Territory(9045,1).County_Name = 'St. Croix County'; Territory(9045,1).County_FIPS = 55109; Territory_Table(9045,3) = 55109; % String mismatch
    Territory(9052,1).County_Name = 'St. Martin Parish'; Territory(9052,1).County_FIPS = 22099; Territory_Table(9052,3) = 22099; % String mismatch
    Territory(9165,1).County_Name = 'St. Joseph County'; Territory(9165,1).County_FIPS = 26149; Territory_Table(9165,3) = 26149; % String mismatch
    Territory(9273,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(9273,1).County_FIPS = 2290; Territory_Table(9273,3) = 2290; % String mismatch
    Territory(9274,1).County_Name = 'Valdez-Cordova Census Area'; Territory(9274,1).County_FIPS = 2261; Territory_Table(9274,3) = 2261; % String mismatch
    Territory(9279,1).County_Name = 'Green County'; Territory(9279,1).County_FIPS = 21087; Territory_Table(9279,3) = 21087; % String mismatch
    Territory(9292,1).County_Name = 'Skagway Municipality'; Territory(9292,1).County_FIPS = 2232; Territory_Table(9292,3) = 2232; % String mismatch
    Territory(9336,1).County_Name = 'St. Clair County'; Territory(9336,1).County_FIPS = 17163; Territory_Table(9336,3) = 17163; % String mismatch
    Territory(9367,1).County_Name = 'Skagway Municipality'; Territory(9367,1).County_FIPS = 2232; Territory_Table(9367,3) = 2232; % String mismatch
    Territory(9368,1).County_Name = 'Wrangell City and Borough'; Territory(9368,1).County_FIPS = 2280; Territory_Table(9368,3) = 2280; % String mismatch
    Territory(9458,1).County_Name = 'Jack County'; Territory(9458,1).County_FIPS = 48237; Territory_Table(9458,3) = 48237; % String mismatch
    Territory(9509,1).County_Name = 'Clay County'; Territory(9509,1).County_FIPS = 13061; Territory_Table(9509,3) = 13061; % String mismatch
    Territory(9555,1).County_Name = 'Lake County'; Territory(9555,1).County_FIPS = 27075; Territory_Table(9555,3) = 27075; % String mismatch
    Territory(9643,1).County_Name = 'St. Charles County'; Territory(9643,1).County_FIPS = 29183; Territory_Table(9643,3) = 29183; % String mismatch
    Territory(9644,1).County_Name = 'St. Francois County'; Territory(9644,1).County_FIPS = 29187; Territory_Table(9644,3) = 29187; % String mismatch
    Territory(9645,1).County_Name = 'St. Louis County'; Territory(9645,1).County_FIPS = 29189; Territory_Table(9645,3) = 29189; % String mismatch
    Territory(9646,1).County_Name = 'St. Louis City'; Territory(9646,1).County_FIPS = 29510; Territory_Table(9646,3) = 29510; % String mismatch
    Territory(9647,1).County_Name = 'Ste. Genevieve County'; Territory(9647,1).County_FIPS = 29186; Territory_Table(9647,3) = 29186; % String mismatch
    Territory(9868,1).County_Name = 'Alexandria City'; Territory(9868,1).County_FIPS = 51510; Territory_Table(9868,3) = 51510; % String mismatch
    Territory(9876,1).County_Name = 'Bedford County'; Territory(9876,1).County_FIPS = 51019; Territory_Table(9876,3) = 51019; % String mismatch
    Territory(9877,1).County_Name = 'Bedford City'; Territory(9877,1).County_FIPS = 51515; Territory_Table(9877,3) = 51515; % String mismatch
    Territory(9881,1).County_Name = 'Buena Vista City'; Territory(9881,1).County_FIPS = 51530; Territory_Table(9881,3) = 51530; % String mismatch
    Territory(9885,1).County_Name = 'Charlotte County'; Territory(9885,1).County_FIPS = 51037; Territory_Table(9885,3) = 51037; % String mismatch
    Territory(9886,1).County_Name = 'Charlottesville City'; Territory(9886,1).County_FIPS = 51540; Territory_Table(9886,3) = 51540; % String mismatch
    Territory(9887,1).County_Name = 'Chesapeake City'; Territory(9887,1).County_FIPS = 51550; Territory_Table(9887,3) = 51550; % String mismatch
    Territory(9890,1).County_Name = 'Colonial Heights City'; Territory(9890,1).County_FIPS = 51570; Territory_Table(9890,3) = 51570; % String mismatch
    Territory(9891,1).County_Name = 'Covington City'; Territory(9891,1).County_FIPS = 51580; Territory_Table(9891,3) = 51580; % String mismatch
    Territory(9895,1).County_Name = 'Emporia City'; Territory(9895,1).County_FIPS = 51595; Territory_Table(9895,3) = 51595; % String mismatch
    Territory(9897,1).County_Name = 'Fairfax County'; Territory(9897,1).County_FIPS = 51059; Territory_Table(9897,3) = 51059; % String mismatch
    Territory(9898,1).County_Name = 'Fairfax City'; Territory(9898,1).County_FIPS = 51600; Territory_Table(9898,3) = 51600; % String mismatch
    Territory(9899,1).County_Name = 'Falls Church City'; Territory(9899,1).County_FIPS = 51610; Territory_Table(9899,3) = 51610; % String mismatch
    Territory(9902,1).County_Name = 'Franklin County'; Territory(9902,1).County_FIPS = 51067; Territory_Table(9902,3) = 51067; % String mismatch
    Territory(9903,1).County_Name = 'Fredericksburg City'; Territory(9903,1).County_FIPS = 51630; Territory_Table(9903,3) = 51630; % String mismatch
    Territory(9909,1).County_Name = 'Hampton City'; Territory(9909,1).County_FIPS = 51650; Territory_Table(9909,3) = 51650; % String mismatch
    Territory(9911,1).County_Name = 'Harrisonburg City'; Territory(9911,1).County_FIPS = 51660; Territory_Table(9911,3) = 51660; % String mismatch
    Territory(9913,1).County_Name = 'Hopewell City'; Territory(9913,1).County_FIPS = 51670; Territory_Table(9913,3) = 51670; % String mismatch
    Territory(9920,1).County_Name = 'Lexington City'; Territory(9920,1).County_FIPS = 51678; Territory_Table(9920,3) = 51678; % String mismatch
    Territory(9925,1).County_Name = 'Manassas City'; Territory(9925,1).County_FIPS = 51683; Territory_Table(9925,3) = 51683; % String mismatch
    Territory(9931,1).County_Name = 'Newport News City'; Territory(9931,1).County_FIPS = 51700; Territory_Table(9931,3) = 51700; % String mismatch
    Territory(9932,1).County_Name = 'Norfolk City'; Territory(9932,1).County_FIPS = 51710; Territory_Table(9932,3) = 51710; % String mismatch
    Territory(9937,1).County_Name = 'Petersburg City'; Territory(9937,1).County_FIPS = 51730; Territory_Table(9937,3) = 51730; % String mismatch
    Territory(9939,1).County_Name = 'Poquoson City'; Territory(9939,1).County_FIPS = 51735; Territory_Table(9939,3) = 51735; % String mismatch
    Territory(9940,1).County_Name = 'Portsmouth City'; Territory(9940,1).County_FIPS = 51740; Territory_Table(9940,3) = 51740; % String mismatch
    Territory(9945,1).County_Name = 'Richmond County'; Territory(9945,1).County_FIPS = 51159; Territory_Table(9945,3) = 51159; % String mismatch
    Territory(9946,1).County_Name = 'Richmond City'; Territory(9946,1).County_FIPS = 51760; Territory_Table(9946,3) = 51760; % String mismatch
    Territory(9953,1).County_Name = 'Staunton City'; Territory(9953,1).County_FIPS = 51790; Territory_Table(9953,3) = 51790; % String mismatch
    Territory(9954,1).County_Name = 'Suffolk City'; Territory(9954,1).County_FIPS = 51800; Territory_Table(9954,3) = 51800; % String mismatch
    Territory(9957,1).County_Name = 'Virginia Beach City'; Territory(9957,1).County_FIPS = 51810; Territory_Table(9957,3) = 51810; % String mismatch
    Territory(9959,1).County_Name = 'Waynesboro City'; Territory(9959,1).County_FIPS = 51820; Territory_Table(9959,3) = 51820; % String mismatch
    Territory(9961,1).County_Name = 'Williamsburg City'; Territory(9961,1).County_FIPS = 51830; Territory_Table(9961,3) = 51830; % String mismatch
    Territory(9964,1).County_Name = 'St. Louis County'; Territory(9964,1).County_FIPS = 27137; Territory_Table(9964,3) = 27137; % String mismatch
    Territory(10000,1).County_Name = 'St. Joseph County'; Territory(10000,1).County_FIPS = 18141; Territory_Table(10000,3) = 18141; % String mismatch
    Territory(10132,1).County_Name = 'White County'; Territory(10132,1).County_FIPS = 17193; Territory_Table(10132,3) = 17193; % String mismatch
    Territory(10473,1).County_Name = 'Green County'; Territory(10473,1).County_FIPS = 55045; Territory_Table(10473,3) = 55045; % String mismatch
    Territory(10577,1).County_Name = 'Jack County'; Territory(10577,1).County_FIPS = 48237; Territory_Table(10577,3) = 48237; % String mismatch
    Territory(10593,1).County_Name = 'St. Francis County'; Territory(10593,1).County_FIPS = 5123; Territory_Table(10593,3) = 5123; % String mismatch
    Territory(10613,1).County_Name = 'Chester County'; Territory(10613,1).County_FIPS = 45023; Territory_Table(10613,3) = 45023; % String mismatch
    Territory(10617,1).County_Name = 'Wrangell City and Borough'; Territory(10617,1).County_FIPS = 2280; Territory_Table(10617,3) = 2280; % String mismatch
    Territory(10657,1).County_Name = 'Bedford County'; Territory(10657,1).County_FIPS = 51019; Territory_Table(10657,3) = 51019; % String mismatch
    Territory(10661,1).County_Name = 'Charlotte County'; Territory(10661,1).County_FIPS = 51037; Territory_Table(10661,3) = 51037; % String mismatch
    Territory(10693,1).County_Name = 'St. Tammany Parish'; Territory(10693,1).County_FIPS = 22103; Territory_Table(10693,3) = 22103; % String mismatch
    Territory(10993,1).County_Name = 'Clay County'; Territory(10993,1).County_FIPS = 19041; Territory_Table(10993,3) = 19041; % String mismatch
    Territory(11193,1).County_Name = 'St. Clair County'; Territory(11193,1).County_FIPS = 29185; Territory_Table(11193,3) = 29185; % String mismatch
    Territory(11236,1).County_Name = 'Skagway Municipality'; Territory(11236,1).County_FIPS = 2232; Territory_Table(11236,3) = 2232; % String mismatch
    Territory(11300,1).County_Name = 'Collin County'; Territory(11300,1).County_FIPS = 48085; Territory_Table(11300,3) = 48085; % String mismatch
    Territory(11317,1).County_Name = 'Jack County'; Territory(11317,1).County_FIPS = 48237; Territory_Table(11317,3) = 48237; % String mismatch
    Territory(11370,1).County_Name = 'Valdez-Cordova Census Area'; Territory(11370,1).County_FIPS = 2261; Territory_Table(11370,3) = 2261; % String mismatch
    Territory(11414,1).County_Name = 'Frederick County'; Territory(11414,1).County_FIPS = 51069; Territory_Table(11414,3) = 51069; % String mismatch
    Territory(11493,1).County_Name = 'St. Clair County'; Territory(11493,1).County_FIPS = 29185; Territory_Table(11493,3) = 29185; % String mismatch
    Territory(11526,1).County_Name = 'Collin County'; Territory(11526,1).County_FIPS = 48085; Territory_Table(11526,3) = 48085; % String mismatch
    Territory(11556,1).County_Name = 'Jack County'; Territory(11556,1).County_FIPS = 48237; Territory_Table(11556,3) = 48237; % String mismatch
    Territory(11642,1).County_Name = 'Harris County'; Territory(11642,1).County_FIPS = 48201; Territory_Table(11642,3) = 48201; % String mismatch
    Territory(11687,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(11687,1).County_FIPS = 2290; Territory_Table(11687,3) = 2290; % String mismatch
    Territory(11705,1).County_Name = 'De Witt County'; Territory(11705,1).County_FIPS = 17039; Territory_Table(11705,3) = 17039; % String mismatch
    Territory(11759,1).County_Name = 'St. Clair County'; Territory(11759,1).County_FIPS = 17163; Territory_Table(11759,3) = 17163; % String mismatch
    Territory(11768,1).County_Name = 'White County'; Territory(11768,1).County_FIPS = 17193; Territory_Table(11768,3) = 17193; % String mismatch
    Territory(11771,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(11771,1).County_FIPS = 2290; Territory_Table(11771,3) = 2290; % String mismatch 
    end
    
    
    if year == 2018
    Territory(110,1).County_Name = 'St. Clair County'; Territory(110,1).County_FIPS = 1117; Territory_Table(110,3) = 1117; % String mismatch
    Territory(125,1).County_Name = 'Prince of Wales-Hyder Census Area'; Territory(125,1).County_FIPS = 2201; Territory_Table(125,3) = 2201; % String mismatch
    Territory(126,1).County_Name = 'Skagway Municipality'; Territory(126,1).County_FIPS = 2232; Territory_Table(126,3) = 2232; % String mismatch
    Territory(127,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(127,1).County_FIPS = 2290; Territory_Table(127,3) = 2290; % String mismatch
    Territory(135,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(135,1).County_FIPS = 2290; Territory_Table(135,3) = 2290; % String mismatch
    Territory(248,1).County_Name = 'Bedford County'; Territory(248,1).County_FIPS = 51019; Territory_Table(248,3) = 51019; % String mismatch
    Territory(259,1).County_Name = 'Franklin County'; Territory(259,1).County_FIPS = 51067; Territory_Table(259,3) = 51067; % String mismatch
    Territory(260,1).County_Name = 'Carroll County'; Territory(260,1).County_FIPS = 51035; Territory_Table(260,3) = 51035; % https://en.wikipedia.org/wiki/Galax,_Virginia
    Territory(264,1).County_Name = 'Lynchburg City'; Territory(264,1).County_FIPS = 51680; Territory_Table(264,3) = 51680; % String mismatch
    Territory(270,1).County_Name = 'Roanoke County'; Territory(270,1).County_FIPS = 51161; Territory_Table(270,3) = 51161; % String mismatch
    Territory(271,1).County_Name = 'Roanoke City'; Territory(271,1).County_FIPS = 51770; Territory_Table(271,3) = 51770; % String mismatch
    Territory(380,1).County_Name = 'St. Francis County'; Territory(380,1).County_FIPS = 5123; Territory_Table(380,3) = 5123; % String mismatch
    Territory(414,1).County_Name = 'Lake County'; Territory(414,1).County_FIPS = 27075; Territory_Table(414,3) = 27075; % String mismatch
    Territory(476,1).County_Name = 'Baltimore City'; Territory(476,1).County_FIPS = 24510; Territory_Table(476,3) = 24510; % String mismatch
    Territory(482,1).County_Name = 'Prince Georges County'; Territory(482,1).County_FIPS = 24033; Territory_Table(482,3) = 24033; % String mismatch
    Territory(571,1).County_Name = 'Bedford County'; Territory(571,1).County_FIPS = 51019; Territory_Table(571,3) = 51019; % String mismatch
    Territory(746,1).County_Name = 'Valdez-Cordova Census Area'; Territory(746,1).County_FIPS = 2261; Territory_Table(746,3) = 2261; % String mismatch
    Territory(747,1).County_Name = 'St. Louis County'; Territory(747,1).County_FIPS = 27137; Territory_Table(747,3) = 27137; % String mismatch
    Territory(925,1).County_Name = 'Bristol City'; Territory(925,1).County_FIPS = 51520; Territory_Table(925,3) = 51520; % String mismatch
    Territory(931,1).County_Name = 'Green County'; Territory(931,1).County_FIPS = 55045; Territory_Table(931,3) = 55045; % String mismatch
    Territory(970,1).County_Name = 'St. Louis County'; Territory(970,1).County_FIPS = 27137; Territory_Table(970,3) = 27137; % String mismatch
    Territory(1121,1).County_Name = 'White County'; Territory(1121,1).County_FIPS = 17193; Territory_Table(1121,3) = 17193; % String mismatch
    Territory(1328,1).County_Name = 'De Soto Parish'; Territory(1328,1).County_FIPS = 22031; Territory_Table(1328,3) = 22031; % String mismatch
    Territory(1339,1).County_Name = 'St. Landry Parish'; Territory(1339,1).County_FIPS = 22097; Territory_Table(1339,3) = 22097; % String mismatch
    Territory(1340,1).County_Name = 'St. Martin Parish'; Territory(1340,1).County_FIPS = 22099; Territory_Table(1340,3) = 22099; % String mismatch
    Territory(1341,1).County_Name = 'St. Mary Parish'; Territory(1341,1).County_FIPS = 22101; Territory_Table(1341,3) = 22101; % String mismatch
    Territory(1342,1).County_Name = 'St. Tammany Parish'; Territory(1342,1).County_FIPS = 22103; Territory_Table(1342,3) = 22103; % String mismatch
    Territory(1490,1).County_Name = 'Wrangell City and Borough'; Territory(1490,1).County_FIPS = 2280; Territory_Table(1490,3) = 2280; % String mismatch
    Territory(1515,1).County_Name = 'Valdez-Cordova Census Area'; Territory(1515,1).County_FIPS = 2261; Territory_Table(1515,3) = 2261; % String mismatch
    Territory(1550,1).County_Name = 'Queen Annes County'; Territory(1550,1).County_FIPS = 24035; Territory_Table(1550,3) = 24035; % String mismatch
    Territory(1594,1).County_Name = 'St. Francois County'; Territory(1594,1).County_FIPS = 29187; Territory_Table(1594,3) = 29187; % String mismatch
    Territory(1595,1).County_Name = 'Ste. Genevieve County'; Territory(1595,1).County_FIPS = 29186; Territory_Table(1595,3) = 29186; % String mismatch
    Territory(1708,1).County_Name = 'St. Clair County'; Territory(1708,1).County_FIPS = 17163; Territory_Table(1708,3) = 17163; % String mismatch
    Territory(1857,1).County_Name = 'Will County'; Territory(1857,1).County_FIPS = 17197; Territory_Table(1857,3) = 17197; % String mismatch
    Territory(1862,1).County_Name = 'Suffolk City'; Territory(1862,1).County_FIPS = 51800; Territory_Table(1862,3) = 51800; % String mismatch
    Territory(1970,1).County_Name = 'St. Clair County'; Territory(1970,1).County_FIPS = 26147; Territory_Table(1970,3) = 26147; % String mismatch
    Territory(1971,1).County_Name = 'St. Joseph County'; Territory(1971,1).County_FIPS = 26149; Territory_Table(1971,3) = 26149; % String mismatch
    Territory(2014,1).County_Name = 'St. Clair County'; Territory(2014,1).County_FIPS = 1117; Territory_Table(2014,3) = 1117; % String mismatch
    Territory(2016,1).County_Name = 'Valdez-Cordova Census Area'; Territory(2016,1).County_FIPS = 2261; Territory_Table(2016,3) = 2261; % String mismatch
    Territory(2020,1).County_Name = 'Lake County'; Territory(2020,1).County_FIPS = 27075; Territory_Table(2020,3) = 27075; % String mismatch
    Territory(2021,1).County_Name = 'St. Louis County'; Territory(2021,1).County_FIPS = 27137; Territory_Table(2021,3) = 27137; % String mismatch
    Territory(2025,1).County_Name = 'De Witt County'; Territory(2025,1).County_FIPS = 17039; Territory_Table(2025,3) = 17039; % String mismatch
    Territory(2087,1).County_Name = 'Roanoke County'; Territory(2087,1).County_FIPS = 51161; Territory_Table(2087,3) = 51161; % String mismatch
    Territory(2175,1).County_Name = 'St. Charles County'; Territory(2175,1).County_FIPS = 29183; Territory_Table(2175,3) = 29183; % String mismatch
    Territory(2223,1).County_Name = 'Danville City'; Territory(2223,1).County_FIPS = 51590; Territory_Table(2223,3) = 51590; % String mismatch
    Territory(2309,1).County_Name = 'Queen Annes County'; Territory(2309,1).County_FIPS = 24035; Territory_Table(2309,3) = 24035; % String mismatch
    Territory(2321,1).County_Name = 'Collin County'; Territory(2321,1).County_FIPS = 48085; Territory_Table(2321,3) = 48085; % String mismatch
    Territory(2349,1).County_Name = 'St. Clair County'; Territory(2349,1).County_FIPS = 26147; Territory_Table(2349,3) = 26147; % String mismatch
    Territory(2372,1).County_Name = 'St. Helena Parish'; Territory(2372,1).County_FIPS = 22091; Territory_Table(2372,3) = 22091; % String mismatch
    Territory(2475,1).County_Name = 'Chester County'; Territory(2475,1).County_FIPS = 45023; Territory_Table(2475,3) = 45023; % String mismatch
    Territory(2496,1).County_Name = 'St. Croix County'; Territory(2496,1).County_FIPS = 55109; Territory_Table(2496,3) = 55109; % String mismatch
    Territory(2524,1).County_Name = 'St. Clair County'; Territory(2524,1).County_FIPS = 17163; Territory_Table(2524,3) = 17163; % String mismatch
    Territory(2646,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(2646,1).County_FIPS = 2290; Territory_Table(2646,3) = 2290; % String mismatch
    Territory(2687,1).County_Name = 'St. Louis County'; Territory(2687,1).County_FIPS = 27137; Territory_Table(2687,3) = 27137; % String mismatch
    Territory(2706,1).County_Name = 'St. Clair County'; Territory(2706,1).County_FIPS = 29185; Territory_Table(2706,3) = 29185; % String mismatch
    Territory(2730,1).County_Name = 'Chester County'; Territory(2730,1).County_FIPS = 45023; Territory_Table(2730,3) = 45023; % String mismatch
    Territory(2752,1).County_Name = 'Green County'; Territory(2752,1).County_FIPS = 55045; Territory_Table(2752,3) = 55045; % String mismatch
    Territory(2788,1).County_Name = 'Collin County'; Territory(2788,1).County_FIPS = 48085; Territory_Table(2788,3) = 48085; % String mismatch
    Territory(2804,1).County_Name = 'Collin County'; Territory(2804,1).County_FIPS = 48085; Territory_Table(2804,3) = 48085; % String mismatch
    Territory(2824,1).County_Name = 'De Witt County'; Territory(2824,1).County_FIPS = 17039; Territory_Table(2824,3) = 17039; % String mismatch
    Territory(2829,1).County_Name = 'Green County'; Territory(2829,1).County_FIPS = 21087; Territory_Table(2829,3) = 21087; % String mismatch
    Territory(2843,1).County_Name = 'Collin County'; Territory(2843,1).County_FIPS = 48085; Territory_Table(2843,3) = 48085; % String mismatch
    Territory(2846,1).County_Name = 'St. Francois County'; Territory(2846,1).County_FIPS = 29187; Territory_Table(2846,3) = 29187; % String mismatch
    Territory(2978,1).County_Name = 'Miami-Dade County'; Territory(2978,1).County_FIPS = 12086; Territory_Table(2978,3) = 12086; % String mismatch
    Territory(2988,1).County_Name = 'St. Johns County'; Territory(2988,1).County_FIPS = 12109; Territory_Table(2988,3) = 12109; % String mismatch
    Territory(2989,1).County_Name = 'St. Lucie County'; Territory(2989,1).County_FIPS = 12111; Territory_Table(2989,3) = 12111; % String mismatch
    Territory(3047,1).County_Name = 'Jack County'; Territory(3047,1).County_FIPS = 48237; Territory_Table(3047,3) = 48237; % String mismatch
    Territory(3056,1).County_Name = 'St. Lucie County'; Territory(3056,1).County_FIPS = 12111; Territory_Table(3056,3) = 12111; % String mismatch
    Territory(3085,1).County_Name = 'Franklin City'; Territory(3085,1).County_FIPS = 51620; Territory_Table(3085,3) = 51620; % String mismatch
    Territory(3088,1).County_Name = 'Suffolk City'; Territory(3088,1).County_FIPS = 51800; Territory_Table(3088,3) = 51800; % String mismatch
    Territory(3108,1).County_Name = 'St. Clair County'; Territory(3108,1).County_FIPS = 17163; Territory_Table(3108,3) = 17163; % String mismatch
    Territory(3152,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3152,1).County_FIPS = 2290; Territory_Table(3152,3) = 2290; % String mismatch
    Territory(3225,1).County_Name = 'Clay County'; Territory(3225,1).County_FIPS = 13061; Territory_Table(3225,3) = 13061; % String mismatch
    Territory(3367,1).County_Name = 'St. Louis County'; Territory(3367,1).County_FIPS = 27137; Territory_Table(3367,3) = 27137; % String mismatch
    Territory(3409,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3409,1).County_FIPS = 2290; Territory_Table(3409,3) = 2290; % String mismatch
    Territory(3471,1).County_Name = 'Collin County'; Territory(3471,1).County_FIPS = 48085; Territory_Table(3471,3) = 48085; % String mismatch
    Territory(3479,1).County_Name = 'Gray County'; Territory(3479,1).County_FIPS = 48179; Territory_Table(3479,3) = 48179; % String mismatch
    Territory(3482,1).County_Name = 'Roberts County'; Territory(3482,1).County_FIPS = 48393; Territory_Table(3482,3) = 48393; % String mismatch
    Territory(3583,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3583,1).County_FIPS = 2290; Territory_Table(3583,3) = 2290; % String mismatch
    Territory(3756,1).County_Name = 'St. Louis County'; Territory(3756,1).County_FIPS = 27137; Territory_Table(3756,3) = 27137; % String mismatch
    Territory(3785,1).County_Name = 'St. Clair County'; Territory(3785,1).County_FIPS = 17163; Territory_Table(3785,3) = 17163; % String mismatch
    Territory(3855,1).County_Name = 'Miami-Dade County'; Territory(3855,1).County_FIPS = 12086; Territory_Table(3855,3) = 12086; % String mismatch
    Territory(3893,1).County_Name = 'Harris County'; Territory(3893,1).County_FIPS = 48201; Territory_Table(3893,3) = 48201; % String mismatch
    Territory(3917,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3917,1).County_FIPS = 2290; Territory_Table(3917,3) = 2290; % String mismatch
    Territory(3936,1).County_Name = 'Ada County'; Territory(3936,1).County_FIPS = 16001; Territory_Table(3936,3) = 16001; % String mismatch
    Territory(3965,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(3965,1).County_FIPS = 2290; Territory_Table(3965,3) = 2290; % String mismatch
    Territory(4043,1).County_Name = 'St. Joseph County'; Territory(4043,1).County_FIPS = 18141; Territory_Table(4043,3) = 18141; % String mismatch
    Territory(4053,1).County_Name = 'St. Joseph County'; Territory(4053,1).County_FIPS = 26149; Territory_Table(4053,3) = 26149; % String mismatch
    Territory(4094,1).County_Name = 'Clay County'; Territory(4094,1).County_FIPS = 19041; Territory_Table(4094,3) = 19041; % String mismatch
    Territory(4163,1).County_Name = 'Jack County'; Territory(4163,1).County_FIPS = 48237; Territory_Table(4163,3) = 48237; % String mismatch
    Territory(4167,1).County_Name = 'Clay County'; Territory(4167,1).County_FIPS = 19041; Territory_Table(4167,3) = 19041; % String mismatch
    Territory(4253,1).County_Name = 'St. Johns County'; Territory(4253,1).County_FIPS = 12109; Territory_Table(4253,3) = 12109; % String mismatch
    Territory(4257,1).County_Name = 'St. Johns County'; Territory(4257,1).County_FIPS = 12109; Territory_Table(4257,3) = 12109; % String mismatch
    Territory(4381,1).County_Name = 'St. Joseph County'; Territory(4381,1).County_FIPS = 18141; Territory_Table(4381,3) = 18141; % String mismatch
    Territory(4518,1).County_Name = 'Green County'; Territory(4518,1).County_FIPS = 21087; Territory_Table(4518,3) = 21087; % String mismatch
    Territory(4568,1).County_Name = 'Norton City'; Territory(4568,1).County_FIPS = 51720; Territory_Table(4568,3) = 51720; % String mismatch
    Territory(4599,1).County_Name = 'St. Louis City'; Territory(4599,1).County_FIPS = 29510; Territory_Table(4599,3) = 29510; % String mismatch
    Territory(4752,1).County_Name = 'Lake County'; Territory(4752,1).County_FIPS = 27075; Territory_Table(4752,3) = 27075; % String mismatch
    Territory(4754,1).County_Name = 'St. Louis County'; Territory(4754,1).County_FIPS = 27137; Territory_Table(4754,3) = 27137; % String mismatch
    Territory(4889,1).County_Name = 'Chester County'; Territory(4889,1).County_FIPS = 45023; Territory_Table(4889,3) = 45023; % String mismatch
    Territory(4951,1).County_Name = 'Jefferson County'; Territory(4951,1).County_FIPS = 22051; Territory_Table(4951,3) = 22051; % String mismatch
    Territory(4969,1).County_Name = 'St. Helena Parish'; Territory(4969,1).County_FIPS = 22091; Territory_Table(4969,3) = 22091; % String mismatch
    Territory(4970,1).County_Name = 'St. Bernard Parish'; Territory(4970,1).County_FIPS = 22087; Territory_Table(4970,3) = 22087; % String mismatch
    Territory(4971,1).County_Name = 'St. Charles Parish'; Territory(4971,1).County_FIPS = 22089; Territory_Table(4971,3) = 22089; % String mismatch
    Territory(4972,1).County_Name = 'St. James Parish'; Territory(4972,1).County_FIPS = 22093; Territory_Table(4972,3) = 22093; % String mismatch
    Territory(4973,1).County_Name = 'St. John the Baptist Parish'; Territory(4973,1).County_FIPS = 22095; Territory_Table(4973,3) = 22095; % String mismatch
    Territory(4974,1).County_Name = 'St. Landry Parish'; Territory(4974,1).County_FIPS = 22097; Territory_Table(4974,3) = 22097; % String mismatch
    Territory(4975,1).County_Name = 'St. Martin Parish'; Territory(4975,1).County_FIPS = 22099; Territory_Table(4975,3) = 22099; % String mismatch
    Territory(4976,1).County_Name = 'St. Tammany Parish'; Territory(4976,1).County_FIPS = 22103; Territory_Table(4976,3) = 22103; % String mismatch
    Territory(5111,1).County_Name = 'Manassas City'; Territory(5111,1).County_FIPS = 51683; Territory_Table(5111,3) = 51683; % String mismatch
    Territory(5160,1).County_Name = 'St. Joseph County'; Territory(5160,1).County_FIPS = 18141; Territory_Table(5160,3) = 18141; % String mismatch
    Territory(5163,1).County_Name = 'Martinsville City'; Territory(5163,1).County_FIPS = 51690; Territory_Table(5163,3) = 51690; % String mismatch
    Territory(5170,1).County_Name = 'St. Clair County'; Territory(5170,1).County_FIPS = 17163; Territory_Table(5170,3) = 17163; % String mismatch
    Territory(5184,1).County_Name = 'St. Lawrence County'; Territory(5184,1).County_FIPS = 36089; Territory_Table(5184,3) = 36089; % String mismatch
    Territory(5186,1).County_Name = 'Matanuska-Susitna Borough'; Territory(5186,1).County_FIPS = 02170; Territory_Table(5186,3) = 02170; % String mismatch
    Territory(5231,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(5231,1).County_FIPS = 2290; Territory_Table(5231,3) = 2290; % String mismatch
    Territory(5305,1).County_Name = 'Charlotte County'; Territory(5305,1).County_FIPS = 51037; Territory_Table(5305,3) = 51037; % String mismatch
    Territory(5423,1).County_Name = 'St. Joseph County'; Territory(5423,1).County_FIPS = 18141; Territory_Table(5423,3) = 18141; % String mismatch
    Territory(5429,1).County_Name = 'St. Joseph County'; Territory(5429,1).County_FIPS = 26149; Territory_Table(5429,3) = 26149; % String mismatch
    Territory(5433,1).County_Name = 'Prince of Wales-Hyder Census Area'; Territory(5433,1).County_FIPS = 2201; Territory_Table(5433,3) = 2201; % String mismatch
    Territory(5605,1).County_Name = 'Lake County'; Territory(5605,1).County_FIPS = 27075; Territory_Table(5605,3) = 27075; % String mismatch
    Territory(5609,1).County_Name = 'St. Louis County'; Territory(5609,1).County_FIPS = 27137; Territory_Table(5609,3) = 27137; % String mismatch
    Territory(5624,1).County_Name = 'St. Joseph County'; Territory(5624,1).County_FIPS = 18141; Territory_Table(5624,3) = 18141; % String mismatch
    Territory(5645,1).County_Name = 'Jefferson County'; Territory(5645,1).County_FIPS = 28063; Territory_Table(5645,3) = 28063; % String mismatch
    Territory(5730,1).County_Name = 'St. Clair County'; Territory(5730,1).County_FIPS = 29185; Territory_Table(5730,3) = 29185; % String mismatch
    Territory(5800,1).County_Name = 'St. Clair County'; Territory(5800,1).County_FIPS = 17163; Territory_Table(5800,3) = 17163; % String mismatch
    Territory(5878,1).County_Name = 'St. Mary Parish'; Territory(5878,1).County_FIPS = 22101; Territory_Table(5878,3) = 22101; % String mismatch
    Territory(5918,1).County_Name = 'St. Louis County'; Territory(5918,1).County_FIPS = 27137; Territory_Table(5918,3) = 27137; % String mismatch
    Territory(5972,1).County_Name = 'Will County'; Territory(5972,1).County_FIPS = 17197; Territory_Table(5972,3) = 17197; % String mismatch
    Territory(6091,1).County_Name = 'St. Joseph County'; Territory(6091,1).County_FIPS = 18141; Territory_Table(6091,3) = 18141; % String mismatch
    Territory(6119,1).County_Name = 'St. Croix County'; Territory(6119,1).County_FIPS = 55109; Territory_Table(6119,3) = 55109; % String mismatch
    Territory(6241,1).County_Name = 'St. Lawrence County'; Territory(6241,1).County_FIPS = 36089; Territory_Table(6241,3) = 36089; % String mismatch
    Territory(6256,1).County_Name = 'Fairfax County'; Territory(6256,1).County_FIPS = 51059; Territory_Table(6256,3) = 51059; % String mismatch
    Territory(6259,1).County_Name = 'Manassas Park City'; Territory(6259,1).County_FIPS = 51685; Territory_Table(6259,3) = 51685; % String mismatch
    Territory(6277,1).County_Name = 'Green County'; Territory(6277,1).County_FIPS = 21087; Territory_Table(6277,3) = 21087; % String mismatch
    Territory(6373,1).County_Name = 'St. Louis County'; Territory(6373,1).County_FIPS = 27137; Territory_Table(6373,3) = 27137; % String mismatch
    Territory(6420,1).County_Name = 'St. Joseph County'; Territory(6420,1).County_FIPS = 18141; Territory_Table(6420,3) = 18141; % String mismatch
    Territory(6430,1).County_Name = 'Roberts County'; Territory(6430,1).County_FIPS = 48393; Territory_Table(6430,3) = 48393; % String mismatch
    Territory(6441,1).County_Name = 'Richmond County'; Territory(6441,1).County_FIPS = 51159; Territory_Table(6441,3) = 51159; % String mismatch
    Territory(6469,1).County_Name = 'St. Croix County'; Territory(6469,1).County_FIPS = 55109; Territory_Table(6469,3) = 55109; % String mismatch
    Territory(6899,1).County_Name = 'St. Clair County'; Territory(6899,1).County_FIPS = 29185; Territory_Table(6899,3) = 29185; % String mismatch
    Territory(7207,1).County_Name = 'De Soto Parish'; Territory(7207,1).County_FIPS = 22031; Territory_Table(7207,3) = 22031; % String mismatch
    Territory(7465,1).County_Name = 'Petersburg Census Area'; Territory(7465,1).County_FIPS = 02195; Territory_Table(7465,3) = 02195; % String mismatch
    Territory(7506,1).County_Name = 'St. Croix County'; Territory(7506,1).County_FIPS = 55109; Territory_Table(7506,3) = 55109; % String mismatch
    Territory(7606,1).County_Name = 'District of Columbia'; Territory(7606,1).County_FIPS = 11000; Territory_Table(7606,3) = 11000; % String mismatch
    Territory(7608,1).County_Name = 'Prince Georges County'; Territory(7608,1).County_FIPS = 24033; Territory_Table(7608,3) = 24033; % String mismatch
    Territory(7655,1).County_Name = 'St. Croix County'; Territory(7655,1).County_FIPS = 55109; Territory_Table(7655,3) = 55109; % String mismatch
    Territory(7692,1).County_Name = 'St. Louis County'; Territory(7692,1).County_FIPS = 27137; Territory_Table(7692,3) = 27137; % String mismatch
    Territory(7928,1).County_Name = 'Radford City'; Territory(7928,1).County_FIPS = 51750; Territory_Table(7928,3) = 51750; % String mismatch
    Territory(8052,1).County_Name = 'St. Croix County'; Territory(8052,1).County_FIPS = 55109; Territory_Table(8052,3) = 55109; % String mismatch
    Territory(8095,1).County_Name = 'Green County'; Territory(8095,1).County_FIPS = 55045; Territory_Table(8095,3) = 55045; % String mismatch
    Territory(8190,1).County_Name = 'St. Clair County'; Territory(8190,1).County_FIPS = 29185; Territory_Table(8190,3) = 29185; % String mismatch
    Territory(8202,1).County_Name = 'Roanoke County'; Territory(8202,1).County_FIPS = 51161; Territory_Table(8202,3) = 51161; % String mismatch
    Territory(8203,1).County_Name = 'Salem City'; Territory(8203,1).County_FIPS = 51775; Territory_Table(8203,3) = 51775; % String mismatch
    Territory(8297,1).County_Name = 'Harris County'; Territory(8297,1).County_FIPS = 48201; Territory_Table(8297,3) = 48201; % String mismatch
    Territory(8328,1).County_Name = 'Green County'; Territory(8328,1).County_FIPS = 55045; Territory_Table(8328,3) = 55045; % String mismatch
    Territory(8462,1).County_Name = 'Frederick County'; Territory(8462,1).County_FIPS = 51069; Territory_Table(8462,3) = 51069; % String mismatch
    Territory(8471,1).County_Name = 'Winchester City'; Territory(8471,1).County_FIPS = 51840; Territory_Table(8471,3) = 51840; % String mismatch
    Territory(8482,1).County_Name = 'Carson City'; Territory(8482,1).County_FIPS = 32510; Territory_Table(8482,3) = 32510; % String mismatch
    Territory(8511,1).County_Name = 'Clay County'; Territory(8511,1).County_FIPS = 19041; Territory_Table(8511,3) = 19041; % String mismatch
    Territory(8672,1).County_Name = 'St. Martin Parish'; Territory(8672,1).County_FIPS = 22099; Territory_Table(8672,3) = 22099; % String mismatch
    Territory(8673,1).County_Name = 'St. Mary Parish'; Territory(8673,1).County_FIPS = 22101; Territory_Table(8673,3) = 22101; % String mismatch
    Territory(8693,1).County_Name = 'White County'; Territory(8693,1).County_FIPS = 17193; Territory_Table(8693,3) = 17193; % String mismatch
    Territory(8760,1).County_Name = 'Prince Georges County'; Territory(8760,1).County_FIPS = 24033; Territory_Table(8760,3) = 24033; % String mismatch
    Territory(8761,1).County_Name = 'St. Marys County'; Territory(8761,1).County_FIPS = 24037; Territory_Table(8761,3) = 24037; % String mismatch
    Territory(8828,1).County_Name = 'Jefferson County'; Territory(8828,1).County_FIPS = 28063; Territory_Table(8828,3) = 28063; % String mismatch
    Territory(8837,1).County_Name = 'St. Landry Parish'; Territory(8837,1).County_FIPS = 22097; Territory_Table(8837,3) = 22097; % String mismatch
    Territory(8838,1).County_Name = 'St. Martin Parish'; Territory(8838,1).County_FIPS = 22099; Territory_Table(8838,3) = 22099; % String mismatch
    Territory(8877,1).County_Name = 'St. Clair County'; Territory(8877,1).County_FIPS = 17163; Territory_Table(8877,3) = 17163; % String mismatch
    Territory(8895,1).County_Name = 'De Soto Parish'; Territory(8895,1).County_FIPS = 22031; Territory_Table(8895,3) = 22031; % String mismatch
    Territory(8910,1).County_Name = 'Gray County'; Territory(8910,1).County_FIPS = 48179; Territory_Table(8910,3) = 48179; % String mismatch
    Territory(8961,1).County_Name = 'Gray County'; Territory(8961,1).County_FIPS = 48179; Territory_Table(8961,3) = 48179; % String mismatch
    Territory(8980,1).County_Name = 'Roberts County'; Territory(8980,1).County_FIPS = 48393; Territory_Table(8980,3) = 48393; % String mismatch
    Territory(8991,1).County_Name = 'Clay County'; Territory(8991,1).County_FIPS = 19041; Territory_Table(8991,3) = 19041; % String mismatch
    Territory(9034,1).County_Name = 'St. Croix County'; Territory(9034,1).County_FIPS = 55109; Territory_Table(9034,3) = 55109; % String mismatch
    Territory(9041,1).County_Name = 'St. Martin Parish'; Territory(9041,1).County_FIPS = 22099; Territory_Table(9041,3) = 22099; % String mismatch
    Territory(9154,1).County_Name = 'St. Joseph County'; Territory(9154,1).County_FIPS = 26149; Territory_Table(9154,3) = 26149; % String mismatch
    Territory(9262,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(9262,1).County_FIPS = 2290; Territory_Table(9262,3) = 2290; % String mismatch
    Territory(9263,1).County_Name = 'Valdez-Cordova Census Area'; Territory(9263,1).County_FIPS = 2261; Territory_Table(9263,3) = 2261; % String mismatch
    Territory(9268,1).County_Name = 'Green County'; Territory(9268,1).County_FIPS = 21087; Territory_Table(9268,3) = 21087; % String mismatch
    Territory(9283,1).County_Name = 'Skagway Municipality'; Territory(9283,1).County_FIPS = 2232; Territory_Table(9283,3) = 2232; % String mismatch
    Territory(9327,1).County_Name = 'St. Clair County'; Territory(9327,1).County_FIPS = 17163; Territory_Table(9327,3) = 17163; % String mismatch
    Territory(9358,1).County_Name = 'Skagway Municipality'; Territory(9358,1).County_FIPS = 2232; Territory_Table(9358,3) = 2232; % String mismatch
    Territory(9359,1).County_Name = 'Wrangell City and Borough'; Territory(9359,1).County_FIPS = 2280; Territory_Table(9359,3) = 2280; % String mismatch
    Territory(9451,1).County_Name = 'Jack County'; Territory(9451,1).County_FIPS = 48237; Territory_Table(9451,3) = 48237; % String mismatch
    Territory(9502,1).County_Name = 'Clay County'; Territory(9502,1).County_FIPS = 13061; Territory_Table(9502,3) = 13061; % String mismatch
    Territory(9548,1).County_Name = 'Lake County'; Territory(9548,1).County_FIPS = 27075; Territory_Table(9548,3) = 27075; % String mismatch
    Territory(9636,1).County_Name = 'St. Charles County'; Territory(9636,1).County_FIPS = 29183; Territory_Table(9636,3) = 29183; % String mismatch
    Territory(9637,1).County_Name = 'St. Francois County'; Territory(9637,1).County_FIPS = 29187; Territory_Table(9637,3) = 29187; % String mismatch
    Territory(9638,1).County_Name = 'St. Louis County'; Territory(9638,1).County_FIPS = 29189; Territory_Table(9638,3) = 29189; % String mismatch
    Territory(9639,1).County_Name = 'St. Louis City'; Territory(9639,1).County_FIPS = 29510; Territory_Table(9639,3) = 29510; % String mismatch
    Territory(9640,1).County_Name = 'Ste. Genevieve County'; Territory(9640,1).County_FIPS = 29186; Territory_Table(9640,3) = 29186; % String mismatch
    Territory(9865,1).County_Name = 'Alexandria City'; Territory(9865,1).County_FIPS = 51510; Territory_Table(9865,3) = 51510; % String mismatch
    Territory(9873,1).County_Name = 'Bedford County'; Territory(9873,1).County_FIPS = 51019; Territory_Table(9873,3) = 51019; % String mismatch
    Territory(9874,1).County_Name = 'Bedford City'; Territory(9874,1).County_FIPS = 51515; Territory_Table(9874,3) = 51515; % String mismatch
    Territory(9878,1).County_Name = 'Buena Vista City'; Territory(9878,1).County_FIPS = 51530; Territory_Table(9878,3) = 51530; % String mismatch
    Territory(9883,1).County_Name = 'Charlotte County'; Territory(9883,1).County_FIPS = 51037; Territory_Table(9883,3) = 51037; % String mismatch
    Territory(9884,1).County_Name = 'Charlottesville City'; Territory(9884,1).County_FIPS = 51540; Territory_Table(9884,3) = 51540; % String mismatch
    Territory(9885,1).County_Name = 'Chesapeake City'; Territory(9885,1).County_FIPS = 51550; Territory_Table(9885,3) = 51550; % String mismatch
    Territory(9888,1).County_Name = 'Colonial Heights City'; Territory(9888,1).County_FIPS = 51570; Territory_Table(9888,3) = 51570; % String mismatch
    Territory(9889,1).County_Name = 'Covington City'; Territory(9889,1).County_FIPS = 51580; Territory_Table(9889,3) = 51580; % String mismatch
    Territory(9893,1).County_Name = 'Emporia City'; Territory(9893,1).County_FIPS = 51595; Territory_Table(9893,3) = 51595; % String mismatch
    Territory(9895,1).County_Name = 'Fairfax County'; Territory(9895,1).County_FIPS = 51059; Territory_Table(9895,3) = 51059; % String mismatch
    Territory(9896,1).County_Name = 'Fairfax City'; Territory(9896,1).County_FIPS = 51600; Territory_Table(9896,3) = 51600; % String mismatch
    Territory(9897,1).County_Name = 'Falls Church City'; Territory(9897,1).County_FIPS = 51610; Territory_Table(9897,3) = 51610; % String mismatch
    Territory(9900,1).County_Name = 'Franklin County'; Territory(9900,1).County_FIPS = 51067; Territory_Table(9900,3) = 51067; % String mismatch
    Territory(9901,1).County_Name = 'Fredericksburg City'; Territory(9901,1).County_FIPS = 51630; Territory_Table(9901,3) = 51630; % String mismatch
    Territory(9907,1).County_Name = 'Hampton City'; Territory(9907,1).County_FIPS = 51650; Territory_Table(9907,3) = 51650; % String mismatch
    Territory(9909,1).County_Name = 'Harrisonburg City'; Territory(9909,1).County_FIPS = 51660; Territory_Table(9909,3) = 51660; % String mismatch
    Territory(9911,1).County_Name = 'Hopewell City'; Territory(9911,1).County_FIPS = 51670; Territory_Table(9911,3) = 51670; % String mismatch
    Territory(9918,1).County_Name = 'Lexington City'; Territory(9918,1).County_FIPS = 51678; Territory_Table(9918,3) = 51678; % String mismatch
    Territory(9923,1).County_Name = 'Manassas City'; Territory(9923,1).County_FIPS = 51683; Territory_Table(9923,3) = 51683; % String mismatch
    Territory(9929,1).County_Name = 'Newport News City'; Territory(9929,1).County_FIPS = 51700; Territory_Table(9929,3) = 51700; % String mismatch
    Territory(9930,1).County_Name = 'Norfolk City'; Territory(9930,1).County_FIPS = 51710; Territory_Table(9930,3) = 51710; % String mismatch
    Territory(9935,1).County_Name = 'Petersburg City'; Territory(9935,1).County_FIPS = 51730; Territory_Table(9935,3) = 51730; % String mismatch
    Territory(9937,1).County_Name = 'Poquoson City'; Territory(9937,1).County_FIPS = 51735; Territory_Table(9937,3) = 51735; % String mismatch
    Territory(9938,1).County_Name = 'Portsmouth City'; Territory(9938,1).County_FIPS = 51740; Territory_Table(9938,3) = 51740; % String mismatch
    Territory(9943,1).County_Name = 'Richmond County'; Territory(9943,1).County_FIPS = 51159; Territory_Table(9943,3) = 51159; % String mismatch
    Territory(9944,1).County_Name = 'Richmond City'; Territory(9944,1).County_FIPS = 51760; Territory_Table(9944,3) = 51760; % String mismatch
    Territory(9951,1).County_Name = 'Staunton City'; Territory(9951,1).County_FIPS = 51790; Territory_Table(9951,3) = 51790; % String mismatch
    Territory(9952,1).County_Name = 'Suffolk City'; Territory(9952,1).County_FIPS = 51800; Territory_Table(9952,3) = 51800; % String mismatch
    Territory(9955,1).County_Name = 'Virginia Beach City'; Territory(9955,1).County_FIPS = 51810; Territory_Table(9955,3) = 51810; % String mismatch
    Territory(9957,1).County_Name = 'Waynesboro City'; Territory(9957,1).County_FIPS = 51820; Territory_Table(9957,3) = 51820; % String mismatch
    Territory(9959,1).County_Name = 'Williamsburg City'; Territory(9959,1).County_FIPS = 51830; Territory_Table(9959,3) = 51830; % String mismatch
    Territory(9964,1).County_Name = 'St. Louis County'; Territory(9964,1).County_FIPS = 27137; Territory_Table(9964,3) = 27137; % String mismatch
    Territory(10000,1).County_Name = 'St. Joseph County'; Territory(10000,1).County_FIPS = 18141; Territory_Table(10000,3) = 18141; % String mismatch
    Territory(10132,1).County_Name = 'White County'; Territory(10132,1).County_FIPS = 17193; Territory_Table(10132,3) = 17193; % String mismatch
    Territory(10469,1).County_Name = 'Green County'; Territory(10469,1).County_FIPS = 55045; Territory_Table(10469,3) = 55045; % String mismatch
    Territory(10573,1).County_Name = 'Jack County'; Territory(10573,1).County_FIPS = 48237; Territory_Table(10573,3) = 48237; % String mismatch
    Territory(10589,1).County_Name = 'St. Francis County'; Territory(10589,1).County_FIPS = 5123; Territory_Table(10589,3) = 5123; % String mismatch
    Territory(10610,1).County_Name = 'Chester County'; Territory(10610,1).County_FIPS = 45023; Territory_Table(10610,3) = 45023; % String mismatch
    Territory(10614,1).County_Name = 'Wrangell City and Borough'; Territory(10614,1).County_FIPS = 2280; Territory_Table(10614,3) = 2280; % String mismatch
    Territory(10654,1).County_Name = 'Bedford County'; Territory(10654,1).County_FIPS = 51019; Territory_Table(10654,3) = 51019; % String mismatch
    Territory(10658,1).County_Name = 'Charlotte County'; Territory(10658,1).County_FIPS = 51037; Territory_Table(10658,3) = 51037; % String mismatch
    Territory(10690,1).County_Name = 'St. Tammany Parish'; Territory(10690,1).County_FIPS = 22103; Territory_Table(10690,3) = 22103; % String mismatch
    Territory(10990,1).County_Name = 'Clay County'; Territory(10990,1).County_FIPS = 19041; Territory_Table(10990,3) = 19041; % String mismatch
    Territory(11190,1).County_Name = 'St. Clair County'; Territory(11190,1).County_FIPS = 29185; Territory_Table(11190,3) = 29185; % String mismatch
    Territory(11233,1).County_Name = 'Skagway Municipality'; Territory(11233,1).County_FIPS = 2232; Territory_Table(11233,3) = 2232; % String mismatch
    Territory(11297,1).County_Name = 'Collin County'; Territory(11297,1).County_FIPS = 48085; Territory_Table(11297,3) = 48085; % String mismatch
    Territory(11314,1).County_Name = 'Jack County'; Territory(11314,1).County_FIPS = 48237; Territory_Table(11314,3) = 48237; % String mismatch
    Territory(11367,1).County_Name = 'Valdez-Cordova Census Area'; Territory(11367,1).County_FIPS = 2261; Territory_Table(11367,3) = 2261; % String mismatch
    Territory(11411,1).County_Name = 'Frederick County'; Territory(11411,1).County_FIPS = 51069; Territory_Table(11411,3) = 51069; % String mismatch
    Territory(11490,1).County_Name = 'St. Clair County'; Territory(11490,1).County_FIPS = 29185; Territory_Table(11490,3) = 29185; % String mismatch
    Territory(11521,1).County_Name = 'Collin County'; Territory(11521,1).County_FIPS = 48085; Territory_Table(11521,3) = 48085; % String mismatch
    Territory(11552,1).County_Name = 'Jack County'; Territory(11552,1).County_FIPS = 48237; Territory_Table(11552,3) = 48237; % String mismatch
    Territory(11640,1).County_Name = 'Harris County'; Territory(11640,1).County_FIPS = 48201; Territory_Table(11640,3) = 48201; % String mismatch
    Territory(11685,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(11685,1).County_FIPS = 2290; Territory_Table(11685,3) = 2290; % String mismatch
    Territory(11703,1).County_Name = 'De Witt County'; Territory(11703,1).County_FIPS = 17039; Territory_Table(11703,3) = 17039; % String mismatch
    Territory(11757,1).County_Name = 'St. Clair County'; Territory(11757,1).County_FIPS = 17163; Territory_Table(11757,3) = 17163; % String mismatch
    Territory(11766,1).County_Name = 'White County'; Territory(11766,1).County_FIPS = 17193; Territory_Table(11766,3) = 17193; % String mismatch
    Territory(11769,1).County_Name = 'Yukon-Koyukuk Census Area'; Territory(11769,1).County_FIPS = 2290; Territory_Table(11769,3) = 2290; % String mismatch
    end
    
    % Loop over the rows and order the metadata fields alphebetically:
    for row = 1:size(Territory,1)
        Dummy(row,1) = orderfields(Territory(row,1));
    end
    Territory = Dummy;
    clear row Dummy
    
    % Rename the two key variables and save the output:
    Service_Territory = Territory; clear Territory
    Service_Territory_Table = Territory_Table; clear Territory_Table
    save(service_territory_mat,'Service_Territory','Service_Territory_Table');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end