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
  - [SELECT Statement](#select-statement)
  - [WHERE Clause](#where-clause)
  - [Aggregate Functions](#aggregate-functions)
  - [GROUP BY Statement](#group-by-statement)
  - [JOIN Clause](#join-clause)
- [Formula Language](#formula-language)
- [Server Timings](#server-timings)
- [VertiPaq Analyzer](#vertipaq-analyzer)


___

# Setup

## Instructions
### [Optional: Guided Video](https://www.youtube.com/watch?v=pFX20PPxXjs&list=PLKW7XPyNDgRCOiC69kZWfRQdOxcnQy2yA&index=2)

### Power BI Desktop
1. Ensure the Power BI preview feature [Store datasets using enhanced metadata format](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-enhanced-dataset-metadata) is enabled.

### DAX Studio
1. Open **DAX Studio**.
2. Navigate to the File menu and select Options
3. Within the **Standard** tab and the **Defaults** group, enable the setting: **Set 'Clear Cache and Run' as the default**
4. Close **DAX Studio**

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

### Objective: Return tables, single column table (list) and scalar values.

## Instructions
### [Optional: Guided Video]()
### Power BI Desktop
1. Open the Sales Demo (PBIX) file, navigate to the **External Tools** ribbon in Power BI Desktop and select **DAX Studio**.

### DAX Studio
In the query Editor section enter the below queries and review their output in the **Results** section (as displayed below), after pressing the **Run (F5)** command.

#### SELECT Statement

1. Select all from the customers table:
```
EVALUATE
Customers
```
**SQL Equivalent:**

```
-- Select all from the customers table
SELECT * 
FROM Customers;
```

![Editor Results](./Images/EditorResults.png)

2. Update the above statement, including an **ORDER BY** clause and sort order modifier:

```
EVALUATE
Customers
ORDER BY [CustomerID] ASC
```
**SQL Equivalent:**
```
-- Select all from the Customers table in ascending order by the CustomerID
SELECT * 
FROM Customers 
ORDER BY CustomerID ASC;
```

**Additional Information:**

| Sort Modifiers | Description |
| :------------- | :---------- |
| ASC | Ascending (Optional Default) |
| DESC   | Descending |


3. Select a single column:
```
EVALUATE
VALUES( Customers[CustomerName] )
```
**SQL Equivalent:**
```
-- Select the CustomerName from the Customers table
SELECT CustomerName 
FROM Customers;
```
🏆 **Challenge:** Attempt the above DAX query to include the **ORDER BY** clause for the CustomerID column. What is the result?

___

#### WHERE Clause

4. Include a filter condition:

```
EVALUATE
FILTER ( Customers, Customers[StateProvinceCode] = "IL" )
```
**SQL Equivalent:**
```
-- Select all from the Customers table where the StateProvinceCode equals IL
SELECT * 
FROM Customers 
WHERE StateProvinceCode = 'IL';
```
___

#### Aggregate Functions

5. Enter the below expression to count all rows in the customer table:

```
EVALUATE
COUNTROWS( Customers )
```
**SQL Equivalent:**
```
-- Count all from the Customers table.
SELECT COUNT(*)
FROM Customers;
```
- Review the following error in the **Output**.
![Table Error](./Images/TableError.png)

- Update the above expression to store the returned results in a list using curly brackets.
```
EVALUATE
{ COUNTROWS( Customers ) }
```
___

#### GROUP BY Statement

6. Enter the below query to count the rows in the customer table based on the StateProvinceCode column:

```
EVALUATE
SUMMARIZECOLUMNS (
	Customers[StateProvinceCode],
	"CustomerCount", COUNTROWS( Customers )
) ORDER BY [Customers] DESC
```
**SQL Equivalent:**
```
-- Count all from the Customers table.
SELECT
StateProvinceCode
, COUNT(*) as CustomerCount
FROM Customers
GROUP BY StateProvinceCode
ORDER BY [Customers] DESC;
```
___

#### JOIN Clause

7. Enter the below query to return all columns from the Customers table where a transaction exists in the Customer Transactions table.

```
EVALUATE
CALCULATETABLE ( Customers, 'Customer Transactions' )
```
**SQL Equivalent:**
```
-- Select all from Customers where a Customer Transcation exists.
SELECT *
FROM Customers
INNER JOIN Customer_Transactions
  ON Customers.CustomerID = Customer_Transcations.CustomerID;
```
___

# Formula Language

DAX formulas are used in measures, calculated columns, calculated tables, and row-level security. Measures are dynamic calculation formulas where the results change depending on context. Measures are used in reporting that support combining and filtering model data by using multiple attributes.

[Learn More About DAX Formulas](https://docs.microsoft.com/en-us/dax/dax-overview)

### Objective: 

## Instructions
### [Optional: Guided Video]()

### DAX Studio
In the query Editor section enter the below queries and review their output in the **Results** section, after pressing the **Run (F5)** command.

1. Enter the below expression to return the average unit price from the Sales Order Lines table:
```
EVALUATE
{ AVERAGE ( 'Sales Order Lines'[Unit Price] ) }
```
- Update the statement to provide a column name for the returned value.
```
EVALUATE
ROW ("Average Unit Price", AVERAGE ( 'Sales Order Lines'[Unit Price] ) )
```

2. Enter the below expression to return the count of orders by CustomerID 841.

```
EVALUATE
{ CALCULATE ( COUNT ( Orders[OrderID] ), Customers[CustomerID] = 841 ) }
```

- The CALCULATE function has both an expression and filter.
CALCULATE(«Expression»,«Filter»)

3. Enter the below query to return the Total Unit Price from the Sales Order Lines table for each row in the Calendar table where the Total Unit Price is greater than zero:

```
EVALUATE
FILTER (
    ADDCOLUMNS (
        'Calendar',
        "Total Unit Price", SUM ( 'Sales Order Lines'[Unit Price] )
    ),
    [Total Unit Price] > 0
)
```
🏆 **Challenge:** Update the above statement to provide the correct results based on the calendar tables row __context__.

4. Enter the below query to return the Total Unit Price from the Sales Order Lines table for each row in the Calendar table where the Total Unit Price is greater than zero:

```
EVALUATE
FILTER (
    SUMMARIZECOLUMNS (
        'Calendar'[Date],
        "Total Unit Price", SUM ( 'Sales Order Lines'[Unit Price] ) ,
        "Total Quantity", SUM ( 'Sales Order Lines'[Quantity] ) 
    ),
    [Total Unit Price] > 0
)
```

[Learn More About Extension Columns](https://www.sqlbi.com/articles/best-practices-using-summarize-and-addcolumns/)

___

# Server Timings


___

# VertiPaq Analyzer



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
