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
    
    % Assign Hardeman County, TX to have a primary NERC reigon of SPP.
    % Hardeman has utilities that report both TRE and the SPP as their NERC
    % region. This is done to enhance spatial consistency with the BA assigned
    % for Hardeman and neighboring counties.
    County_Row = 2622;
    NERC_Region_Code = 7; [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(NERC_Region_Code);
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end