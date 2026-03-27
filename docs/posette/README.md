# README

## Citus

## Sharding types
As of 12.1, we have two types:

- Row-based sharding
- Schema-based sharding

## General Terminology and Concepts
- Coordinator node (the primary node)
- Shard nodes are Postgres instances that we don't want to directly modify

## Workflow
- Reference tables or distributed tables
- For row-based, call `create_distributed_table()` to create a distributed table

## Ruby gems
- [activerecord-multi-tenant](https://github.com/citusdata/activerecord-multi-tenant) adds helpers


## Active Record Horizontal Sharding
- Shard per tenant
- ShardRecord base class

```rb
class ShardRecord < ApplicationRecord
  self.abstract_class = true

  connects_to shards: {
    company_one: { writing: :primary_company_one, reading: :primary_company_one_replica }
  }
end
```

## Citus Schema Sharding

```sql
SELECT * FROM citus_schemas;
```

## citus_stat_tenants

- [citus_stat_tenants](https://www.citusdata.com/blog/2023/05/12/tenant-monitoring-in-citus-and-postgres-with-citus-stat-tenants/)
