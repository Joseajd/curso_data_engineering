with 

source as (

    select * from {{ source('sql_server_dbo', 'orders') }}

),

renamed as (

    select
        order_id,
        CASE 
            WHEN shipping_service = '' THEN 'desconocido' 
            ELSE shipping_service 
            END AS shipping_service_actualizada,
        shipping_cost,
        address_id,
        created_at,
        CASE 
            WHEN promo_id = '' THEN 'sin promo' 
            ELSE promo_id 
            END AS promo_id_actualizada,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source
), definitiva as (
    select
        order_id,
        shipping_service_actualizada,
        shipping_cost,
        address_id,
        created_at,
        promo_id_actualizada,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_deleted,
        _fivetran_synced

        from renamed
)

select * from definitiva