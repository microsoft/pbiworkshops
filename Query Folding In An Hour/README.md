# Query Folding In An Hour

### About:

Query folding is the ability for a Power Query query to generate a single query statement to retrieve and transform source data. The Power Query mashup engine strives to achieve query folding whenever possible for reasons of efficiency.

Website: https://docs.microsoft.com/en-us/power-query/power-query-folding
___

# Table of Contents
- [Setup](#setup)
- [Connectivity Modes](#connectivity-modes)
- [Incremental Refresh](#incremental-refresh)

___

# Setup

## Instructions

### SQL Server

Download the Lightweight - AvendtureWorksLT2019

Website: https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure

# Power Query Editor

![Query Folding](./Images/QueryFolding.gif)

### Connectivity Modes

#### Import:
- Data refresh will take place efficiently for Import model tables (Power Pivot or Power BI Desktop), in terms of resource utilization and refresh duration.

#### DirectQuery and Dual storage mode: 
- Each DirectQuery and Dual storage mode table (Power BI only) must be based on a Power Query query that can be folded.



## Incremental Refresh:
- Incremental data refresh (Power BI only) will be efficient, in terms of resource utilization and refresh duration. In fact, the Power BI Incremental Refresh configuration window will notify you of a warning should it determine that query folding for the table cannot be achieved. If it cannot be achieved, the objective of incremental refresh is defeated. The mashup engine would then be required to retrieve all source rows, and then apply filters to determine incremental changes.



## Partial Folding
Query folding may occur for an entire Power Query query, or for a subset of its steps. When query folding cannot be achieved—either partially or fully—the Power Query mashup engine must compensate by processing data transformations itself. This process can involve retrieving source query results, which for large datasets is very resource intensive and slow.

Website: https://docs.microsoft.com/en-us/power-query/power-query-folding
