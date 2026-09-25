# confido-assessment
Repo for take home assessment for Confido

## Installation/Setup

1. Python 3.10–3.13 (3.12 recommended):
   ```bash
   python3.12 -m venv .venv
   source .venv/bin/activate
   pip install -e .
   ```
2. Configure `~/.dbt/profiles.yml` with the Confido Snowflake credentials (profile name: `confido`). Sample profile had `default` as the name, but was changed as my local environment already has a default.
3. Export the password env var referenced in the profile, then verify:
   ```bash
   dbt deps
   dbt debug --profile confido
   dbt run
   dbt test
   ```

## Model Structure

```
models/
  bronze/
    src.yml                 # source definitions + invoice freshness
    staging/                # 1:1 staging views (fields used only)
  silver/
    int_invoice_item.sql    # join path + product dedupe
  gold/
    dim_date.sql
    dim_invoice_item.sql    # line attributes
    fact_invoice_item.sql   # keys, date key, measures
```

## Reasoning
- Bronze staging models: 
  - Used to standardize raw source data. In the case that a source is switched out, only the staging view needs to be changed. Assuming the new source is standardized in the same way as the previous, no downstream models need to be updated. Only fields that are used are included in the staging view.
  - Naming structure is `stg_<schema>__<table>` for staging views.
- Silver intermediate models:
  - For handling complex logic such as combining disparate data sources or complex aggregation. Meant for internal use and troubleshooting.
  - Surrogate key `invoice_item_key` added to easily dedupe, check grain. Populated in dim/fact as well.
- Tests are done in intermediate models instead of dim/fact models where possible to catch issues as early as possible.
- Gold models: 
  - both the star schema and any reporting layer models. Intended to be the cleanest models for use by stakeholders and external services. Should only contain data that is meaningful to users and should only require a join or two to get required data (`dim` -> `fact` <- `dim`).
  - Fact model uses date keys from `dim_date` for better indexing and sorting.
  - Fact model contains ids for other dimensions, but due to time constraints, those dimension models were not built out.
  - Unknown members are added when a value is null in this layer. `-1` for keys/ids and `Unknown` for attributes`. This helps with sorting, indexing, etc as well as counting as NULLS can be counted as 0 in some cases.

## Assumptions
- Invoices Table
  - All invoice numbers are valid despite different formats. I spot checked a few of the invoice number formats and found rows for them in `invoice_items` so I assume they are valid.
  - Decided to call negative `total_amount` rows a refund. Unsure if this is always accurate for this dataset.
- Products
  - Could not find a join on `products.id` column so I had to use `item_remote_id` and dedupe products on `products.item_id` 
- Tests
  - Some tests are made to fail such as the foreign key tests and product related fields. I wrote the tests as I would expect the data to behave, not as it appears in the current demo data. I am unable to determine if data is missing due to this being demo data or if the real dataset may also have missing values in the same way.

## AI Use
- Troubleshooting authentication to Snowflake when setting up project.
- Set up scaffolding for the dbt project (`dbt_project.yml`, `.gitignore`, general directory structure, etc).
- Placeholder model and documentations files without logic.
- Creation of `dim_date` model since this is standard dimension model.
- Creating staging views based on 1 manually created staging view.
- Installation and Model Structure sections of `README.md`
- Final sanity check.

## Potential Expansion
- Reporting layer in `gold` for specific use cases/data marts.
- Source freshness checks in `src.yml`. Its not obvious from the sample data how frequent these tables are updated, so freshness was only added for `invoices` as an example.
- Unit tests to verify the more complex logic such as joins.
- Incremental materialization or batching depending on the size of the entire dataset.
- Orchestration for scheduled or event triggered data refreshes. Potentially Prefect, Airflow, or dbt Cloud.
- SQLFluff and other code quality checks to run in CICD for PRs
- Dimension tables for supporting info such as `items`, `retailers`, `company`, and `confido_distribution_centers`
- Snapshots for facts we want to track over time. Potentially `product`/`product_prices` 
- Currency conversion if not all invoices are in USD.
- Break down into schemas for different layers.
- Re-evaluate tests based on complete dataset.
- More thorough look at the data to find more misshapen or malformed data.