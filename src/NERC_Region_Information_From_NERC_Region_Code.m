% NERC_Region_Information_From_NERC_Region_Code.m
% 20190409
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Lookup table that takes as input the in-house numeric code assigned to that NERC region 
% and returns the abbreviation or short name as well as the full or long
% name of the NERC region. A simplified version of
% this lookup table is included in the "Legend.xlxs" spreadsheet.

function [NERC_Region_Short_Name,NERC_Region_Long_Name] = NERC_Region_Information_From_NERC_Region_Code(NERC_Region_Code)
       if NERC_Region_Code == 1;     NERC_Region_Short_Name = 'AK';    NERC_Region_Long_Name = 'Alaska'; end
       if NERC_Region_Code == 2;     NERC_Region_Short_Name = 'HI';    NERC_Region_Long_Name = 'Hawaii'; end
       if NERC_Region_Code == 3;     NERC_Region_Short_Name = 'MRO';   NERC_Region_Long_Name = 'Midwest Reliability Organization'; end
       if NERC_Region_Code == 4;     NERC_Region_Short_Name = 'NPCC';  NERC_Region_Long_Name = 'Northeast Power Coordinating Council'; end
       if NERC_Region_Code == 5;     NERC_Region_Short_Name = 'RFC';   NERC_Region_Long_Name = 'Reliability First Corporation'; end
       if NERC_Region_Code == 6;     NERC_Region_Short_Name = 'SERC';  NERC_Region_Long_Name = 'Southeastern Electric Reliability Council'; end
       if NERC_Region_Code == 7;     NERC_Region_Short_Name = 'SPP';   NERC_Region_Long_Name = 'Southwest Power Pool'; end
       if NERC_Region_Code == 8;     NERC_Region_Short_Name = 'WECC';  NERC_Region_Long_Name = 'Western Electricity Coordinating Council'; end
       if NERC_Region_Code == 9;     NERC_Region_Short_Name = 'TRE';   NERC_Region_Long_Name = 'Texas Reliability Entity'; end
       if NERC_Region_Code == 10;    NERC_Region_Short_Name = 'ERCOT'; NERC_Region_Long_Name = 'Texas Reliability Entity'; end % Reassigned to TRE; Judgement call.
       if NERC_Region_Code == 11;    NERC_Region_Short_Name = 'MISO';  NERC_Region_Long_Name = 'Midcontinent Independent System Operator'; end
       if NERC_Region_Code == 12;    NERC_Region_Short_Name = 'FRCC';  NERC_Region_Long_Name = 'Florida Reliability Coordinating Council'; end
       if NERC_Region_Code == -9999; NERC_Region_Short_Name = 'N/A';   NERC_Region_Long_Name = 'Missing'; end
end