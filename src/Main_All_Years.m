% Main_All_Years.m
% 20200414
% Casey D. Burleyson and Chris R. Vernon
% Pacific Northwest National Laboratory

% Main script used to execute the `electricity_entity_boundaries` code that builds
% relationships between electircity entities, utilities, customers, and Balancing
% authority areas.

% warning off all; close all; clear all;
% ini_file = '/Users/burl878/OneDrive - PNNL/Documents/Code/IMMM/Mapping/electricity_entity_boundaries/config.ini';
% Main_All_Years(ini_file)

function Main_All_Years(ini_file)

    % initialize configuration file
    ini = IniConfig();
    ini.ReadFile(ini_file)

    % assign configuration section name variables
    project_section = 'ProjectSettings';
    in_data_section = 'InputData';
    out_data_section = 'OutputData';
    figure_section = 'Figures';

    % project level settings
    run_data_prep = ini.GetValues(project_section, 'run_data_prep');
    run_plots = ini.GetValues(project_section, 'run_plots');
    year = ini.GetValues(project_section, 'year');

    % input data variables
    county_populations_csv = ini.GetValues(in_data_section,'county_populations_csv');
    sales_ult_customer_xlsx = [ini.GetValues(in_data_section,'eia_data_path'),num2str(year),'/Sales_Ult_Cust_',num2str(year),'.xlsx'];
    service_territory_xlsx = [ini.GetValues(in_data_section,'eia_data_path'),num2str(year),'/Service_Territory_',num2str(year),'.xlsx'];
    utility_data_xlsx = [ini.GetValues(in_data_section,'eia_data_path'),num2str(year),'/Utility_Data_',num2str(year),'.xlsx'];
    county_shapefile = ini.GetValues(in_data_section, 'county_shapefile');

    % output data variables
    county_metadata_mat = [ini.GetValues(out_data_section, 'output_data_path'),num2str(year),'/county_populations_',num2str(year),'.mat'];
    sales_ult_customer_mat = [ini.GetValues(out_data_section, 'output_data_path'),num2str(year),'/sales_ult_cust_',num2str(year),'.mat'];
    service_territory_mat = [ini.GetValues(out_data_section, 'output_data_path'),num2str(year),'/service_territory_',num2str(year),'.mat'];
    utility_data_mat = [ini.GetValues(out_data_section, 'output_data_path'),num2str(year),'/utility_data_',num2str(year),'.mat'];
    output_summary_mat = [ini.GetValues(out_data_section, 'output_data_path'),num2str(year),'/electricity_entity_boundaries_',num2str(year),'.mat'];

    % figure variables
    lat_min = ini.GetValues(figure_section, 'lat_min');
    lat_max = ini.GetValues(figure_section, 'lat_max');
    lon_min = ini.GetValues(figure_section, 'lon_min');
    lon_max = ini.GetValues(figure_section, 'lon_max');
    number_of_utilities_png = [ini.GetValues(out_data_section, 'output_figure_path'),num2str(year),'/Number_of_Utilities_',num2str(year),'.mat'];
    
    number_of_nerc_regions_png = [ini.GetValues(out_data_section, 'output_figure_path'),num2str(year),'/Number_of_NERC_Regions_',num2str(year),'.mat'];
    number_of_bas_png = [ini.GetValues(out_data_section, 'output_figure_path'),num2str(year),'/Number_of_BAs_',num2str(year),'.mat'];
    primary_ba_png = [ini.GetValues(out_data_section, 'output_figure_path'),num2str(year),'/Primary_BA_',num2str(year),'.mat'];

    % run preprocessing of source data if user selected
    if run_data_prep == 1
        % prepare county metadata mat file
        Preprocess_County_Data_All_Years(county_populations_csv,county_metadata_mat,county_shapefile,year);

        % prepare sales by utility and customer mat file
        Preprocess_Sales_Ult_Customer_Data_All_Years(sales_ult_customer_xlsx,sales_ult_customer_mat,year);

        % prepare service by territory mat file
        Preprocess_Service_Territory_Data_All_Years(service_territory_xlsx,service_territory_mat,county_metadata_mat,year);

        % prepare utility data mat file
        Preprocess_Utility_Data_All_Years(utility_data_xlsx,utility_data_mat,year);
    end

%     % run main processing to generate output summary mat file
%     Process_Entity_Relationships(county_metadata_mat, sales_ult_customer_mat, service_territory_mat, utility_data_mat, output_summary_mat);
% 
%     % run plotting module
%     if run_plots == 1
% 
%         Plot_Entity_Maps(output_summary_mat, number_of_utilities_png, number_of_nerc_regions_png, number_of_bas_png, primary_ba_png, lat_min, lat_max, lon_min, lon_max);
% 
%     end
end