% Process_Entity_Relationships.m
% 20190410
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Using the 1:1 mappings scattered throughout the EIA-861 dataset, jointly
% map utilities to BAs to NERC regions to counties for all utilities.

function Process_Entity_Relationships(county_metadata_mat, sales_ulil_customer_mat, service_territory_mat, utility_data_mat, output_summary_mat)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Load the county metadata dataset:
    load(county_metadata_mat);

    % Load the Sales to Ultimate Customers dataset that contains the
    % utility to balancing authority mapping:
    load(sales_ulil_customer_mat);
    Utility_to_BA = Utility;
    Utility_to_BA_Table = Utility_Table;
    clear Utility Utility_Table

    % Load the Utility Data dataset that contains the utility to NERC region
    % mapping:
    load(utility_data_mat);
    Utility_to_NERC = Utility;
    Utility_to_NERC_Table = Utility_Table;
    clear Utility Utility_Table

    % Load the Service Territory dataset that contains the utility to county
    % mapping:
    load(service_territory_mat);

    % Loop through the Utility to BA dataset and match utility to NERC region:
    for row = 1:size(Utility_to_BA,1)
        % For each utility in the utility to BA mapping dataset, find the same
        % utility in the utility to NERC region mapping dataset:
        if isempty(find(Utility_to_NERC_Table(:,1) == Utility_to_BA_Table(row,1))) == 0
           index = find(Utility_to_NERC_Table(:,1) == Utility_to_BA_Table(row,1));
           Utility_to_BA(row,1).NERC_Region_Code = Utility_to_NERC(index,1).NERC_Region_Code; % Assign the NERC region in house numeric code
           Utility_to_BA(row,1).NERC_Region_Short_Name = Utility_to_NERC(index,1).NERC_Region_Short_Name; % Assign the NERC region short name
           Utility_to_BA(row,1).NERC_Region_Long_Name = Utility_to_NERC(index,1).NERC_Region_Long_Name; % Assign the NERC region long name
           Utility_to_BA_Table(row,6) = Utility_to_NERC_Table(index,3); % Add the NERC region in house numeric code to the table for easier searching and sorting
           clear index
        else
           % If there is no unique match, set the NERC region variables to
           % missing for that utility:
           Utility_to_BA(row,1).NERC_Region_Code = [];
           Utility_to_BA(row,1).NERC_Region_Short_Name = [];
           Utility_to_BA(row,1).NERC_Region_Long_Name = [];
           Utility_to_BA_Table(row,6) = NaN.*0;
        end
    end
    clear row Utility_to_NERC_Table Utility_to_NERC

    % Loop through the Service Territory dataset and match utility/county to NERC region and BA:
    for row = 1:size(Service_Territory,1)
        % For each utility in the utility to county mapping dataset, find the same
        % utility in the utility to BA to NERC region mapping dataset:
        if isempty(find(Utility_to_BA_Table(:,1) == Service_Territory_Table(row,1) & Utility_to_BA_Table(:,2) == Service_Territory_Table(row,2))) == 0
           Utility_to_BA_Subset = Utility_to_BA(find(Utility_to_BA_Table(:,1) == Service_Territory_Table(row,1) & Utility_to_BA_Table(:,2) == Service_Territory_Table(row,2)),1);
           Utility_to_BA_Table_Subset = Utility_to_BA_Table(find(Utility_to_BA_Table(:,1) == Service_Territory_Table(row,1) & Utility_to_BA_Table(:,2) == Service_Territory_Table(row,2)),:);
           % If there is more than one BA operating in that county, note the utility/BA with the highest total sales in 2017:
           if size(Utility_to_BA_Subset,1) > 1
              Subset = Utility_to_BA_Subset(find(Utility_to_BA_Table_Subset(:,5) == max(Utility_to_BA_Table_Subset(:,5))),:);
              Table_Subset = Utility_to_BA_Table_Subset(find(Utility_to_BA_Table_Subset(:,5) == max(Utility_to_BA_Table_Subset(:,5))),:);
           else
              Subset = Utility_to_BA_Subset;
              Table_Subset = Utility_to_BA_Table_Subset;
           end
           clear Utility_to_BA_Subset Utility_to_BA_Table_Subset
           if isempty(Subset(1,1).BA_Number) == 0
              Service_Territory_Table(row,4) = Subset(1,1).BA_Number;
              Service_Territory(row,1).BA_Number = Subset(1,1).BA_Number;
              Service_Territory(row,1).BA_Code = Subset(1,1).BA_Code;
              Service_Territory(row,1).BA_Long_Name = Subset(1,1).BA_Long_Name;
              Service_Territory(row,1).BA_Short_Name = Subset(1,1).BA_Short_Name;
           else
              Service_Territory_Table(row,4) = NaN.*0;
              Service_Territory(row,1).BA_Number = [];
              Service_Territory(row,1).BA_Code = [];
              Service_Territory(row,1).BA_Long_Name = [];
              Service_Territory(row,1).BA_Short_Name = [];
           end
           if isempty(Subset(1,1).NERC_Region_Code) == 0
              Service_Territory_Table(row,5) = Subset(1,1).NERC_Region_Code;
              Service_Territory(row,1).NERC_Region_Code = Subset(1,1).NERC_Region_Code;
              Service_Territory(row,1).NERC_Region_Long_Name = Subset(1,1).NERC_Region_Long_Name;
              Service_Territory(row,1).NERC_Region_Short_Name = Subset(1,1).NERC_Region_Short_Name;
           else
              Service_Territory_Table(row,5) = NaN.*0;
              Service_Territory(row,1).NERC_Region_Code = [];
              Service_Territory(row,1).NERC_Region_Long_Name = [];
              Service_Territory(row,1).NERC_Region_Short_Name = [];
           end
           Service_Territory(row,1).Total_2017_Sales = Subset(1,1).Total_2017_Sales;
           clear Subset Table_Subset
        else
           % If there is no unique match, set the variables to
           % missing for that utility:
           Service_Territory(row,1).BA_Number = [];
           Service_Territory(row,1).BA_Code = [];
           Service_Territory(row,1).BA_Long_Name = [];
           Service_Territory(row,1).BA_Short_Name = [];
           Service_Territory(row,1).NERC_Region_Code = [];
           Service_Territory(row,1).NERC_Region_Long_Name = [];
           Service_Territory(row,1).NERC_Region_Short_Name = [];
           Service_Territory(row,1).Total_2017_Sales = NaN.*0;
           Service_Territory_Table(row,4) = NaN.*0;
           Service_Territory_Table(row,5) = NaN.*0;
        end
    end
    clear row Utility_to_BA_Table Utility_to_BA

    % Loop through the list of all counties in the United States and assign all
    % of the utilities that are operating in that county:
    for row = 1:size(County_Metadata,1)
        if isempty(find(Service_Territory_Table(:,3) == County_Metadata_Table(row,1))) == 0
           % Assign the utilities to that county:
           County_Metadata(row,1).Utilities = Service_Territory(Service_Territory_Table(:,3) == County_Metadata_Table(row,1));
           % Write out the number of utilities in that county to the table for
           % easy searching and indexing:
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
    % 2017:
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
               if isempty(Subset(i,1).Total_2017_Sales) == 0
                  Stats(i,3) = Subset(i,1).Total_2017_Sales;
               else
                  Stats(i,3) = NaN.*0;
               end
           end
           if isempty(find(isnan(Stats(:,3)) == 0)) == 0
              if isempty(find(isnan(Stats(:,1)) == 0)) == 0
                 County_Metadata_Table(row,8) = size(unique(Stats(:,1)),1);
                 County_Metadata_Table(row,9) = unique(Stats(find(Stats(:,3) == max(Stats(:,3))),1));
              else
                 County_Metadata_Table(row,8:9) = NaN.*0;
              end
              if isempty(find(isnan(Stats(:,2)) == 0)) == 0
                 if size(unique(Stats(find(Stats(:,3) == max(Stats(:,3))),2)),1) == 1
                    County_Metadata_Table(row,10) = size(unique(Stats(:,2)),1);
                    County_Metadata_Table(row,11) = unique(Stats(find(Stats(:,3) == max(Stats(:,3))),2));
                 else
                    County_Metadata_Table(row,10:11) = NaN.*0;
                 end
              else
                 County_Metadata_Table(row,8:11) = NaN.*0;
              end
           else
              County_Metadata_Table(row,8:11) = NaN.*0;
           end
           clear i Subset Stats
        else
           County_Metadata_Table(row,8:11) = NaN.*0;
        end
    end
    clear row

    % Manual corrections in areas with missing or incomplete information, but otherwise
    % consistent BA and NERC regions:
    % Lincoln County, Nevada was assigned to Nevada Power Co. and the WECC
    County_Metadata_Table(1755,8) = 0;
    County_Metadata_Table(1755,9) = 31;
    County_Metadata_Table(1755,10) = 0;
    County_Metadata_Table(1755,11) = 8;

    % Save the output:
    save(output_summary_mat,'County_Metadata','County_Metadata_Table');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
