-- Create the main table with dummy data using CTEs
create or replace table urms_staging.urms_sample_data__normalized as
with
    date_range as (
        select dateadd(day, - seq4(), current_date()) as date
        from table(generator(rowcount => 1095))  -- 3 years * 365 days
    ),

    time_period_cte as (
        select
            uuid_string() as time_period_id,
            'latest' as time_period_type,
            case
                when mod(row_number() over (order by random()), 4) = 0 then dateadd(week, -4, current_date())
                when mod(row_number() over (order by random()), 4) = 1 then dateadd(week, -12, current_date())
                when mod(row_number() over (order by random()), 4) = 2 then dateadd(week, -24, current_date())
                else dateadd(week, -52, current_date())
            end as time_period_start,
            case
                when mod(row_number() over (order by random()), 4) = 0 then '04 Weeks'
                when mod(row_number() over (order by random()), 4) = 1 then '12 Weeks'
                when mod(row_number() over (order by random()), 4) = 2 then '24 Weeks'
                else '52 Weeks'
            end as time_period_name,
            current_date() as time_period_end
        from table(generator(rowcount => 100))
    ),

    product_cte as (
        select
            uuid_string() as product_id,
            case
                seq4()
                when 1
                then '0003428199'
                when 2
                then '0004428203'
                else '0091428188'
            end as listing_sku,
            case
                seq4()
                when 1
                then 'Chris''s Crunchy Cereal'
                when 2
                then 'Patrick''s Perfect Produce'
                else 'Arjun''s Awesome Appetizers'
            end as product_name,
            lpad(
                floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar,
                12,
                '0'
            ) as upc,
            case
                when uniform(0::float, 1::float, random()) < 0.3
                then 'Red Fox Snacks'
                when uniform(0::float, 1::float, random()) < 0.6
                then 'Daasity Delectables'
                else 'Nice Nourishments'
            end as brand_name,
            case
                when uniform(0::float, 1::float, random()) < 0.25
                then 'Grocery'
                when uniform(0::float, 1::float, random()) < 0.5
                then 'Produce'
                else 'Frozen'
            end as department,
            case
                when uniform(0::float, 1::float, random()) < 0.2
                then 'Snacks'
                when uniform(0::float, 1::float, random()) < 0.4
                then 'Beverages'
                when uniform(0::float, 1::float, random()) < 0.6
                then 'Frozen Foods'
                when uniform(0::float, 1::float, random()) < 0.8
                then 'Baked Goods'
                else 'Canned Goods'
            end as category,
            'Subcategory '
            || floor(uniform(0::float, 1::float, random()) * 10)::varchar
            as subcategory,
            'Class ' || lpad(
                floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar,
                3,
                '0'
            ) as product_class,
            case
                when uniform(0::float, 1::float, random()) < 0.5
                then 'Fresh'
                else 'Packaged'
            end as product_type,
            lpad(floor(uniform(0::float, 1::float, random()) * 2 + 32)::varchar, 3, '0')
            || ' oz' as product_size,
            case
                when uniform(0::float, 1::float, random()) < 0.5 then 'OZ' else 'LB'
            end as unit_of_measure,
            floor(uniform(0::float, 1::float, random()) * 9 + 1)::varchar as pack_count,
            case
                when uniform(0::float, 1::float, random()) < 0.25
                then 'Liquid'
                when uniform(0::float, 1::float, random()) < 0.5
                then 'Solid'
                when uniform(0::float, 1::float, random()) < 0.75
                then 'Powder'
                else 'Gel'
            end as form
        from table(generator(rowcount => 10))
    ),

    market_cte as (
        select
            uuid_string() as location_id,
            case
                when uniform(0::float, 1::float, random()) < 0.2
                then 'Northeast'
                when uniform(0::float, 1::float, random()) < 0.4
                then 'Southeast'
                when uniform(0::float, 1::float, random()) < 0.6
                then 'Midwest'
                when uniform(0::float, 1::float, random()) < 0.8
                then 'Southwest'
                else 'West'
            end as market_name,
        from table(generator(rowcount => 15))
    )

select
    uuid_string() as sales_report_id,
    m.location_id,
    uuid_string() as time_id,
    tp.time_period_id,
    p.product_id,
    current_date() as extract_end_date,
    tp.time_period_start as time_start,
    tp.time_period_end as time_end,
    tp.time_period_type as time_type,
    'Period ' || row_number() over (order by tp.time_period_start) as time_period_name,
    tp.time_period_type,
    tp.time_period_start,
    tp.time_period_end,
    tp.time_period_end as viz_date,
    'Daasity Internal Data' as retailer_name,
    null as store_name,
    m.market_name,
    null as warehouse_name,
    null as retailer_division,
    null as retailer_store_id,
    null as address1,
    null as address2,
    null as city,
    null as state,
    'USA' as country,
    null as zipcode,
    false as is_store_level,
    false as is_warehouse_level,
    true as is_market_level,
    p.listing_sku,
    p.listing_sku as master_sku,
    'upc' as reporting_level,
    p.product_name,
    p.upc,
    p.brand_name,
    p.department,
    p.category,
    p.subcategory,
    p.product_class,
    p.product_type,
    p.product_size,
    p.unit_of_measure,
    p.pack_count,
    p.form,
    (uniform(0::float, 1::float, random()) * 100000 + 10000)::number(10, 2) as dollar_sales,
    floor(uniform(0::float, 1::float, random()) * 10000 + 1000) as unit_sales,
    (uniform(0::float, 1::float, random()) * 100)::number(20, 4) as max_acv,
    (uniform(0::float, 1::float, random()) * 1000 + 100)::number(10, 2) as tdp,
    (uniform(0::float, 1::float, random()) * 52)::number(10, 2) as number_of_weeks_selling,
    (uniform(0::float, 1::float, random()) * 20000 + 2000)::number(10, 2) as dollars_promo,
    floor(uniform(0::float, 1::float, random()) * 2000 + 200) as units_promo,
    (uniform(0::float, 1::float, random()) * 80000 + 8000)::number(10, 2) as base_dollars,
    floor(uniform(0::float, 1::float, random()) * 8000 + 800) as base_units,
    floor(uniform(0::float, 1::float, random()) * 1000 + 100) as no_of_stores_selling,
    (uniform(0::float, 1::float, random()) * 5000 + 500)::number(10, 2) as dollars_display_only,
    (uniform(0::float, 1::float, random()) * 5000 + 500)::number(10, 2) as dollars_feature_only,
    (uniform(0::float, 1::float, random()) * 10000 + 1000)::number(10, 2) as dollars_feature_and_display,
    (uniform(0::float, 1::float, random()) * 5000 + 500)::number(10, 2) as dollars_tpr,
    (uniform(0::float, 1::float, random()) * 15000 + 1500)::number(10, 2) as base_dollars_promo,
    floor(uniform(0::float, 1::float, random()) * 1500 + 150) as base_units_promo,
    'daasity_internal_data_' || uuid_string() || '.csv' as __file_name,
    uuid_string() as __sync_key,
    'daasity_sample_urms_data' as __source_id,
    'Daasity Sample URMS Data' as __source_display_name,
    current_timestamp() as __synced_at
from
    table(generator(rowcount => 50000)),
    product_cte as p,
    market_cte as m,
    time_period_cte as tp
order by random()
limit 50000
;


