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

Download and restore of the Lightweight editions of - AdventureWorksLT*

Website: https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure

# Power Query Editor

![Query Folding](./Images/QueryFolding.gif)

### Connectivity Modes

#### Import:
- Data refresh will take place efficiently for Import model tables (Power Pivot or Power BI Desktop), in terms of resource utilization and refresh duration.

#### DirectQuery and Dual storage mode: 
- Each DirectQuery and Dual storage mode table (Power BI only) must be based on a Power Query query that can be folded.
___

### Power BI Desktop
1. Navigate to the Home tab and select **SQL Server**.
2. Enter the local Server name or Azure SQL Database address in the **Server** field.

    a. Optional: You can also include the Database name
  
3. For the Data Connectivity mode leave the default **Import**.
4. Expand the **Advanced options*** to review some of the various settings and press **OK** to proceed:
![SQL Server database](.Images/SQLServerOptions.png)

5. Within the **Navigator** window, if you have multiple databases locate the **AdventureWorksLT** and expand to review the views, tables and stored procedures that you currently maintain access to.
- If you restored from a local .bak file there may be a year suffix attached.
6. Select the check mark next to **SalesLT.Customer** and **SalesLT.Address** and then press **Transform Data** to open the **Power Query Editor**
7. Within the **SalesLT.Address** query, within the **Home** tab, press the **Choose Columns** button.
8. Deselect the following columns and then press **OK**
    - **rowguid**
    - **ModifiedDate**
    - **SalesLT.CustomerAddress**
    - **SalesLT.SalesOrderHeader(AddressID)**
    - **SalesLT.SalesOrderHeader(AddressID) 2**

9. Navigate to the **CountryRegion** field, alternate click any of the rows that contain the value **United States**, hover over **Text Filters** and then select **Equals**.
10. Within the **Query Settings** pane, navigate to the **APPLIED STEPS** section, alternate click the last recorded step **Filtered Rows** and select the option **View Native Query**
- Within Power Query Online's dataflows this is titled **View data source query**
11. Review the generated **Native Query**:
![SubQuery](.Images/SubQuery.png)

[Learn more about Query Optimizer](https://www.red-gate.com/simple-talk/sql/sql-training/the-sql-server-query-optimizer/)

12. 

b.	From SalesLT.Customer select the following columns:
i.	CustomerID, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, EmailAddress
c.	Filter where CompanyName contains “Bike”
d.	Review Native Query and move Filter above the previous step
e.	Delete Column Selection Step
2.	Perform the following transformations against SalesLT Customer query
a.	Add Column – [FullName] combining - [FirstName], [MiddleName], [LastName] merge columns with Space
i.	No Fold
ii.	Custom with if condition – folds
iii.	Delete start over and Merge - folds
b.	 [Title] - Add Conditional Column – Mr. = Male, Ms. = Female
i.	Update to Multi-Condition
1.	List.Contains({“Mr.”,”Sr.”}, [Title]) and List.Contains({“Ms.”, “Sra.”}, [Title])
3.	From the column SalesLT.CustomerAddress Expand SalesLT.Address and select columns AddressLine1 thru PostalCode
i.	Filter for CountryRegion = “United States”
ii.	Select Columns:
1.	CustomerID, Title, FirstName, MiddleName, LastName, CompanyName, EmailAddress, City, StateProvince, PostalCode
iii.	Group By all column headers to find distinct values, = Table.Group( Step, ColumnNames, {} )
b.	Replace Text for [CountryRegion] from “United States” to “USA”
i.	View Native Query now greyed out
c.	Update column names by creating a custom function for Text.Combine(Splitter.SplityByCharacterTextTransition()(_), “ “)



## Incremental Refresh:
- Incremental data refresh (Power BI only) will be efficient, in terms of resource utilization and refresh duration. In fact, the Power BI Incremental Refresh configuration window will notify you of a warning should it determine that query folding for the table cannot be achieved. If it cannot be achieved, the objective of incremental refresh is defeated. The mashup engine would then be required to retrieve all source rows, and then apply filters to determine incremental changes.



## Partial Folding
Query folding may occur for an entire Power Query query, or for a subset of its steps. When query folding cannot be achieved—either partially or fully—the Power Query mashup engine must compensate by processing data transformations itself. This process can involve retrieving source query results, which for large datasets is very resource intensive and slow.

Website: https://docs.microsoft.com/en-us/power-query/power-query-folding
