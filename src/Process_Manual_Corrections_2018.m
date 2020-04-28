% Process_Manual_Corrections_2018.m
% 20190424
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Manually correct to enhance spatial consistency of BAs and NERC regions.
% NERC region corrections were implemented for counties that had more than 
% one NERC region with valid data and were spatially removed more than 1-county 
% in any direction from the contiguous NERC region they were originally 
% assigned to.

function Process_Manual_Corrections_2018(output_summary,year)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Load in the Utility to BA to NERC region to county dataset:
    load([output_summary,'.mat']);
    
    % Correct utilities in Lincoln County, NV to be in the WECC and report
    % to the Nevada Power Company BA.
    County_Row = 1756;
    BA_Code = 31; [BA_Short_Name,EIA_BA_Number,BA_Long_Name] = BA_Information_From_BA_Code(BA_Code);
    NERC_Region_Code = 8; [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(NERC_Region_Code);
    for i = 1:4
        County_Metadata(County_Row).Utilities(i).BA_Code = BA_Code;
        County_Metadata(County_Row).Utilities(i).BA_Short_Name = BA_Short_Name;
        County_Metadata(County_Row).Utilities(i).BA_Long_Name = BA_Long_Name;
        County_Metadata(County_Row).Utilities(i).BA_Number = EIA_BA_Number;
        County_Metadata(County_Row).Utilities(i).NERC_Region_Code = NERC_Region_Code;
        County_Metadata(County_Row).Utilities(i).NERC_Region_Short_Name = NERC_Region_Short_Name;
        County_Metadata(County_Row).Utilities(i).NERC_Region_Long_Name = NERC_Region_Long_Name;
    end
    County_Metadata_Table(County_Row,8:11) = [1,BA_Code,1,NERC_Region_Code];
    clear i County_Row BA_Code NERC_Region_Code
    
    % Assign Accomack County, VA to have a primary NERC reigon of RFC.
    % Accomackhas utilities that report both RFC and the SERC as their NERC
    % region. This is done to enhance spatial consistency.
    County_Row = 2821;
    NERC_Region_Code = 5; [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(NERC_Region_Code);
    County_Metadata_Table(County_Row,11) = [NERC_Region_Code];
    clear County_Row BA_Code NERC_Region_Code
    
    % Assign Cuming County, NE to have a primary NERC reigon of MRO.
    % Cuming has utilities that report both MRO and the SPP as their NERC
    % region. This is done to enhance spatial consistency.
    County_Row = 1674;
    NERC_Region_Code = 3; [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(NERC_Region_Code);
    County_Metadata_Table(County_Row,11) = [NERC_Region_Code];
    clear County_Row BA_Code NERC_Region_Code
    
    % Assign Hardeman County, TX to have a primary NERC reigon and BA of SPP.
    % Hardeman has utilities that report both TRE and the SPP as their NERC
    % region. This is done to enhance spatial consistency with the BA assigned
    % for Hardeman and neighboring counties.
    County_Row = 2622;
    NERC_Region_Code = 7;
    BA_Code = 51;
    County_Metadata_Table(County_Row,9) = [BA_Code];
    County_Metadata_Table(County_Row,11) = [NERC_Region_Code];
    clear County_Row BA_Code NERC_Region_Code
    
    % Assign Evangeline Parish, LA and Saint Mary Parish, LA to have a primary NERC reigon of SERC.
    % Both have utilities that report both SERC and the SPP as their NERC
    % region. This is done to enhance spatial consistency.
    NERC_Region_Code = 6; [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(NERC_Region_Code);
    County_Row = 1133;
    County_Metadata_Table(County_Row,11) = [NERC_Region_Code];
    County_Row = 1164;
    County_Metadata_Table(County_Row,11) = [NERC_Region_Code];
    clear County_Row BA_Code NERC_Region_Code
    
    % Correct select counties in Texas to assign them to the ERCO BA.
    % This mapping was done subjectively based on the NERC region for those
    % counties.
    BA_Code = 14; [BA_Short_Name,EIA_BA_Number,BA_Long_Name] = BA_Information_From_BA_Code(BA_Code);
    County_Rows = [2575,2602,2637,2674,2761,2771];
    for row = 1:size(County_Rows,2)
        for i = 1:size(County_Metadata(County_Rows(1,row)).Utilities,1)
            County_Metadata(County_Rows(1,row)).Utilities(i).BA_Code = BA_Code;
            County_Metadata(County_Rows(1,row)).Utilities(i).BA_Short_Name = BA_Short_Name;
            County_Metadata(County_Rows(1,row)).Utilities(i).BA_Long_Name = BA_Long_Name;
            County_Metadata(County_Rows(1,row)).Utilities(i).BA_Number = EIA_BA_Number;
        end
        County_Metadata_Table(County_Rows(1,row),8:9) = [1,BA_Code];
        clear i
    end
    clear row County_Rows BA_Code BA_Short_Name EIA_BA_Number BA_Long_Name
    
    % Assign Pike County, AL to have a primary BA of SOCO.
    % Pike has utilities that report both SOCO and AEC as their BA. 
    % This is done to enhance spatial consistency.
    County_Row = 55;
    BA_Code = 48; [BA_Short_Name,EIA_BA_Number,BA_Long_Name] = BA_Information_From_BA_Code(BA_Code);
    County_Metadata_Table(County_Row,9) = [BA_Code];
    clear County_Row BA_Code
    
    i = 0;
    for row = 1:size(County_Metadata,1)
        if isempty(County_Metadata(row,1).Utilities) == 0
           for j = 1:size(County_Metadata(row,1).Utilities,1)
               i = i + 1;
               Output_Cell{i,1} = {num2str(County_Metadata(row,1).Utilities(j,:).County_FIPS)}; % County FIPS
               Output_Cell{i,2} = {County_Metadata(row,1).Utilities(j,:).County_Name}; % County Name
               Output_Cell{i,3} = {num2str(County_Metadata(row,1).Utilities(j,:).State_FIPS)}; % State FIPS
               Output_Cell{i,4} = {County_Metadata(row,1).Utilities(j,:).State_String}; % State Name
               Output_Cell{i,5} = {num2str(County_Metadata(row,1).Utilities(j,:).Utility_Number)}; % Utility Number
               Output_Cell{i,6} = {County_Metadata(row,1).Utilities(j,:).Utility_Name}; % Utility Name
               if isnan(County_Metadata(row,1).Utilities(j,:).Total_Sales) == 0
                  Output_Cell{i,7} = {num2str(County_Metadata(row,1).Utilities(j,:).Total_Sales)}; % Total Sales in Year
               else
                  Output_Cell{i,7} = num2str(-9999);
               end
               if isempty(County_Metadata(row,1).Utilities(j,:).NERC_Region_Code) == 0
                  Output_Cell{i,8} = {num2str(County_Metadata(row,1).Utilities(j,:).NERC_Region_Code)}; % NERC Region Code
               else
                  Output_Cell{i,8} = num2str(-9999);
               end
               if isempty(County_Metadata(row,1).Utilities(j,:).NERC_Region_Long_Name) == 0
                  Output_Cell{i,9} = {County_Metadata(row,1).Utilities(j,:).NERC_Region_Long_Name}; % NERC Region Long Name
               else
                  Output_Cell{i,9} = 'Missing';
               end
               if isempty(County_Metadata(row,1).Utilities(j,:).NERC_Region_Short_Name) == 0
                  Output_Cell{i,10} = {County_Metadata(row,1).Utilities(j,:).NERC_Region_Short_Name}; % NERC Region Short Name
               else
                  Output_Cell{i,10} = 'Missing';
               end
               if isempty(County_Metadata(row,1).Utilities(j,:).BA_Code) == 0
                  Output_Cell{i,11} = {num2str(County_Metadata(row,1).Utilities(j,:).BA_Code)}; % BA Code
               else
                  Output_Cell{i,11} = num2str(-9999);
               end
               if isempty(County_Metadata(row,1).Utilities(j,:).BA_Number) == 0
                  Output_Cell{i,12} = {num2str(County_Metadata(row,1).Utilities(j,:).BA_Number)}; % BA Number
               else
                  Output_Cell{i,12} = num2str(-9999);
               end
               if isempty(County_Metadata(row,1).Utilities(j,:).BA_Long_Name) == 0
                  Output_Cell{i,13} = {County_Metadata(row,1).Utilities(j,:).BA_Long_Name}; % BA Long Name
               else
                  Output_Cell{i,13} = 'Missing';
               end
               if isempty(County_Metadata(row,1).Utilities(j,:).BA_Short_Name) == 0
                  Output_Cell{i,14} = {County_Metadata(row,1).Utilities(j,:).BA_Short_Name}; % BA Short Name
               else
                  Output_Cell{i,14} = 'Missing';
               end
           end
           clear j
        else
           i = i + 1;
           Output_Cell{i,1} = {num2str(County_Metadata(row,1).County_FIPS)}; % County FIPS
           Output_Cell{i,2} = {County_Metadata(row,1).County}; % County Name
           Output_Cell{i,3} = {num2str(County_Metadata(row,1).State_FIPS)}; % State FIPS
           Output_Cell{i,4} = {County_Metadata(row,1).State}; % State Name
           Output_Cell{i,5} = {num2str(-9999)}; % Utility Number 
           Output_Cell{i,6} = 'Missing';
           Output_Cell{i,7} = num2str(-9999);
           Output_Cell{i,8} = num2str(-9999);
           Output_Cell{i,9} = 'Missing';
           Output_Cell{i,10} = 'Missing';
           Output_Cell{i,11} = num2str(-9999);
           Output_Cell{i,12} = num2str(-9999);
           Output_Cell{i,13} = 'Missing';
           Output_Cell{i,14} = 'Missing';
        end
    end
    clear row i
    
    Output_Table = cell2table(Output_Cell);
    Output_Table.Properties.VariableNames = {'County_FIPS','County_Name','State_FIPS','State_Name','Utility_Number','Utility_Name','Total_Sales_MWh','NERC_Region_Code',...
                                             'NERC_Region_Long_Name','NERC_Region_Short_Name','BA_Code','BA_Number','BA_Long_Name','BA_Short_Name'};
                                         
    % Save the output:
    writetable(Output_Table,[output_summary,'_with_Manual_Corrections.csv'],'Delimiter',',','WriteVariableNames',1);
    save([output_summary,'_with_Manual_Corrections.mat'],'County_Metadata','County_Metadata_Table');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end