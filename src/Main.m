% Main.m
% 20190423
% Casey D. Burleyson and Chris R. Vernon
% Pacific Northwest National Laboratory

% Main script used to execute the `electricity_entity_boundaries` code that builds
% relationships between electircity entities, utilities, customers, and Balancing
% authority areas.

function Main(ini_file)

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

    % input data variables
    county_metadata_xlsx = ini.GetValues(in_data_section, 'county_metadata_xlsx');
    sales_ulil_customer_xlsx = ini.GetValues(in_data_section, 'sales_ulil_customer_xlsx');
    service_territory_xlsx = ini.GetValues(in_data_section, 'service_territory_xlsx');
    utility_data_xlsx = ini.GetValues(in_data_section, 'utility_data_xlsx');
    county_shapefile = ini.GetValues(in_data_section, 'county_shapefile');

    % output data variables
    county_metadata_mat = ini.GetValues(out_data_section, 'county_metadata_mat');
    sales_ulil_customer_mat = ini.GetValues(out_data_section, 'sales_ulil_customer_mat');
    service_territory_mat = ini.GetValues(out_data_section, 'service_territory_mat');
    utility_data_mat = ini.GetValues(out_data_section, 'utility_data_mat');
    output_summary_mat = ini.GetValues(out_data_section, 'output_summary_mat');

    % figure variables
    lat_min = ini.GetValues(figure_section, 'lat_min');
    lat_max = ini.GetValues(figure_section, 'lat_max');
    lon_min = ini.GetValues(figure_section, 'lon_min');
    lon_max = ini.GetValues(figure_section, 'lon_max');
    number_of_utilities_png = ini.GetValues(figure_section, 'number_of_utilities_png');
    number_of_nerc_regions_png = ini.GetValues(figure_section, 'number_of_nerc_regions_png');
    number_of_ba_png = ini.GetValues(figure_section, 'number_of_ba_png');
    primary_ba_png = ini.GetValues(figure_section, 'primary_ba_png');

    % run preprocessing of source data if user selected
    if run_data_prep == 1

        % prepare county metadata mat file
        Process_County_Data(county_metadata_xlsx, county_metadata_mat, county_shapefile);

        % prepare sales by utility and customer mat file
        Preprocess_Sales_Util_Customer_Data(sales_ulil_customer_xlsx, sales_ulil_customer_mat);

        % prepare service by territory mat file
        Preprocess_Service_Territory_Data(service_territory_xlsx, service_territory_mat, county_metadata_mat);

        % prepare utility data mat file
        Preprocess_Utility_Data(utility_data_xlsx, utility_data_mat);

    end

    % run main processing to generate output summary mat file
    Process_Entity_Relationships(county_metadata_mat, sales_ulil_customer_mat, service_territory_mat, utility_data_mat, output_summary_mat);

    % run plotting module
    if run_plots == 1

        Plot_Entity_Maps(output_summary_mat, number_of_utilities_png, number_of_nerc_regions_png, number_of_ba_png, primary_ba_png, lat_min, lat_max, lon_min, lon_max);

    end
end
