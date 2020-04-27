% Process_Manual_Corrections_2018.m
% 20190424
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Manually correct obvious errors to enhance spatial consistency of 
% BAs and NERC regions.

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
    
    % Correct utilities in Loving County, TX to be in the TRE NERC region and 
    % to report to the TRE BA.
    County_Row = 2674;
    BA_Code = 14; [BA_Short_Name,EIA_BA_Number,BA_Long_Name] = BA_Information_From_BA_Code(BA_Code);
    NERC_Region_Code = 9; [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(NERC_Region_Code);
    for i = 1
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end