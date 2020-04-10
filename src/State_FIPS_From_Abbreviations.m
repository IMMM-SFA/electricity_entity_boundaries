% State_FIPS_From_State_Abbreviations.m
% 20190409
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Lookup table that takes as input the abbreviation or short name of a
% state and returns the base FIPS code for that state as well as the full
% or long name of the state.

function [State_FIPS,State_String] = State_FIPS_From_State_Abbreviations(State_Abbreviation)
    if State_Abbreviation == 'AL'; State_FIPS = 1000;  State_String = 'Alabama'; end
    if State_Abbreviation == 'AK'; State_FIPS = 2000;  State_String = 'Alaska'; end
    if State_Abbreviation == 'AZ'; State_FIPS = 4000;  State_String = 'Arizona'; end
    if State_Abbreviation == 'AR'; State_FIPS = 5000;  State_String = 'Arkansas'; end
    if State_Abbreviation == 'CA'; State_FIPS = 6000;  State_String = 'California'; end
    if State_Abbreviation == 'CO'; State_FIPS = 8000;  State_String = 'Colorado'; end
    if State_Abbreviation == 'CT'; State_FIPS = 9000;  State_String = 'Connecticut'; end
    if State_Abbreviation == 'DE'; State_FIPS = 10000; State_String = 'Delaware'; end
    if State_Abbreviation == 'DC'; State_FIPS = 11000; State_String = 'District of Columbia'; end
    if State_Abbreviation == 'FL'; State_FIPS = 12000; State_String = 'Florida'; end
    if State_Abbreviation == 'GA'; State_FIPS = 13000; State_String = 'Georgia'; end
    if State_Abbreviation == 'HI'; State_FIPS = 15000; State_String = 'Hawaii'; end
    if State_Abbreviation == 'ID'; State_FIPS = 16000; State_String = 'Idaho'; end
    if State_Abbreviation == 'IL'; State_FIPS = 17000; State_String = 'Illinois'; end
    if State_Abbreviation == 'IN'; State_FIPS = 18000; State_String = 'Indiana'; end
    if State_Abbreviation == 'IA'; State_FIPS = 19000; State_String = 'Iowa'; end
    if State_Abbreviation == 'KS'; State_FIPS = 20000; State_String = 'Kansas'; end
    if State_Abbreviation == 'KY'; State_FIPS = 21000; State_String = 'Kentucky'; end
    if State_Abbreviation == 'LA'; State_FIPS = 22000; State_String = 'Louisiana'; end
    if State_Abbreviation == 'ME'; State_FIPS = 23000; State_String = 'Maine'; end
    if State_Abbreviation == 'MD'; State_FIPS = 24000; State_String = 'Maryland'; end
    if State_Abbreviation == 'MA'; State_FIPS = 25000; State_String = 'Massachusetts'; end
    if State_Abbreviation == 'MI'; State_FIPS = 26000; State_String = 'Michigan'; end
    if State_Abbreviation == 'MN'; State_FIPS = 27000; State_String = 'Minnesota'; end
    if State_Abbreviation == 'MS'; State_FIPS = 28000; State_String = 'Mississippi'; end
    if State_Abbreviation == 'MO'; State_FIPS = 29000; State_String = 'Missouri'; end
    if State_Abbreviation == 'MT'; State_FIPS = 30000; State_String = 'Montana'; end
    if State_Abbreviation == 'NE'; State_FIPS = 31000; State_String = 'Nebraska'; end
    if State_Abbreviation == 'NV'; State_FIPS = 32000; State_String = 'Nevada'; end
    if State_Abbreviation == 'NH'; State_FIPS = 33000; State_String = 'New Hampshire'; end
    if State_Abbreviation == 'NJ'; State_FIPS = 34000; State_String = 'New Jersey'; end
    if State_Abbreviation == 'NM'; State_FIPS = 35000; State_String = 'New Mexico'; end
    if State_Abbreviation == 'NY'; State_FIPS = 36000; State_String = 'New York'; end
    if State_Abbreviation == 'NC'; State_FIPS = 37000; State_String = 'North Carolina'; end
    if State_Abbreviation == 'ND'; State_FIPS = 38000; State_String = 'North Dakota'; end
    if State_Abbreviation == 'OH'; State_FIPS = 39000; State_String = 'Ohio'; end
    if State_Abbreviation == 'OK'; State_FIPS = 40000; State_String = 'Oklahoma'; end
    if State_Abbreviation == 'OR'; State_FIPS = 41000; State_String = 'Oregon'; end
    if State_Abbreviation == 'PA'; State_FIPS = 42000; State_String = 'Pennsylvania'; end
    if State_Abbreviation == 'RI'; State_FIPS = 44000; State_String = 'Rhode Island'; end
    if State_Abbreviation == 'SC'; State_FIPS = 45000; State_String = 'South Carolina'; end
    if State_Abbreviation == 'SD'; State_FIPS = 46000; State_String = 'South Dakota'; end
    if State_Abbreviation == 'TN'; State_FIPS = 47000; State_String = 'Tennessee'; end
    if State_Abbreviation == 'TX'; State_FIPS = 48000; State_String = 'Texas'; end
    if State_Abbreviation == 'UT'; State_FIPS = 49000; State_String = 'Utah'; end
    if State_Abbreviation == 'VT'; State_FIPS = 50000; State_String = 'Vermont'; end
    if State_Abbreviation == 'VA'; State_FIPS = 51000; State_String = 'Virginia'; end
    if State_Abbreviation == 'WA'; State_FIPS = 53000; State_String = 'Washington'; end
    if State_Abbreviation == 'WV'; State_FIPS = 54000; State_String = 'West Virginia'; end
    if State_Abbreviation == 'WI'; State_FIPS = 55000; State_String = 'Wisconsin'; end
    if State_Abbreviation == 'WY'; State_FIPS = 56000; State_String = 'Wyoming'; end
    if State_Abbreviation == 'CN'; State_FIPS = -9999; State_String = 'Canada'; end % Canada; State FIPS set to missing
end