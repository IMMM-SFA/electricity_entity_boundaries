# electricity_entity_boundaries
Nested boundaries for electricity entities (e.g., counties, utilities, balancing authority areas, NERC regions and subregions) including workflow processing for automated mapping.

## Contact
Casey Burleyson, PNNL

## Setting-up and Executing the Code
1. Clone this repository using `git clone https://github.com/IMMM-SFA/electricity_entity_boundaries.git`

2. Download and uncompress the EIA-861 file (https://dx.doi.org/10.25584/data.2019-04.720/1508166) from the IM3 data repository. You should also download the County_Metadata.xlsx file (https://dx.doi.org/10.25584/data.2019-04.721/1508393).

3. Set-up the `config.ini` file found in the root of this repository.  Be sure to adjust the paths of each file to represent where the downloaded input data is stored and where you want the output data to be saved to.

4. To run code from terminal or command line:
    - Navigate to the `src` directory in this repository
    - Assuming you have `matlab` in your path, run the following command in the terminal:  `matlab "Main('<path to config file>')"` where `<path to config file>` if the full path with file name and extension of your modified `config.ini` file
    - If running from a `matlab` prompt:  `Main('<path to config file>')`

## Purpose
Historical data from utilities and other entities in the electric sector are a key resource for model formulation and calibration in the multisector dynamics community. For example, observed hourly electricity loads can be used to evaluate models of simulated demand in response to heat waves and other environmental stressors. However, despite its utility (pun intended), there are several key challenges to maximizing the usefulness of these data. The first of which is a spatial mismatch between the data reported by individual utilities and the output produced by models. Utilities serve regions that are heterogenous in both size and shape. Mapping the data that they produce to compare with output from models that are either on regular grids or are nodal in nature is nontrivial. The second challenge is that utilities are constantly being bought and sold or changing names, making it hard to track the evolution of their reported loads across years.

This workflow goes through the steps of mapping utilities, balancing authorities (BAs), and NERC regions to counties in the U.S. Counties serve as a useful base spatial scale because they can be aggregated or disaggregated easily using populations as weights in the scaling and because other datasets that are useful in multisector dynamics (e.g., population) are often available at the county scale. Other teams, including the team responsible for this workflow, have completed this mapping in the past, but their efforts were not documented and their process was not repeatable. Previous versions of this mappings relied on assumptions and other subjective decisions that were not communicated or well understood. The purpose of this workflow is to document step-by-step the process used to create a utility-to-BA-to-NERC region-to-county mapping.

The base resource for this mapping is the EIA-861 annual report on the electric power industry. Within this dataset are a series of files in which all utilities in the U.S. report the BA which they operate under, their NERC region, and counties and states where they operate. The technical challenge is that these mappings are reported in individual data files. The bulk of the workflow involves merging these individual files to create a complete mapping. As the EIA-861 data is reported annually, this workflow should be repeatable on subsequent years of data assuming that the same base information is included in all future versions.

## Input Data
1. Annual Electric Power Industry Report: Form [EIA-861](https://www.eia.gov/electricity/data/eia861/) Detailed Data Files
    * _Raw_Source_: [https://www.eia.gov/electricity/data/eia861/]
    * _DOI_Download_: [https://dx.doi.org/10.25584/data.2019-04.720/1508166]
    * _Purpose_: Contains all of the detailed files described below
    * _Accessed_: 9-April 2019

2. Sales to Ultimate Customers
    * _Source_: `Sales_Ult_Cust_2017.xlsx` from the [EIA-861](https://www.eia.gov/electricity/data/eia861/) zip file
    * _Purpose_: Maps utilities to balancing authorities (BAs) and provides the total sales for each utility that are used as a tie-breaker when more than there is more than one BA or NERC region per county.

3. Utility Data
    * _Source_: `Utility_Data_2017.xlsx` from the [EIA-861](https://www.eia.gov/electricity/data/eia861/) zip file
    * _Purpose_: Maps utilities to NERC regions.

4. County Metadata
    * _Source_: This spreadsheet (`County_Metadata.xlsx`) was made in house and gives the FIPS code, county name, state information, population-weighted latitude, population-weighted longitude, area, and total population estimated by the census bureau in 2017 for all counties in the United States.
    * _DOI_Download_: [https://dx.doi.org/10.25584/data.2019-04.721/1508393]
    * _Purpose_: Gives basic county information needed for mapping and scaling.

5. Service Territory
    * _Source_: `Service_Territory_2017.xlsx` from the [EIA-861](https://www.eia.gov/electricity/data/eia861/) zip file
    * _Purpose_: Maps utilities to the states and counties that they operate in.

## What the Code Does

1.	Convert the Sales to Ultimate Customers spreadsheet into `.mat` file.
    *	Scripts:
        *	`Preprocess_Sales_Util_Customer_Data.m`
    *	Required Functions:
        *	`BA_Information_From_BA_Short_Name.m`
        *	`State_FIPS_From_State_Abbreviations.m`

2.	Convert the Utility Data spreadsheet into a `.mat` file.
    *	Scripts:
        *	`Preprocess_Utility_Data.m`
    *	Required Functions:
        *	`NERC_Region_Information_From_NERC_Region_Short_Name.m`

3.	Convert the County Metadata spreadsheet into a `.mat` file.
    *	Scripts:
        *	`Process_County_Data.m`
    *	Required Functions:
        *	`State_Information_From_State_FIPS.m`

4.	Convert the Service Territory spreadsheet into a `.mat` file and match the listed counties to counties from the County Metadata dataset.
    *	Scripts:
        *	`Preprocess_Service_Territory_Data.m`
    *	Required Functions:
        *	`State_FIPS_From_State_Abbreviations.m`

5.	Merge all of the above datasets by mapping utilities to BAs to NERC regions and eventually to counties in the U.S. The output data file is a structure with each row being a county and then embedded in the structure for that row is all of the utilities operating in that county and their associated BA and NERC region. In counties with more than one BA or NERC region listed, which happens quite often, the county is assigned to the utility with the highest total sales of electricity in 2017. The full output is given in a Matlab file (`Utility_to_BA_to_NERC_Region_to_County_Mapping.mat`).
    *	Scripts:
        *	`Process_Entity_Relationships.m`

6.	Create and save maps of counties in the CONUS with their number of utilities, number of BAs, primary BA, number of NERC regions, and primary NERC region.
    *	Scripts:
        *	`Plot_Entity_Maps.m`
    *	Required Functions:
        *	`BA_Information_From_BA_Code.m`
        *	`NERC_Region_Information_From_NERC_Region_Code.m`
