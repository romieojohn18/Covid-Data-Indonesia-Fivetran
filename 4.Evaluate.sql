
-- Variables to use in extrapolating COVID cases from ILI data.
declare dr_visits_per_week, ili_baseline, h1n1_visits, h1n1_cases, detection_ratio float64;

-- How many times does the average American visit a primary-care provider each week?
-- We use the numbers from the CDC's web site https://www.cdc.gov/nchs/fastats/physician-visits.htm
-- We assume that the number of visits per week is constant over the year.
-- This is a bit surprising, but it appears to be true based on the visits / week of providers in ILINet.
set dr_visits_per_week = 277.9 * .545 / 100 / 52;

-- The baseline % of patients with ILI during the summer when little flu is present.
set ili_baseline = .01;

-- How many Americans with H1N1 visited a primary care provider in the 2009-2010 pandemic?
set h1n1_visits = (
    select sum((ili_per_patient - ili_baseline) * dr_visits_per_week * population) 
    from `fivetran-covid.covid.features` 
    where date between '2009-04-12' and '2010-04-10'
);

-- CDC estimate of how many Americans had H1N1 in the 2009-2010 pandemic.
-- https://www.cdc.gov/flu/pandemic-resources/2009-h1n1-pandemic.html
set h1n1_cases = 60.8 * 1000 * 1000;

-- What % of Americans with H1N1 visited their doctor?
-- We will assume the same % of Americans with COVID visit their doctor.
set detection_ratio = h1n1_visits / h1n1_cases;

-- Estimate the total number of cases.
with extrapolate as (
    select *, (ili_per_patient - predicted_ili_per_patient) * dr_visits_per_week * population / detection_ratio as infected
    from ml.predict(model `fivetran-covid.covid.national_model`, table `fivetran-covid.covid.features`)
    where date >= '2020-03-01'
)
select 
    date,
    region,
    ili_per_patient,
    predicted_ili_per_patient,
    population,
    cases,
    deaths,
    infected,
    sum(infected) over regions as total_infected,
    sum(cases) over regions as total_cases
from extrapolate
window regions as (partition by region order by date rows unbounded preceding)
order by region, date;