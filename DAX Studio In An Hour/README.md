# DAX Studio In An Hour ![DAX Studio](./Images/daxstudio.png)

### About:
DAX Studio is a tool to write, execute, and analyze DAX queries in Power BI Designer, Power Pivot for Excel, and Analysis Services Tabular. It includes an Object Browser, query editing and execution, formula and measure editing, syntax highlighting and formatting, integrated tracing and query execution breakdowns.

Website: https://daxstudio.org/
___

**Follow Along:**
- [Download and install DAX Studio](https://daxstudio.org/)
- [Download and open the Sales Demo PBIX File](https://github.com/microsoft/pbiworkshops/raw/main/Tabular%20Editor%20In%20An%20Hour/Sales%20Demo.pbix)

___

# Table of Contents
- [Setup](#setup)
- [Query Language](#query-language)
- [Formula Language](#formula-language)

___

# Setup

## Instructions
### [Optional: Guided Video](https://www.youtube.com/watch?v=pFX20PPxXjs&list=PLKW7XPyNDgRCOiC69kZWfRQdOxcnQy2yA&index=2)

### Power BI Desktop
1. Ensure the Power BI preview feature [Store datasets using enhanced metadata format](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-enhanced-dataset-metadata) is enabled.

### DAX Studio
1. Navigate to the File menu and select Options
2. Enable the setting: **Set 'Clear Cache and Run' as the default**

![Clear Cache](./Images/ClearCache.png)

**Important Note:** For performance testing utilizing **'Clear Cache and Run'** will ensure that you are executing queries against uncached data.

___

# Data Analysis Expressions (DAX)
**Source:** Microsoft Docs

Data Analysis Expressions (DAX) is the native **formula** and **query** language for Tabular models in Analysis Services (SSAS/AAS), Power BI, and Power Pivot in Excel. DAX includes some of the functions that are used in Excel formulas with additional functions that are designed to work with relational data and perform dynamic aggregation.

[Learn More About DAX](https://docs.microsoft.com/en-us/dax/dax-overview) 

___

# Query Language

With DAX queries, you can query and return data defined by a table expression. Reporting clients construct DAX queries whenever a field is placed on a report surface, or a whenever a filter or calculation is applied. DAX queries can also be created and run in SQL Server Management Studio (SSMS) and open-source tools like DAX Studio. DAX queries run in SSMS and DAX Studio return results as a table.

[Learn More About DAX Queries](https://docs.microsoft.com/en-us/dax/dax-queries)

### Objective: Return tables, columns and scalar values.

## Instructions
### [Optional: Guided Video]()
1. Open the Sales Demo (PBIX) file, navigate to the **External Tools** ribbon in Power BI Desktop and select **DAX Studio**.
2. Witin DAX Studio enter the below query

```
EVALUATE
Customers
```


___

# Formula Language



[Learn More About DAX](https://docs.microsoft.com/en-us/dax/dax-queries)

### Objective: 

## Instructions
### [Optional: Guided Video]()
1. Open the Sales Demo (PBIX) file, navigate to the **External Tools** ribbon in Power BI Desktop and select **DAX Studio**.
2. 

___

# Continue Your Journey

### An indepth walk through of DAX Studio
[PowerBI.Tips - Introduction to DAX Studio Playlist](https://www.youtube.com/watch?v=jpZnCHRauPU&list=PLn1m_aBmgsbGDZb7ydd8_LS1AfosdRndQ)

Includes:
- Introduction to DAX Studio (1:00:44)
- Model Performance Tuning in DAX Studio (1:09:02)
- DAX Studio Full Features Review (1:23:11)
- DAX Studio Query Performance Tuning - Marco Russo; SQLBI (1:00:59)
- DAX Studio Release 2.11.1 (51:32)
