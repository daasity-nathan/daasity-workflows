-- create the main table with dummy data using ctes
create or replace table urs_staging.urs_mock_data__normalized as
with
    date_range as (
        select dateadd(day, - seq4(), current_date()) as date
        from table(generator(rowcount => 1095))  -- 3 years * 365 days
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
                else 'Private Label'
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
            floor(uniform(0::float, 1::float, random()) * 9 + 1)::number(
                1
            ) as pack_count
        from table(generator(rowcount => 10))
    ),

    location_cte as (
        select
            uuid_string() as location_id,
            case
                seq4()
                when 2
                then 'Umesh''s Uptown Market'
                when 6
                then 'Elizabeth''s Express Mart'
                when 7
                then 'Huiying''''s Healthy Hub'
                when 11
                then 'Nathan''s Nifty Noshery'
                else 'Ben''s Bountiful Bodega'
            end as store_name,
            case
                when uniform(0::float, 1::float, random()) < 0.3
                then 'Midwest Market'
                when uniform(0::float, 1::float, random()) < 0.6
                then 'Southern Market'
                else 'Western Market'
            end as market_name,
            'Warehouse ' || chr(
                65 + floor(uniform(0::float, 1::float, random()) * 26)::int
            ) as warehouse_name,
            'Division ' || lpad(
                floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar,
                3,
                '0'
            ) as retailer_division,
            'KR' || lpad(
                floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar,
                5,
                '0'
            ) as retailer_store_id,
            lpad(
                floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar,
                4,
                '0'
            )
            || ' '
            || case
                when uniform(0::float, 1::float, random()) < 0.2
                then 'Fake St'
                when uniform(0::float, 1::float, random()) < 0.4
                then 'Imaginary Ave'
                when uniform(0::float, 1::float, random()) < 0.6
                then 'Nonexistent Blvd'
                when uniform(0::float, 1::float, random()) < 0.8
                then 'Fictional Ln'
                else 'Made-up Rd'
            end as address1,
            case
                when uniform(0::float, 1::float, random()) < 0.2
                then
                    'Suite ' || lpad(
                        floor(
                            uniform(0::float, 1::float, random()) * 900 + 100
                        )::varchar,
                        3,
                        '0'
                    )
            end as address2,
            case
                when uniform(0::float, 1::float, random()) < 0.2
                then 'Faketown'
                when uniform(0::float, 1::float, random()) < 0.4
                then 'Imaginaria'
                when uniform(0::float, 1::float, random()) < 0.6
                then 'Nonexistent City'
                when uniform(0::float, 1::float, random()) < 0.8
                then 'Fictionopolis'
                else 'Made-upville'
            end as city,
            case
                when uniform(0::float, 1::float, random()) < 0.2
                then 'NY'
                when uniform(0::float, 1::float, random()) < 0.4
                then 'CA'
                when uniform(0::float, 1::float, random()) < 0.6
                then 'IL'
                when uniform(0::float, 1::float, random()) < 0.8
                then 'TX'
                else 'AZ'
            end as state,
            lpad(
                floor(uniform(0::float, 1::float, random()) * 90000 + 10000)::varchar,
                5,
                '0'
            ) as zipcode
        from table(generator(rowcount => 15))
    )

select
    uuid_string() as sales_report_id,
    l.location_id,
    p.product_id,
    'Daasity Internal' as retailer_name,
    l.store_name,
    l.market_name,
    l.warehouse_name,
    l.retailer_division,
    l.retailer_store_id,
    l.address1,
    l.address2,
    l.city,
    l.state,
    'USA' as country,
    l.zipcode,
    true as is_store_level,
    false as is_warehouse_level,
    false as is_market_level,
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
    (uniform(0::float, 1::float, random()) * 900 + 100)::number(10, 2) as gross_sales,
    (uniform(0::float, 1::float, random()) * 100)::number(10, 2) as return_sales,
    floor(uniform(0::float, 1::float, random()) * 900 + 100)::number(
        10, 2
    ) as gross_units,
    floor(uniform(0::float, 1::float, random()) * 100)::number(10, 2) as return_units,
    d.date as sales_date,
    d.date as source_sales_date,
    (uniform(0::float, 1::float, random()) * 900 + 100)::number(10, 2) as dollar_sales,
    floor(uniform(0::float, 1::float, random()) * 900 + 100)::number(
        10, 2
    ) as unit_sales,
    'USD' as original_currency,
    1.0 as currency_conversion_rate,
    'USD' as converted_currency,
    'dummy_file_' || uuid_string() || '.csv' as __file_name,
    'ACC' || lpad(
        floor(
            uniform(0::float, 1::float, uniform(0::float, 1::float, random())) * 900
            + 100
        )::varchar,
        7,
        '0'
    ) as _account_id,
    'daasity_dummy_urs_data' as __source_id,
    'Daasity Dummy URS Data' as __source_display_name,
    current_timestamp() as __synced_at,
    uuid_string() as __sync_key
from table(generator(rowcount => 50000)), product_cte as p, location_cte as l,
    date_range as d
order by random()
limit 50000
;

