% NERC_Region_Information_From_NERC_Region_Short_Name.m
% 20190409
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Lookup table that takes as input the abbreviation or short name of a
% NERC region and returns an in-house numeric code assigned to that NERC region 
% and the full or long name of the NERC region. The source
% of the lookup table is https://www.eia.gov/electricity/data/eia411/. A simplified version of
% this lookup table is included in the "Legend.xlxs" spreadsheet.

function [NERC_Region_Code,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Short_Name(NERC_Region_Short_Name)
    if size(NERC_Region_Short_Name,2) == 2
       if NERC_Region_Short_Name == 'AK'; NERC_Region_Code = 1;  NERC_Region_Long_Name = 'Alaska'; end
       if NERC_Region_Short_Name == 'HI'; NERC_Region_Code = 2;  NERC_Region_Long_Name = 'Hawaii'; end
       if NERC_Region_Short_Name == 'NY'; NERC_Region_Code = 4;  NERC_Region_Long_Name = 'Northeast Power Coordinating Council'; end % Reassigned to NPSS - Judgement call
       if NERC_Region_Short_Name == 'RF'; NERC_Region_Code = 11; NERC_Region_Long_Name = 'Midcontinent Independent System Operator'; end % Reassigned to MISO - Judgement call
    end
    if size(NERC_Region_Short_Name,2) == 3
       if NERC_Region_Short_Name == 'MRO'; NERC_Region_Code = 3;  NERC_Region_Long_Name = 'Midwest Reliability Organization'; end
       if NERC_Region_Short_Name == 'RFC'; NERC_Region_Code = 5;  NERC_Region_Long_Name = 'Reliability First Corporation'; end
       if NERC_Region_Short_Name == 'SPP'; NERC_Region_Code = 7;  NERC_Region_Long_Name = 'Southwest Power Pool'; end
       if NERC_Region_Short_Name == 'TRE'; NERC_Region_Code = 9;  NERC_Region_Long_Name = 'Texas Reliability Entity'; end
    end
    if size(NERC_Region_Short_Name,2) == 4
       if NERC_Region_Short_Name == 'NPCC'; NERC_Region_Code = 4;  NERC_Region_Long_Name = 'Northeast Power Coordinating Council'; end
       if NERC_Region_Short_Name == 'SERC'; NERC_Region_Code = 6;  NERC_Region_Long_Name = 'Southeastern Electric Reliability Council'; end
       if NERC_Region_Short_Name == 'WECC'; NERC_Region_Code = 8;  NERC_Region_Long_Name = 'Western Electricity Coordinating Council'; end
       if NERC_Region_Short_Name == 'MISO'; NERC_Region_Code = 11; NERC_Region_Long_Name = 'Midcontinent Independent System Operator'; end
       if NERC_Region_Short_Name == 'FRCC'; NERC_Region_Code = 12; NERC_Region_Long_Name = 'Florida Reliability Coordinating Council'; end
       if NERC_Region_Short_Name == 'HICC'; NERC_Region_Code = 2;  NERC_Region_Long_Name = 'Hawaii'; end
       if NERC_Region_Short_Name == 'ECAR'; NERC_Region_Code = -9999; NERC_Region_Long_Name = 'Missing'; end; % https://www.eia.gov/electricity/data/eia411/eia411_rcn.php
    end
    if size(NERC_Region_Short_Name,2) == 5
       if NERC_Region_Short_Name == 'ERCOT'; NERC_Region_Code = 9; NERC_Region_Long_Name = 'Texas Reliability Entity'; end % Reassigned to TRE - Judgement call
    end
end