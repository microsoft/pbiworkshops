# Query Folding In An Hour

### About:
Query folding is the ability for a Power Query query to generate a single query statement to retrieve and transform source data. The Power Query mashup engine strives to achieve query folding whenever possible for reasons of efficiency.

Website: https://docs.microsoft.com/en-us/power-query/power-query-folding

__

# Table of Contents
- [Setup](#setup)

___

# Setup

## Instructions

### SQL Server

Download the Lightweight - AvendtureWorksLT2019

Website: https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure

## Query Folding

Query folding may occur for an entire Power Query query, or for a subset of its steps. When query folding cannot be achieved—either partially or fully—the Power Query mashup engine must compensate by processing data transformations itself. This process can involve retrieving source query results, which for large datasets is very resource intensive and slow.

![Query Folding](./Images/QueryFolding.gif)
