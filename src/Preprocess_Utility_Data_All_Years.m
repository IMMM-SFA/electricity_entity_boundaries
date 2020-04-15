% Preprocess_Utility_Data_All_Years.m
% 20200414
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Convert the "Utility_Data_YYYY.xlsx" Excel spreadsheet into a Matlab
% structure by extracting relevant metadata.

function Preprocess_Utility_Data_All_Years(utility_data_xlsx,utility_data_mat,year)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Define how many rows to read in based on the year being processed:
    if year == 2016
       rows = 2277;
    elseif year == 2017
       rows = 2287;
    elseif year == 2018
       rows = 2292;
    end
    
    % Read the raw data from the spreadsheet into a cell structure:
    [~,~,Raw_Data] = xlsread(utility_data_xlsx,'States',['B3:N',num2str(rows)]);
    Raw_Data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data)) = {''};

    % Loop over all of the utilities to extract relevant metadata:
    for row = 1:size(Raw_Data,1)
        % Look up state information from the state abbreviation:
        if isempty(Raw_Data{row,3}) == 0
           [State_FIPS,State_String] = State_FIPS_From_Abbreviations(Raw_Data{row,3});
        else
           State_FIPS = -9999;
           State_String = 'Missing';
        end

        % Look up NERC region information from the NERC abbreviation:
        if isempty(Raw_Data{row,5}) == 0
           NERC_Region_Short_Name = Raw_Data{row,5};
           % Catch a few errors:
           if year == 2016 & row == 671
              NERC_Region_Short_Name = 'SERC'; % Reason: Correcting for lack of capitalization
           elseif year == 2016 & row == 757
              NERC_Region_Short_Name = 'SERC'; % Reason: Two NERC regions were listed so use the first one given
           elseif year == 2016 & row == 1015
              NERC_Region_Short_Name = 'TRE'; % Reason: Two NERC regions were listed so use the first one given
           elseif year == 2016 & row == 2190
              NERC_Region_Short_Name = 'NPCC'; % Reason: Correcting for lack of capitalization
           elseif year == 2016 & row == 2247
              NERC_Region_Short_Name = 'WECC'; % Reason: Correcting for lack of capitalization
           end
           if year == 2017 & row == 670
              NERC_Region_Short_Name = 'SERC'; % Reason: Correcting for lack of capitalization
           elseif year == 2017 & row == 755
              NERC_Region_Short_Name = 'SERC'; % Reason: Two NERC regions were listed so use the first one given
           elseif year == 2017 & row == 1012
              NERC_Region_Short_Name = 'TRE'; % Reason: Two NERC regions were listed so use the first one given
           elseif year == 2017 & row == 2177
              NERC_Region_Short_Name = 'NPCC'; % Reason: Correcting for lack of capitalization
           end
           if year == 2018 & row == 1010
              NERC_Region_Short_Name = 'TRE'; % Reason: Two NERC regions were listed so use the first one given
           end
           [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Short_Name(NERC_Region_Short_Name);
        else
           % If the NERC region is missing, try searching through the columns
           % of the "Also operating in other NERC regions" section to see if
           % some other region was listed:
           i = 0;
           if isempty(Raw_Data{row,6}) == 0  & Raw_Data{row,6} == 'Y';  [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('TRE');  NERC_Region_Short_Name = 'TRE';  i = 1; end
           if isempty(Raw_Data{row,7}) == 0  & Raw_Data{row,7} == 'Y';  [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('FRCC'); NERC_Region_Short_Name = 'FRCC'; i = 1; end
           if isempty(Raw_Data{row,8}) == 0  & Raw_Data{row,8} == 'Y';  [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('MRO');  NERC_Region_Short_Name = 'MRO';  i = 1; end
           if isempty(Raw_Data{row,9}) == 0  & Raw_Data{row,9} == 'Y';  [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('NPCC'); NERC_Region_Short_Name = 'NPCC'; i = 1; end
           if isempty(Raw_Data{row,10}) == 0 & Raw_Data{row,10} == 'Y'; [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('RFC');  NERC_Region_Short_Name = 'RFC';  i = 1; end
           if isempty(Raw_Data{row,11}) == 0 & Raw_Data{row,11} == 'Y'; [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('SERC'); NERC_Region_Short_Name = 'SERC'; i = 1; end
           if isempty(Raw_Data{row,12}) == 0 & Raw_Data{row,12} == 'Y'; [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('SPP');  NERC_Region_Short_Name = 'SPP';  i = 1; end
           if isempty(Raw_Data{row,13}) == 0 & Raw_Data{row,13} == 'Y'; [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_From_Short_Name('WECC'); NERC_Region_Short_Name = 'WECC'; i = 1; end
           % If no other region was listed then assign a missing value for that utility NERC region:
           if i == 0
              NERC_Region_Code = -9999;
              NERC_Region_Long_Name = 'Missing';
              NERC_Region_Short_Name = 'Missing';
           end
           clear i
        end

        % Extract the metadata into a structure:
        Utility(row,1).Utility_Number = Raw_Data{row,1}; % EIA Utility #
        Utility(row,1).Utility_Long_Name = Raw_Data{row,2}; % Utility Long Name
        Utility(row,1).State_FIPS = State_FIPS; % State FIPS
        Utility(row,1).State_String = State_String; % State String
        Utility(row,1).State_Abbreviation = Raw_Data{row,3}; % State Abbreviation
        Utility(row,1).NERC_Region_Code = NERC_Region_Code; % NERC Region #
        Utility(row,1).NERC_Region_Long_Name = NERC_Region_Long_Name; % NERC_Region_Long_Name
        Utility(row,1).NERC_Region_Short_Name = NERC_Region_Short_Name; % NERC_Region_Short_Name

        % Extract key variables into a table which is easier to search/filter:
        if isempty(Utility(row,1).Utility_Number) == 0; Utility_Table(row,1) = Utility(row,1).Utility_Number; else; Utility_Table(row,1) = NaN.*0; end
        if isempty(Utility(row,1).State_FIPS) == 0; Utility_Table(row,2) = Utility(row,1).State_FIPS; else; Utility_Table(row,2) = NaN.*0; end
        if isempty(Utility(row,1).NERC_Region_Code) == 0; Utility_Table(row,3) = Utility(row,1).NERC_Region_Code; else; Utility_Table(row,3) = NaN.*0; end

        clear State_FIPS State_String NERC_Region_Number NERC_Region_Long_Name NERC_Region_Short_Name NERC_Region_Code
    end
    clear row Raw_Data
    
    % Manual assign the 'WAPA-- Western Area Power Administration' to be in the WECC. 
    % The specific line numbers vary by year which requires the manual fixes to be conditioned on the year
    % you're processing. This could be fixed, but I don't have time right now.
    if year == 2016
       [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(8);
       Utility(1921,1).NERC_Region_Code = 8;
       Utility(1921,1).NERC_Region_Long_Name = NERC_Region_Long_Name;
       Utility(1921,1).NERC_Region_Short_Name = NERC_Region_Short_Name;
       Utility_Table(1921,3) = 8;
       clear NERC_Region_Short_Name NERC_Region_Long_Name
    end
    if year == 2017
       [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(8);
       Utility(1916,1).NERC_Region_Code = 8;
       Utility(1916,1).NERC_Region_Long_Name = NERC_Region_Long_Name;
       Utility(1916,1).NERC_Region_Short_Name = NERC_Region_Short_Name;
       Utility_Table(1916,3) = 8;
       clear NERC_Region_Short_Name NERC_Region_Long_Name
    end
    if year == 2018
       [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(8);
       Utility(1909,1).NERC_Region_Code = 8;
       Utility(1909,1).NERC_Region_Long_Name = NERC_Region_Long_Name;
       Utility(1909,1).NERC_Region_Short_Name = NERC_Region_Short_Name;
       Utility_Table(1909,3) = 8;
       clear NERC_Region_Short_Name NERC_Region_Long_Name
    end

    % Loop over the rows and order the metadata fields alphebetically:
    for row = 1:size(Utility,1)
        Dummy(row,1) = orderfields(Utility(row,1));
    end
    Utility = Dummy;
    clear row Dummy
    
    % Save the output:
    save(utility_data_mat,'Utility','Utility_Table');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end