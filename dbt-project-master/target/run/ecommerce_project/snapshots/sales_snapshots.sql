
      update "d9snqvovhsjpqs"."snapshots"."sales_snapshot"
    set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to
    from "sales_snapshot__dbt_tmp115400569448" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_scd_id::text = "d9snqvovhsjpqs"."snapshots"."sales_snapshot".dbt_scd_id::text
      and DBT_INTERNAL_SOURCE.dbt_change_type::text in ('update'::text, 'delete'::text)
      and "d9snqvovhsjpqs"."snapshots"."sales_snapshot".dbt_valid_to is null;

    insert into "d9snqvovhsjpqs"."snapshots"."sales_snapshot" ("order_id", "customer_id", "product_id", "order_date", "quantity", "total_price", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to", "dbt_scd_id")
    select DBT_INTERNAL_SOURCE."order_id",DBT_INTERNAL_SOURCE."customer_id",DBT_INTERNAL_SOURCE."product_id",DBT_INTERNAL_SOURCE."order_date",DBT_INTERNAL_SOURCE."quantity",DBT_INTERNAL_SOURCE."total_price",DBT_INTERNAL_SOURCE."dbt_updated_at",DBT_INTERNAL_SOURCE."dbt_valid_from",DBT_INTERNAL_SOURCE."dbt_valid_to",DBT_INTERNAL_SOURCE."dbt_scd_id"
    from "sales_snapshot__dbt_tmp115400569448" as DBT_INTERNAL_SOURCE
    where DBT_INTERNAL_SOURCE.dbt_change_type::text = 'insert'::text;

  