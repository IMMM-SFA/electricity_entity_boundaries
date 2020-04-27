% Process_Entity_Relationships_All_Years.m
% 20190415
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Using the 1:1 mappings scattered throughout the EIA-861 dataset, jointly
% map utilities to BAs to NERC regions to counties for all utilities.

function Process_Entity_Relationships_All_Years(county_metadata,sales_ult_customer,service_territory,utility_data,output_summary)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Load the county metadata dataset:
    load([county_metadata,'.mat']);

    % Load the Sales to Ultimate Customers dataset that contains the
    % utility to balancing authority mapping:
    load([sales_ult_customer,'.mat']);
    Utility_to_BA = Utility;
    Utility_to_BA_Table = Utility_Table;
    clear Utility Utility_Table

    % Load the Utility Data dataset that contains the utility to NERC region
    % mapping:
    load([utility_data,'.mat']);
    Utility_to_NERC = Utility;
    Utility_to_NERC_Table = Utility_Table;
    clear Utility Utility_Table

    % Load the Service Territory dataset that contains the utility to county
    % mapping:
    load([service_territory,'.mat']);

    % Loop through the Service_Territory dataset and match utilities to NERC regions:
    for row = 1:size(Service_Territory_Table,1)
        if isempty(find(Utility_to_NERC_Table(:,1) == Service_Territory_Table(row,1))) == 0
           index = find(Utility_to_NERC_Table(:,1) == Service_Territory_Table(row,1));
           Service_Territory(row).NERC_Region_Code = Utility_to_NERC(index).NERC_Region_Code;
           Service_Territory(row).NERC_Region_Short_Name = Utility_to_NERC(index).NERC_Region_Short_Name;
           Service_Territory(row).NERC_Region_Long_Name = Utility_to_NERC(index).NERC_Region_Long_Name;
           clear index
        else
           Service_Territory(row).NERC_Region_Code = [];
           Service_Territory(row).NERC_Region_Short_Name = [];
           Service_Territory(row).NERC_Region_Long_Name = [];
        end
    end
    clear row Utility_to_NERC Utility_to_NERC_Table
    
    % Loop through the Service_Territory dataset and match utilities to BAs:
    for row = 1:size(Service_Territory_Table,1)
        if isempty(find(Utility_to_BA_Table(:,1) == Service_Territory_Table(row,1) & Utility_to_BA_Table(:,2) == Service_Territory_Table(row,2))) == 0;
           index = find(Utility_to_BA_Table(:,1) == Service_Territory_Table(row,1) & Utility_to_BA_Table(:,2) == Service_Territory_Table(row,2));
           Service_Territory(row).BA_Code = Utility_to_BA(index).BA_Code;
           Service_Territory(row).BA_Number = Utility_to_BA(index).BA_Number;
           Service_Territory(row).BA_Short_Name = Utility_to_BA(index).BA_Short_Name;
           Service_Territory(row).BA_Long_Name = Utility_to_BA(index).BA_Long_Name;
           Service_Territory(row).Total_Sales = Utility_to_BA(index).Total_Sales;
           clear index
        else
           Service_Territory(row).BA_Code = [];
           Service_Territory(row).BA_Number = [];
           Service_Territory(row).BA_Short_Name = [];
           Service_Territory(row).BA_Long_Name = [];
           Service_Territory(row).Total_Sales = NaN.*0;
        end
    end
    clear row Utility_to_BA Utility_to_BA_Table
    
    % Loop through the list of all counties in the United States and assign all of the utilities that are operating in that county:
    for row = 1:size(County_Metadata,1)
        if isempty(find(Service_Territory_Table(:,3) == County_Metadata_Table(row,1))) == 0
           % Assign the utilities to that county:
           County_Metadata(row,1).Utilities = Service_Territory(Service_Territory_Table(:,3) == County_Metadata_Table(row,1));
           % Write out the number of utilities in that county to the table for easy searching and indexing:
           County_Metadata_Table(row,7) = size(find(Service_Territory_Table(:,3) == County_Metadata_Table(row,1)),1);
        else
           County_Metadata(row,1).Utilities = [];
           County_Metadata_Table(row,7) = NaN.*0;
        end
    end
    clear row Service_Territory Service_Territory_Table

    % Loop through the list of all counties. If there is more than one unique
    % BA or NERC region operating in that county then assign the BA and NERC
    % region for that county to the utility with the maximum total sales in
    % the year being processed:
    for row = 1:size(County_Metadata,1)
        if isempty(County_Metadata(row,1).Utilities) == 0;
           Subset = County_Metadata(row,1).Utilities;
           for i = 1:size(Subset,1)
               if isempty(Subset(i,1).BA_Number) == 0
                  Stats(i,1) = Subset(i,1).BA_Code;
               else
                  Stats(i,1) = NaN.*0;
               end
               if isempty(Subset(i,1).NERC_Region_Code) == 0
                  Stats(i,2) = Subset(i,1).NERC_Region_Code;
               else
                  Stats(i,2) = NaN.*0;
               end
               if isempty(Subset(i,1).Total_Sales) == 0
                  Stats(i,3) = Subset(i,1).Total_Sales;
               else
                  Stats(i,3) = NaN.*0;
               end
           end
           if isempty(find(isnan(Stats(:,1)) == 0)) == 0
              County_Metadata_Table(row,8) = size(unique(Stats(:,1)),1);
              if isempty(find(isnan(Stats(:,3)) == 0)) == 0
                 County_Metadata_Table(row,9) = unique(Stats(find(Stats(:,3) == max(Stats(:,3))),1));
              else
                 County_Metadata_Table(row,9) = unique(Stats(find(isnan(Stats(:,1)) == 0),1));
              end
           else
              County_Metadata_Table(row,8:9) = NaN.*0;
           end
           if isempty(find(isnan(Stats(:,2)) == 0)) == 0
              County_Metadata_Table(row,10) = size(unique(Stats(:,2)),1);
              if isempty(find(isnan(Stats(:,3)) == 0)) == 0
                 County_Metadata_Table(row,11) = unique(Stats(find(Stats(:,3) == max(Stats(:,3))),2));
              else
                 County_Metadata_Table(row,11) = unique(Stats(find(isnan(Stats(:,2)) == 0),2));
              end
           else
              County_Metadata_Table(row,10:11) = NaN.*0;
           end
           clear i Subset Stats
        else
           County_Metadata_Table(row,8:11) = NaN.*0;
        end
    end
    clear row
    
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
    writetable(Output_Table,[output_summary,'.csv'],'Delimiter',',','WriteVariableNames',1);
    save([output_summary,'.mat'],'County_Metadata','County_Metadata_Table');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end