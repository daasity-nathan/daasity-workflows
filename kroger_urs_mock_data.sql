create or replace view urs_staging.kroger_store_level__normalized as
with final as (select * from urs_staging.urs_mock_data__normalized)
select
    -- ids
    sales_report_id,
    location_id,
    product_id,

    -- locations
    'Kroger' as retailer_name,
    store_name,
    market_name,
    null as warehouse_name,
    retailer_division,
    null as retailer_store_id,
    address1,
    null as address2,
    city,
    state,
    null as country,
    zipcode,
    is_store_level,
    is_warehouse_level,
    is_market_level,
    -- products
    listing_sku,
    listing_sku as master_sku,
    reporting_level,
    product_name,
    upc,
    brand_name,
    department,
    category,
    subcategory,
    product_class,
    null as product_type,
    null as product_size,
    null as unit_of_measure,
    1 as pack_count,
    -- specific to kroger_store_level
    -- scanned_lbs: A weight value
    (uniform(0::float, 1::float, random()) * 100)::number(10, 2) as scanned_lbs,

    -- gross_margin_dollars: A dollar amount
    (uniform(0::float, 1::float, random()) * 500)::number(
        10, 2
    ) as gross_margin_dollars,

    -- sto_phone: A fake phone number
    '('
    || lpad(floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar, 3, '0')
    || ') '
    || lpad(floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar, 3, '0')
    || '-'
    || lpad(
        floor(uniform(0::float, 1::float, random()) * 9000 + 1000)::varchar, 4, '0'
    ) as sto_phone,

    -- sto_county: A fake county name
    case
        when uniform(0::float, 1::float, random()) < 0.2
        then 'Fakeshire'
        when uniform(0::float, 1::float, random()) < 0.4
        then 'Imaginaria County'
        when uniform(0::float, 1::float, random()) < 0.6
        then 'Nonexistent District'
        when uniform(0::float, 1::float, random()) < 0.8
        then 'Fictionopolis County'
        else 'Made-up Region'
    end as sto_county,

    -- sto_type: A store type
    case
        when uniform(0::float, 1::float, random()) < 0.3
        then 'Supermarket'
        when uniform(0::float, 1::float, random()) < 0.5
        then 'Marketplace'
        when uniform(0::float, 1::float, random()) < 0.7
        then 'Multi-Department'
        when uniform(0::float, 1::float, random()) < 0.9
        then 'Price Impact'
        else 'Express'
    end as sto_type,

    -- sto_open_dt: An opening date within the last 30 years
    dateadd(
        day, - floor(uniform(0::float, 1::float, random()) * (30 * 365)), current_date()
    ) as sto_open_dt,

    -- sto_status: Store status
    case
        when uniform(0::float, 1::float, random()) < 0.9 then 'Active' else 'Closed'
    end as sto_status,

    -- sto_close_dt: A closing date, only for closed stores, within the last year
    case
        when uniform(0::float, 1::float, random()) < 0.1
        then
            dateadd(
                day,
                - floor(uniform(0::float, 1::float, random()) * 365),
                current_date()
            )
        else null
    end as sto_close_dt,

    -- re_sto_zone_cd: A zone code
    'Z' || lpad(
        floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar, 3, '0'
    ) as re_sto_zone_cd,

    lpad(
        floor(uniform(0::float, 1::float, random()) * 900 + 100)::varchar, 3, '0'
    ) as sto_fuel,

    -- parent_owner_desc: Parent company description
    case
        when uniform(0::float, 1::float, uniform(0::float, 1::float, random())) < 0.6
        then 'Kroger Co.'
        when uniform(0::float, 1::float, uniform(0::float, 1::float, random())) < 0.8
        then 'Kroger Subsidiaries Inc.'
        else 'Kroger Affiliates LLC'
    end as parent_owner_desc,

    -- sto_banner: Store banner
    case
        when uniform(0::float, 1::float, uniform(0::float, 1::float, random())) < 0.3
        then 'Kroger'
        when uniform(0::float, 1::float, uniform(0::float, 1::float, random())) < 0.5
        then 'Ralph''s'
        when uniform(0::float, 1::float, uniform(0::float, 1::float, random())) < 0.7
        then 'Fred Meyer'
        when uniform(0::float, 1::float, uniform(0::float, 1::float, random())) < 0.9
        then 'King Soopers'
        else 'Harris Teeter'
    end as sto_banner,
    -- sales_report
    sales_date,
    source_sales_date,
    dollar_sales,
    unit_sales,
    original_currency,
    currency_conversion_rate,
    converted_currency,

    -- metadata
    __file_name,
    _account_id,
    'kroger_store_level' as __source_id,
    'Kroger Store Level' as __source_display_name,
    __synced_at,
    __sync_key
from final

