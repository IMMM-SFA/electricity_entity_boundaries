% BA_Information_From_BA_Short_Name.m
% 20190409
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Lookup table that takes as input the abbreviation or short name of a
% BA and returns the EIA BA number, an in-house numeric
% code assigned to that BA, and the full or long name of the BA. The source
% of the lookup table is the "Balancing_Authority_2017" spreadsheet
% included as part of the Form EIA-861 dataset. A simplified version of
% this lookup table is included in the "Legend.xlxs" spreadsheet.

function [BA_Code,EIA_BA_Number,BA_Long_Name] = BA_Information_From_BA_Short_Name(BA_Short_Name)
    if size(BA_Short_Name,2) == 2    
       if BA_Short_Name == 'NA'; BA_Code = 29; EIA_BA_Number = -9999; BA_Long_Name = 'Missing'; end
       if BA_Short_Name == 'SC'; BA_Code = 43; EIA_BA_Number = 17543; BA_Long_Name = 'South Carolina Public Service Authority'; end
    end
    if size(BA_Short_Name,2) == 3    
       if BA_Short_Name == 'AVA'; BA_Code = 3;  EIA_BA_Number = 20169; BA_Long_Name = 'Avista Corporation'; end
       if BA_Short_Name == 'CEA'; BA_Code = 7;  EIA_BA_Number = 3522;  BA_Long_Name = 'Chugach Electric Association, Inc.'; end
       if BA_Short_Name == 'DUK'; BA_Code = 12; EIA_BA_Number = 5416;  BA_Long_Name = 'Duke Energy Carolinas'; end
       if BA_Short_Name == 'EPE'; BA_Code = 13; EIA_BA_Number = 5701;  BA_Long_Name = 'El Paso Electric Compnay'; end
       if BA_Short_Name == 'FPC'; BA_Code = 16; EIA_BA_Number = 6455;  BA_Long_Name = 'Duke Energy Florida'; end
       if BA_Short_Name == 'FPL'; BA_Code = 17; EIA_BA_Number = 6452;  BA_Long_Name = 'Florida Power and Light Company'; end
       if BA_Short_Name == 'GVL'; BA_Code = 19; EIA_BA_Number = 6909;  BA_Long_Name = 'Gainesville Regional Utilities'; end
       if BA_Short_Name == 'HST'; BA_Code = 21; EIA_BA_Number = 8795;  BA_Long_Name = 'City of Homestead'; end
       if BA_Short_Name == 'IID'; BA_Code = 22; EIA_BA_Number = 9216;  BA_Long_Name = 'Imperial Irrigation District'; end
       if BA_Short_Name == 'JEA'; BA_Code = 25; EIA_BA_Number = 9617;  BA_Long_Name = 'JEA'; end % Don't know the long name of this entity, but its associated with Jacksonville, FL
       if BA_Short_Name == 'NSB'; BA_Code = 32; EIA_BA_Number = 13485; BA_Long_Name = 'City of New Smyrna Beach'; end
       if BA_Short_Name == 'PGE'; BA_Code = 38; EIA_BA_Number = 15248; BA_Long_Name = 'Portland General Electric'; end
       if BA_Short_Name == 'PJM'; BA_Code = 39; EIA_BA_Number = 14725; BA_Long_Name = 'PJM Interconnection, LLC'; end
       if BA_Short_Name == 'PNM'; BA_Code = 40; EIA_BA_Number = 15473; BA_Long_Name = 'Public Service Co. of New Mexico'; end
       if BA_Short_Name == 'SCL'; BA_Code = 45; EIA_BA_Number = 16868; BA_Long_Name = 'Seattle City Light'; end
       if BA_Short_Name == 'SEC'; BA_Code = 46; EIA_BA_Number = 21554; BA_Long_Name = 'Seminole Electric Cooperative'; end
       if BA_Short_Name == 'SPA'; BA_Code = 49; EIA_BA_Number = 17716; BA_Long_Name = 'Southwestern Power Administration'; end
       if BA_Short_Name == 'SRP'; BA_Code = 50; EIA_BA_Number = 16572; BA_Long_Name = 'Salt River Project'; end
       if BA_Short_Name == 'TAL'; BA_Code = 52; EIA_BA_Number = 18445; BA_Long_Name = 'City of Tallahassee'; end
       if BA_Short_Name == 'TEC'; BA_Code = 53; EIA_BA_Number = 18454; BA_Long_Name = 'Tampa Electric Company'; end
       if BA_Short_Name == 'TVA'; BA_Code = 57; EIA_BA_Number = 18642; BA_Long_Name = 'Tennessee Valley Authority'; end
       if BA_Short_Name == 'AEC'; BA_Code = 61; EIA_BA_Number = 189;   BA_Long_Name = 'PowerSouth Energy Cooperative'; end
       if BA_Short_Name == 'YAD'; BA_Code = 62; EIA_BA_Number = 317;   BA_Long_Name = 'Alcoa Power Generating, Inc. - Yadkin Division'; end
       if BA_Short_Name == 'EEI'; BA_Code = 65; EIA_BA_Number = 5748;  BA_Long_Name = 'Electric Energy, Inc.'; end
       if BA_Short_Name == 'GWA'; BA_Code = 70; EIA_BA_Number = 56365; BA_Long_Name = 'NaturEner Power Watch, LLC (GWA)'; end
       if BA_Short_Name == 'WWA'; BA_Code = 71; EIA_BA_Number = 58791; BA_Long_Name = 'NaturEner Wind Watch, LLC'; end
    end
    if size(BA_Short_Name,2) == 4    
       if BA_Short_Name == 'AECI'; BA_Code = 1;  EIA_BA_Number = 924;   BA_Long_Name = 'Associated Electric Cooperative, Inc.'; end
       if BA_Short_Name == 'AMPL'; BA_Code = 2;  EIA_BA_Number = 599;   BA_Long_Name = 'Anchorage Municipal Light and Power'; end
       if BA_Short_Name == 'AZPS'; BA_Code = 4;  EIA_BA_Number = 803;   BA_Long_Name = 'Arizona Public Service Company'; end
       if BA_Short_Name == 'BANC'; BA_Code = 5;  EIA_BA_Number = 16534; BA_Long_Name = 'Balancing Authority of Northern California'; end
       if BA_Short_Name == 'BPAT'; BA_Code = 6;  EIA_BA_Number = 1738;  BA_Long_Name = 'Bonneville Power Administration - Transmission'; end
       if BA_Short_Name == 'CHPD'; BA_Code = 8;  EIA_BA_Number = 3413;  BA_Long_Name = 'PUD No. 1 of Chelan County'; end
       if BA_Short_Name == 'CISO'; BA_Code = 9;  EIA_BA_Number = 2775;  BA_Long_Name = 'California Independent System Operator'; end
       if BA_Short_Name == 'CPLE'; BA_Code = 10; EIA_BA_Number = 3046;  BA_Long_Name = 'Duke Energy Progress East'; end
       if BA_Short_Name == 'DOPD'; BA_Code = 11; EIA_BA_Number = 5326;  BA_Long_Name = 'PUD No. 1 of Douglas County'; end
       if BA_Short_Name == 'ERCO'; BA_Code = 14; EIA_BA_Number = 5723;  BA_Long_Name = 'Electric Reliability Council of Texas'; end
       if BA_Short_Name == 'FMPP'; BA_Code = 15; EIA_BA_Number = 14610; BA_Long_Name = 'Florida Municipal Power Pool'; end
       if BA_Short_Name == 'GCPD'; BA_Code = 18; EIA_BA_Number = 14624; BA_Long_Name = 'PUD No. 2 of Grant County'; end
       if BA_Short_Name == 'HECO'; BA_Code = 20; EIA_BA_Number = 19547; BA_Long_Name = 'Hawaiian Electric Company, Inc.'; end
       if BA_Short_Name == 'IPCO'; BA_Code = 23; EIA_BA_Number = 9191;  BA_Long_Name = 'Idaho Power Company'; end
       if BA_Short_Name == 'ISNE'; BA_Code = 24; EIA_BA_Number = 13434; BA_Long_Name = 'ISO New England Inc.'; end
       if BA_Short_Name == 'LDWP'; BA_Code = 26; EIA_BA_Number = 11208; BA_Long_Name = 'Los Angeles Department of Water and Power'; end
       if BA_Short_Name == 'LGEE'; BA_Code = 27; EIA_BA_Number = 11249; BA_Long_Name = 'Louisville Gas & Electric and Kentucky Utilities'; end
       if BA_Short_Name == 'MISO'; BA_Code = 28; EIA_BA_Number = 56669; BA_Long_Name = 'Midcontinent Independent System Operator'; end
       if BA_Short_Name == 'NBSO'; BA_Code = 30; EIA_BA_Number = 1;     BA_Long_Name = 'New Brunswick System Operator'; end
       if BA_Short_Name == 'NEVP'; BA_Code = 31; EIA_BA_Number = 13407; BA_Long_Name = 'Nevada Power Company'; end
       if BA_Short_Name == 'NWMT'; BA_Code = 33; EIA_BA_Number = 12825; BA_Long_Name = 'NorthWestern Energy - Montana'; end
       if BA_Short_Name == 'NYIS'; BA_Code = 34; EIA_BA_Number = 13501; BA_Long_Name = 'New York Independent System Operator'; end
       if BA_Short_Name == 'OVEC'; BA_Code = 35; EIA_BA_Number = 14015; BA_Long_Name = 'Ohio Valley Electric Corporation'; end
       if BA_Short_Name == 'PACE'; BA_Code = 36; EIA_BA_Number = 14379; BA_Long_Name = 'PacifiCorp - East'; end
       if BA_Short_Name == 'PACW'; BA_Code = 37; EIA_BA_Number = 14378; BA_Long_Name = 'PacifiCorp - West'; end
       if BA_Short_Name == 'PSCO'; BA_Code = 41; EIA_BA_Number = 15466; BA_Long_Name = 'Public Service Co. of Colorado'; end
       if BA_Short_Name == 'PSEI'; BA_Code = 42; EIA_BA_Number = 15500; BA_Long_Name = 'Puget Sound Energy Inc.'; end
       if BA_Short_Name == 'SCEG'; BA_Code = 44; EIA_BA_Number = 17539; BA_Long_Name = 'South Carolina Electric & Gas Company'; end
       if BA_Short_Name == 'SEPA'; BA_Code = 47; EIA_BA_Number = 29304; BA_Long_Name = 'Southeastern Power Administration'; end
       if BA_Short_Name == 'SOCO'; BA_Code = 48; EIA_BA_Number = 18195; BA_Long_Name = 'Southern Company Services, Inc. - Transmission'; end
       if BA_Short_Name == 'SWPP'; BA_Code = 51; EIA_BA_Number = 59504; BA_Long_Name = 'Southwest Power Pool'; end
       if BA_Short_Name == 'TEPC'; BA_Code = 54; EIA_BA_Number = 24211; BA_Long_Name = 'Tucson Electric Power Company'; end
       if BA_Short_Name == 'TIDC'; BA_Code = 55; EIA_BA_Number = 19281; BA_Long_Name = 'Turlock Irrigation District'; end
       if BA_Short_Name == 'TPWR'; BA_Code = 56; EIA_BA_Number = 18429; BA_Long_Name = 'City of Tacoma'; end
       if BA_Short_Name == 'WACM'; BA_Code = 58; EIA_BA_Number = 28503; BA_Long_Name = 'Western Area Power Administration - Rocky Mountain Region'; end
       if BA_Short_Name == 'WALC'; BA_Code = 59; EIA_BA_Number = 25471; BA_Long_Name = 'Western Area Power Administration - Desert Southwest Region'; end
       if BA_Short_Name == 'WAUW'; BA_Code = 60; EIA_BA_Number = 19610; BA_Long_Name = 'Western Area Power Administration - UGP West'; end
       if BA_Short_Name == 'DEAA'; BA_Code = 63; EIA_BA_Number = 56812; BA_Long_Name = 'Arlington Valley, LLC - AVBA'; end
       if BA_Short_Name == 'CPLW'; BA_Code = 64; EIA_BA_Number = 58786; BA_Long_Name = 'Duke Energy Progress West'; end
       if BA_Short_Name == 'GRMA'; BA_Code = 66; EIA_BA_Number = 14412; BA_Long_Name = 'Gila River Power, LLC'; end
       if BA_Short_Name == 'GRID'; BA_Code = 67; EIA_BA_Number = 58790; BA_Long_Name = 'Gridforce Energy Management, LLC'; end
       if BA_Short_Name == 'GRIS'; BA_Code = 68; EIA_BA_Number = 56545; BA_Long_Name = 'Gridforce South'; end
       if BA_Short_Name == 'GRIF'; BA_Code = 69; EIA_BA_Number = 56090; BA_Long_Name = 'Griffith Energy, LLC'; end
       if BA_Short_Name == 'HGMA'; BA_Code = 72; EIA_BA_Number = 32790; BA_Long_Name = 'New Harquahala Generating Company, LLC - HGBA'; end
       if BA_Short_Name == 'WAUE'; BA_Code = 73; EIA_BA_Number = 28502; BA_Long_Name = 'Western Area Power Administration - UGP East'; end
   end
end