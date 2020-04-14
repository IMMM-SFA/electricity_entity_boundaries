% Preprocess_Sales_Ult_Customer_Data_All_Years.m
% 20200414
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Convert the "Sales_Ult_Cust_YYYY.xlsx" Excel spreadsheet into a Matlab
% structure by extracting relevant metadata.

function Preprocess_Sales_Ult_Customer_Data_All_Years(sales_ult_customer_xlsx,sales_ult_customer_mat,year)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              BEGIN PROCESSING SECTION               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Define how many rows to read in based on the year being processed:
    if year == 2018
       rows = 3277;
    end
    
    % Read the raw data from the spreadsheet into a cell structure:
    [~,~,Raw_Data1] = xlsread(sales_ult_customer_xlsx,'States',['B4:I',num2str(rows)]);
    Raw_Data1(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data1)) = {''};

    [~,~,Raw_Data2] = xlsread(sales_ult_customer_xlsx,'States',['W4:W',num2str(rows)]);
    Raw_Data2(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data2)) = {''};
    Raw_Data = cat(2,Raw_Data1,Raw_Data2);
    clear Raw_Data1 Raw_Data2

    % Loop over all of the utilities to extract relevant metadata:
    for row = 1:size(Raw_Data,1)
        % Look up state information from the state abbreviation:
        [State_FIPS,State_String] = State_FIPS_From_Abbreviations(Raw_Data{row,6});

        % Look up BA information from the BA abbreviation:
        [BA_Code,EIA_BA_Number,BA_Long_Name] = BA_Information_From_BA_Short_Name(Raw_Data{row,8});

        % Extract the metadata into a structure:
        Utility(row,1).Utility_Number = Raw_Data{row,1}; % EIA Utility #
        Utility(row,1).Utility_Long_Name = Raw_Data{row,2}; % Utility Long Name
        Utility(row,1).BA_Number = EIA_BA_Number; % EIA BA #
        Utility(row,1).BA_Code = BA_Code; % In house BA Code
        Utility(row,1).BA_Long_Name = BA_Long_Name; % BA Long Name
        Utility(row,1).BA_Short_Name = Raw_Data{row,8}; % BA Short Name
        Utility(row,1).State_FIPS = State_FIPS; % State FIPS
        Utility(row,1).State_String = State_String; % State String
        Utility(row,1).State_Abbreviation = Raw_Data{row,6}; % State Abbreviation
        Utility(row,1).Total_2017_Sales = Raw_Data{row,9}; % Total sales to all customers in MWh

        % Extract key variables into a table which is easier to search/filter:
        if isempty(Utility(row,1).Utility_Number) == 0;   Utility_Table(row,1) = Utility(row,1).Utility_Number;   else; Utility_Table(row,1) = NaN.*0; end
        if isempty(Utility(row,1).State_FIPS) == 0;       Utility_Table(row,2) = Utility(row,1).State_FIPS;       else; Utility_Table(row,2) = NaN.*0; end
        if isempty(Utility(row,1).BA_Code) == 0;          Utility_Table(row,3) = Utility(row,1).BA_Code;          else; Utility_Table(row,3) = NaN.*0; end
        if isempty(Utility(row,1).BA_Number) == 0;        Utility_Table(row,4) = Utility(row,1).BA_Number;        else; Utility_Table(row,4) = NaN.*0; end
        if isempty(Utility(row,1).Total_2017_Sales) == 0; Utility_Table(row,5) = Utility(row,1).Total_2017_Sales; else; Utility_Table(row,5) = NaN.*0; end

        clear State_FIPS State_String BA_Code BA_Long_Name EIA_BA_Number
    end
    clear row Raw_Data

     % Loop over the rows and order the metadata fields alphebetically:
    for row = 1:size(Utility,1)
        Dummy(row,1) = orderfields(Utility(row,1));
    end
    Utility = Dummy;
    clear row Dummy
    
    % Save the output
    save(sales_ult_customer_mat,'Utility','Utility_Table');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               END PROCESSING SECTION                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end