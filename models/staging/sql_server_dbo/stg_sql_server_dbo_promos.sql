with 

source as (

    select * from {{ source('sql_server_dbo', 'promos') }}

),

renamed as (

    select
        promo_id,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source

    union all 

    select 'sin promo', 0, 'active', null, GETDATE()

), final as (
    select 
         as promo_id,
        promo_id as promo_name,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced
    from renamed
    
)

select * from final