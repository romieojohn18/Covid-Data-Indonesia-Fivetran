
create or replace table covid.ilinet_visits (
    -- REGION TYPE
    region_type string,
    -- REGION
    -- Note that "New York City" is a separate region.
    region string,
    -- YEAR
    year int64,
    -- WEEK
    week int64,
    -- % WEIGHTED ILI
    weighted_ili string,
    -- %UNWEIGHTED ILI
    unweighted_ili string,
    -- AGE 0-4
    age_0_4 int64,
    -- AGE 25-49
    age_25_49 int64,
    -- AGE 25-64
    age_25_64 int64,
    -- AGE 5-24
    age_5_24 int64,
    -- AGE 50-64
    age_50_64 int64,
    -- AGE 65
    age_65 int64,
    -- ILITOTAL
    ili_total int64,
    -- NUM. OF PROVIDERS
    num_providers int64,
    -- TOTAL PATIENTS
    total_patients int64
);

-- After 2015, flu testing data is reported separately for clinical labs and public health labs.
-- Clinical lab data is reported by state, while public health lab data is only reported by region.
-- Clinical labs report ~5x more samples than public health labs.
create or replace table covid.clinical_labs (
    -- REGION TYPE
    region_type string,
    -- REGION
    region string,
    -- YEAR
    year int64,
    -- WEEK
    week int64,
    -- TOTAL SPECIMENS
    total_specimens int64,
    -- TOTAL A
    total_a int64,
    -- TOTAL B
    total_b int64,
    -- PERCENT POSITIVE
    percent_positive float64,
    -- PERCENT A
    percent_a float64,
    -- PERCENT B
    percent_b float64
);

create or replace table covid.public_health_labs (
    -- REGION TYPE
    region_type string,
    -- REGION
    region string,
    -- YEAR
    year int64,
    -- WEEK
    week int64,
    -- TOTAL SPECIMENS
    total_specimens int64,
    -- A (2009 H1N1)
    a_h1n1 int64,
    -- A (H3)
    a_h3 int64,
    -- A (Subtyping not Performed)
    a_no_subtype int64,
    -- B
    b int64,
    -- BVic
    b_yam int64,
    -- BYam
    b_vic int64,
    -- H3N2v
    h3n2v int64
);

create or replace table covid.combined_labs (
    -- REGION TYPE
    region_type string,
    -- REGION
    region string,
    -- YEAR
    year int64,
    -- WEEK
    week int64,
    -- TOTAL SPECIMENS
    total_specimens int64,
    -- PERCENT POSITIVE
    percent_positive float64,
    -- A (2009 H1N1)
    a_h1n1 int64,
    -- A (H1)
    a_h1 int64,
    -- A (H3)
    a_h3 int64,
    -- A (Subtyping not Performed)
    a_no_subtype int64,
    -- A (Unable to Subtype)
    a_unable_to_subtype int64,
    -- B
    b int64,
    -- H3N2v
    h3n2v int64
);

create or replace table covid.nyt_cases (
    date date,
    state string,
    fips int64,
    cases int64,
    deaths int64
);

create or replace table covid.census_population (
    state string,
    year int64,
    population int64
);

create or replace table covid.hhs_regions (
    region string,
    state string
);

/*
bq --project_id fivetran-covid load --skip_leading_rows 2 covid.ilinet_visits './data/ILINet.csv'
bq --project_id fivetran-covid load --skip_leading_rows 2 --null_marker 'X' covid.clinical_labs './data/WHO_NREVSS_Clinical_Labs.csv'
bq --project_id fivetran-covid load --skip_leading_rows 2 --null_marker 'X' covid.public_health_labs './data/WHO_NREVSS_Public_Health_Labs.csv'
bq --project_id fivetran-covid load --skip_leading_rows 2 --null_marker 'X' covid.combined_labs './data/WHO_NREVSS_Combined_prior_to_2015_16.csv'
bq --project_id fivetran-covid load --skip_leading_rows 1 covid.nyt_cases './data/NYT_Cases.csv'
bq --project_id fivetran-covid load --skip_leading_rows 1 covid.census_population './data/Census_Population.csv'
bq --project_id fivetran-covid load --skip_leading_rows 1 covid.hhs_regions './data/HHS_Regions.csv'
*/