# Data Modeling

✏️ Lab scenario
---

In this part of the lab, our goal is to create a dataset that can access our data quickly and efficiently for our report users in **near-real time**. To achieve this, we’ll need to compare Power BI’s storage mode options and measure our performance to find the best solution.

# Storage modes and data modeling

Microsoft Power BI Desktop lets us choose the storage mode for each table in our model, learning the benefits of each storage mode can help us with the following:

- Faster query responses
- Developing bigger datasets
- Quicker dataset refreshes
- Showing near real time data

[Learn more about storage modes](https://docs.microsoft.com/power-bi/transform-model/desktop-storage-mode)

---

## DirectQuery

DirectQuery mode models do not import data. They only contain metadata that defines the model structure. When the model receives a query, it uses native queries to get data from the original data source.

DirectQuery mode models are suitable for two scenarios:

- When data volumes are too big to load into a model or refresh regularly, even after applying data reduction methods
- When reports and dashboards need to show “up-to-date” data, beyond the frequency of scheduled refreshes. (Scheduled refreshes are limited to eight times a day for shared capacity, and 48 times a day for a Premium capacity.)

Learn more about [DirectQuery mode](https://docs.microsoft.com/power-bi/connect-data/service-dataset-modes-understand#directquery-mode) and [DirectQuery model guidance](https://docs.microsoft.com/power-bi/guidance/directquery-model-guidance)

---

1. After connecting to our dataflow, we can see that the **Data** view on the left side-rail is gone and the text **Storage Mode: DirectQuery** appears on the bottom right corner of Power BI Desktop.

    ![Missing data view.](./Media/MissingDataView.png)

1. To check that our connection to our dataflow works, we’ll add the following fields to a **Table** visual on a report page.

    | Table | field |
    |:----- | :------ |
    | DimCustomer_raw | EmailAddress|
    | DimCustomer_raw | Gender |

    ![Table visual.](./Media/TableVisual.png)

1. To verify that the data is coming from our source through a **Direct query**, we’ll go to the View tab and click **Performance analyzer**.

![Performance analyzer.](./Media/PerformanceAnalyzer.png)

1. To use the **Performance analyzer**, we’ll open the pane and click **Start recording**.

    ![Start recording button.](./Media/StartRecording.png)

1. While the **Performance analyzer** is recording, we’ll hover over the **Table** visual and choose the **Analyze this visual** option to refresh only that visual. After that, we’ll click the expand/collapse box next to the **Table** visual in our list to see that a **Direct query** value is there. We can also click the Copy query option and paste our query into any text editor.

    ![Analyze this visual.](./Media/AnalyzeThisVisual.png)

1. The pasted query shows us the **DAX Query** that the analysis services database engine received.

    ```dax
    // DAX Query
    DEFINE
      VAR __DS0Core = 
        SUMMARIZE('DimCustomer_raw', 'DimCustomer_raw'[Gender], 'DimCustomer_raw'[EmailAddress])
    
      VAR __DS0PrimaryWindowed = 
        TOPN(501, __DS0Core, 'DimCustomer_raw'[Gender], 1, 'DimCustomer_raw'[EmailAddress], 1)
    
    EVALUATE
      __DS0PrimaryWindowed
    
    ORDER BY
      'DimCustomer_raw'[Gender], 'DimCustomer_raw'[EmailAddress]
    ```
---

<br>
<font size="6">Optional: Event traces</font>

 <b>Optional - Event traces</b>

One important item that was missing from our above query is the [Transact-SQL](https://docs.microsoft.com/learn/modules/introduction-to-transact-sql/) statement for the **Direct query** value. In order to trace this event we'll leverage [SQL Server Profiler](https://docs.microsoft.com/sql/tools/sql-server-profiler/sql-server-profiler) to view our event traces.

We can also leverage the [external tools in Power BI Desktop](https://docs.microsoft.com/power-bi/transform-model/desktop-external-tools) integration to easily view the event traces against our underlying Analysis Services instance.

<br>
<font size="4">Register SQL Server Profiler external tool</font>


1. Download and install [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms).

1. Download the registered external tool [SQL Server Profiler External Tools](https://raw.githubusercontent.com/microsoft/pbiworkshops/main/Day%20After%20Dashboard%20in%20a%20Day/Source_Files/SQLProfiler.pbitool.json) (json) file. (Courtesy of Microsoft MVP [Steve Campbell](https://mvp.microsoft.com/PublicProfile/5004099))

1. After the above is downloaded add the local file (SQLProfiler.pbitool.json) to the below file path location. Once complete close and restart your Power BI Desktop application.

    ```
    C:\Program Files (x86)\Common Files\Microsoft Shared\Power BI Desktop\External Tools
    ```
[Learn more about external tools](https://docs.microsoft.com/power-bi/transform-model/desktop-external-tools)

<br>
<font size="4">DirectQuery events</font>

1. From the **Trace Properties** window select the **Events Selection** tab. Within the **Events** section, expand the **Query Processing** group and then select the **DirectQuery End** event. Once complete select the **Run** option in the bottom right to start tracing events.

    ![Trace properties.](./Media/TraceProperties.png)

1. We'll now return to the Power BI Desktop application and select the **Analyze this visual** option again to send a query to our source.

    ![Analyze this visual refresh.](./Media/AnalyzeThisVisualRefresh.png)

1. Returning to the **SQL Server Profiler** application, a **DirectQuery end** event is now displayed including the **Text data** of the SQL query generated by Power BI, the total time it took to return a result with the **Duration** and more.

    ![DirectQuery end.](./Media/DirectQueryEnd.png)

    ```sql
    SELECT
        TOP (501) [t1].[EmailAddress],
        [t1].[Gender]
    FROM
        [DimCustomer_raw] AS [t1]
    GROUP BY
        [t1].[EmailAddress],
        [t1].[Gender]
    ORDER BY
        [t1].[Gender] ASC,
        [t1].[EmailAddress] ASC
    ```

<font size="6">✅ Lab check</font>

We've been able to confirm that as our Power BI visuals are being rendered our query will be instantly sent to our data source to retrieve new insights. With this initial requirement met, let's continue and start connecting our tables to create a dimensional model.

---

## Relationships

If you use more than one table, you’ll probably need data from all of them for your analysis. You need to create relationships between the tables to get the right results and show the right information in your reports.

Learn more about [creating and managing relationships](https://docs.microsoft.com/power-bi/transform-model/desktop-create-and-manage-relationships)

---

1. Go to the model view on the side-rail

    ![Model view.](./Media/ModelView.png)

1. To link two of our tables, we’ll drag-and-drop the fields below from the table they belong to.
    1. If we hover over our table’s headers, we’ll see more details about the **Storage mode**, **Data source type**, **Server name** and a symbol in the top left that shows the **Storage mode**, which is DirectQuery in this example.
  
    | Table | field |
    |:----- | :------ |
    | DimCustomer_raw | CustomerKey|
    | FactOnlineSales | CustomerKey |

    ![Create relationship.](./Media/CreateRelationship.png)

1. In the **Create relationship** window, we can check that the **CustomerKey** field is selected within each table (as noted by the darker shade). Then, we can click **OK** to continue.

    ![Create relationship window.](./Media/CreateRelationshipOK.png)

1. Back to the report page view, we'll do the following steps.
    1. From the **FactOnlineSales** table, add the **SalesAmount** field.
    1. Click **Clear** in the **Performance analyzer** pane to remove previous events.
    1. Click **Analyze this visual** to test the performance of the added field.
    
    ![Add sales amount.](./Media/AddSalesAmount.png)

1. **Optional:** Back to the **SQL Server Profiler** application, we can find the **DirectQuery end** event with the **Text data** that shows the SQL query generated when we needed data from more than one table. In this example a [**LEFT OUTER JOIN**](https://docs.microsoft.com/sql/relational-databases/performance/joins?view=sql-server-ver15#fundamentals) is used.

    ![DirectQuery left outer join.](./Media/DirectQueryLeftOuterJoin.png)

    ```sql
    SELECT
        TOP (1000001) *
    FROM (
        SELECT
            [t1].[EmailAddress],
            [t1].[Gender],
            SUM([t0].[SalesAmount]) AS [a0]
        FROM (
            [FactOnlineSales] AS [t0]
            LEFT OUTER JOIN [DimCustomer_raw] AS [t1]
            ON ([t0].[CustomerKey] = [t1].[CustomerKey])
        )
        GROUP BY
            [t1].[EmailAddress],
            [t1].[Gender]
    ) [MainTable]
    WHERE (NOT( ([a0] IS NULL)))
    ```

1. To improve our performance, we can change the default join because all of our sales have a customer key. We’ll go to the **Modeling** tab and click **Manage relationships**.

    ![Manage relationships.](./Media/ManageRelationships.png)

1. In the **Manage relationships** dialog window, click **Edit...**
    1. You can also double click to go to the relationship view.

    ![Edit relationships.](./Media/EditRelationships.png)

1. In the **Edit relationship** dialog window, check the box next to the [**Assume referential integrity**](https://docs.microsoft.com/power-bi/connect-data/desktop-assume-referential-integrity) property. Then click **OK** and close the **Manage relationships** window to go back to the report page.

    ![Assume referential integrity.](./Media/AssumeReferentialIntegrity.png)

1. Back to the report page view, we'll do the following steps.
    1. Click **Clear** in the **Performance analyzer** pane to remove previous events.
    1. Click **Analyze this visual** to test the performance of the added field.

    ![Analyze this visual for inner join.](./Media/AnalyzeInnerJoin.png)

1. **Optional:** Back to the **SQL Server Profiler** application, we can find the **DirectQuery end** event with the **Text data** that shows the SQL query generated when we needed data from more than one table. In this example a [**INNER JOIN**](https://docs.microsoft.com/sql/relational-databases/performance/joins?view=sql-server-ver15#fundamentals) is used.

    ![DirectQuery inner join.](./Media/DirectQueryInnerJoin.png)

    ```sql
    SELECT
        TOP (1000001) *
    FROM (
        SELECT
            [t1].[EmailAddress],
            [t1].[Gender],
            SUM([t0].[SalesAmount]) AS [a0]
        FROM (
            [FactOnlineSales] AS [t0]
            INNER JOIN [DimCustomer_raw] AS [t1]
            ON ([t0].[CustomerKey] = [t1].[CustomerKey])
        )
        GROUP BY
            [t1].[EmailAddress],
            [t1].[Gender]
    ) [MainTable]
    WHERE (NOT( ([a0] IS NULL)))
    ```

1. Back to the **Model** view, we'll link the tables below by dragging and dropping our fields and choosing the right settings in the **Edit relationship** window.
    1. We can also make relationships between tables by clicking the **Manage relationships** button on the **Home** tab and then **New...** option in the bottom left.

    | Active | From: Table (field) | field | Cardinality | Assume referential integrity | Cross filter direction | 
    | :----- |:----- | :------ | :----- | :----- | :----- |
    | ☑ | DimCustomer_raw (GeographyKey) | DimGeography_raw (GeographyKey) | Many to one (*:1) | ☑ | Single |
    | ☑ | DimEmployee (StoreKey) | DimStore (StoreKey) | Many to one (*:1) | ☑ | Both |
    | ☑ | DimProduct_raw (ProductSubcategoryKey) | DimProductSubcategory_raw (ProductSubcategoryKey) | Many to one (*:1) |  | Single |
    | ☑ | DimProductSubcategory_raw (ProductCategoryKey) | DimProductCategory_raw (ProductCategoryKey) | Many to one (*:1) | ☑ | Single |
    | ☑ | FactOnlineSales (CustomerKey) | DimCustomer_raw (CustomerKey) | Many to one (*:1) | ☑ | Single |
    | ☑ | FactOnlineSales (ProductKey) | DimProduct_raw (ProductKey) | Many to one (*:1) | ☑ | Single |
    | ☑ | FactOnlineSales (StoreKey) | DimStore (StoreKey) | Many to one (*:1) | ☑ | Single |
    | ☑ | FactOnlineSales (DateKey) | DimDate (DateKey) | Many to one (*:1) | ☑ | Single |
    |  | FactOnlineSales (DeliveryDate) | DimDate (DateKey) | Many to one (*:1) | ☑ | Single |


1. In the **Properties** pane of the Modeling view, change both the **Show the database in the header when applicable** and **Pin related fields to top of card** options to **Yes**.

    ![Full view of all connected tables.](./Media/FullModelView.png)

<font size="6">✅ Lab check</font>

We have linked all of our data source’s tables, but now we need our data model to be **near-real time** and **very fast**.

To do this, we’ll need to change the design of our model.

---

## Dimensional modeling

A good model design should have tables that are either dimension-type or fact-type, and not mix both types in one table.

**Dimension tables** describe the things you model, such as products, people, places, and concepts like time.

- The most common table in a star schema is a date dimension table.
- A dimension table has a key column (or columns) that is a unique identifier, and descriptive columns.

**Fact tables** store data about events or observations, such as sales orders, stock balances, exchange rates, temperatures, etc.

- A fact table has dimension key columns that link to dimension tables, and numeric measure columns.
- The dimension key columns show the dimensions of a fact table, while the dimension key values show the level of detail of a fact table. For example, think of a fact table that stores sales targets with two dimension key columns Date and ProductKey.
- You can see that the table has two dimensions. But to know the level of detail, you need to look at the dimension key values. In this example, the Date column has the first day of each month. So, the level of detail is at month-product level.

You should also try to have the right number of tables with the right relationships between them.

Learn more about the [importance of the star schema for Power BI](https://docs.microsoft.com/power-bi/guidance/star-schema)

---

1. Navigate to the model view on the side-rail.

    ![Full side rail.](./Media/ModelViewSelection.png)

1. In our modeling view, we notice some [snowflaked dimensions](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/snowflake-dimension/) between the following tables:
    1. **DimCustomer_raw** to **DimGeography_raw**
    1. **DimProductCategory_raw** to **DimProductSubcategory_raw** and **DimProductCategory_raw** tables

    ![Snowflake dimensions](./Media/SnowflakeDimensions.png)

    This type of modeling approaching may affect the duration of our datasets queries and could ultimately lead to reduced performance. To better optimize our model let's update our model to leverage the tables within our dataflow where we've already merged our tables into a correct view of our data.

1. Within them model view we'll select the vertical ellipses ( ⋮ ) at the top right of the **DimProduct_raw** table and then the **Edit query** option to return to the Power Query Editor.
    1. Important you can also right click the table header as opposed to selecting the ellipses.

    ![Edit query.](./Media/EditQueryFromTable.png)

1. In the Power Query Editor - **Queries** pane we'll update the following queries to our merged table from the previous [**Data Preparation**](https://github.com/microsoft/pbiworkshops/blob/main/Day%20After%20Dashboard%20in%20a%20Day/DataPreparation.md#joining-tables-using-the-diagram-view) lab instructions.
    
    1. We'll start by selecting the **DimProduct_raw** query and then complete the following.
        1. In the **APPLIED STEPS** next to the **Navigation** step select the settings icon.
        1. Within the **Navigation** window, we'll now select **Workspaces** to view our dataflows stored within the Power BI service.
            1. The Environments option, shows dataflows created with Power Apps.
        1. We can now navigate to the workspace location where we created and saved our dataflows from the data preparation lab instructions. Once found we'll then expand our dataflow to view all the available tables and update our selection to the **DimProduct** table.
        1. Within the **Query Settings** pane, update the **Name** value to now simply be titled **DimProduct**.

        ![DimProduct update](./Media/DimProductNavigation.png)

    1. Now select the **DimCustomer_raw** table where we'll try a different approach by leveraging our formula bar. Within the **Query Settings** pane's **APPLIED STEPS** section, select the **Navigation** step and complete the following before and after below to remove the **"_raw"** suffix.

    | Before | After |
    | :-- | :-- |
    |= #"Dataflow Id"{[entity="**DimCustomer_raw**",version=""]}[Data] | = #"Dataflow Id"{[entity="**DimCustomer**",version=""]}[Data] |

    ![DimProduct update](./Media/DimCustomer.png)

1. Within the **Queries** pane right click the **DimCustomer_raw** table and select the **Rename** option to update the table names to now simply be titled **DimCustomer**:

    ![Rename product](./Media/DimCustomerRename.png)

1. Within the **Queries** pane while holding ctrl on your keyboard (or shift if they are adjacent), click the following tables listed below and then right click to select the **Delete** option to bulk remove the tables from our dataset.
    1. DimGeography_raw
    1. DimProductCategory_raw
    1. DimProductSubcategory_raw

    ![Delete product](./Media/BulkDeleteQueries.png)

1. Now that we're ready to return to our modeling view navigate to the **Home** tab and select the **Close & Apply** option.

    ![Close apply.](./Media/CloseApply.png)

1. Returning to the **Model** view, our tables now resemble a star with our fact table, maintaining all of our sales records and our dimension tables which are then used to filter our results.

    ![Star Schema view.](./Media/StarSchemaView.png)

<font size="6">✅ Lab check</font>

We've been able to properly model our dataset into a proper star schema but a new requirement has come in that our data model has to be both - **near-real time** and **blazing fast**. For this we'll want to revisit our storage mode options and determine if each of our tables are configured properly.

---
## Mixed (Composite) mode

With mixed (composite) mode we can mix both Import and DirectQuery modes into a single model. Models developed in composite mode support configuring the storage mode as Import, DirectQuery, or Dual for each table.

A table configured as dual storage mode is both Import and DirectQuery, depending upon the query. This allows Power BI to determine the most efficient mode to use on a query-by-query basis.

[Learn more about composite mode](https://docs.microsoft.com/power-bi/connect-data/service-dataset-modes-understand#composite-mode)

---

1. Within the **Model** view, we'll select the following tables listed below by holding ctrl on our keyboard, navigating to the **Properties** pane and expanding the **Advanced** options. For the **Storage mode** option select the drop down and update the selection to **Import**.
    1. DimDate
    1. DimProduct
    1. DimStore
    1. DimEmployee

    ![Update Storage Mode.](./Media/UpdateStorageMode.png)

1. Within the **Storage mode** window is some very important text that changing our tables from DirectQuery is an irreversible operation and the recommendation that instead of setting the tables to **Import** that we should leverage the **Dual** storage mode so that our returned values can either be **Import** or **DirectQuery** mode depending upon the queries being submitted.

    ![Storage Mode window.](./Media/StorageModeMenu.png)

1. Returning to the **Model** view, there are new icons available within our tables representing **Dual** storage mode for our **DimProduct**, **DimDate** and **DimStore** tables. Our **DimEmployee** table also has an icon indicating that it is an **Import** only storage mode.

    ![Mixed Storage Modes.](./Media/MixedStorageModes.png)

1. On the side-rail we now see three options - **Report**, **Data** and **Model** view. With the data view we can now view imported and cached data within our Power BI file. For now, let's select the **Report** view to continue.

    ![Report view.](./Media/ReportView.png)

1. On the report canvas we'll create a new table and add the following columns from the tables below to test the performance of our **Dual** and **Import** tables.

    | Table | Column | Storage Mode |
    | :---- | :----- | :----- |
    | DimStore | StoreName| Dual | 
    | DimEmployee | EmailAddress | Import | 
    
    ![Store employees.](./Media/StoreEmployees.png)

1. With results returned almost instantly, we want to understand if our query is being sent to our source via **Direct query** or if it's able to be successfully completed all thru an imported cache. To confirm we'll navigate to the **View** tab and then select **Performance analyzer**.

    ![Performance analyzer.](./Media/PerformanceAnalyzer.png)

1. Once the **Performance analyzer** pane is visible, we'll now select **Start recording**.

    ![Start recording button.](./Media/StartRecording.png)

1. Select the **Analyze this visual** button above the table visual and once complete, expand the **Table** object in the **Performance analyzer** pane. We can now review our results, and determine that there is no longer a **Direct query** entry.

    This means that Power BI was able to determine that we had the available data stored in-memory to satisfy our query and that we did not need return to our data source to directly obtain our results.

    ![Dax Query mixed storage.](./Media/DaxQueryMixed.png)

1. On the report canvas we'll create another new table and add the following columns from the tables below to test the performance between **Dual** and **DirectQuery** tables.

    | Table | Column | Storage Mode |
    | :---- | :----- | :----- |
    | DimStore | StoreName| Dual | 
    | FactOnlineSales | SalesAmount | DirectQuery |

    ![Store sales.](./Media/StoreSales.png)

1. Select the **Analyze this visual** button above the table visual and once complete, expand the new **Table** object in the **Performance analyzer** pane. We can now review our results, and determine that a **Direct query** entry is once again present.

    This means that Power BI was able to determine that we only a partial amount of data stored in-memory from our DimStore table and that it would need to transition our query to a DirectQuery method to satisfy our results.

    ![Store sales Direct query.](./Media/StoreSalesDQ.png)

1. **Optional:** Returning to the **SQL Server Profiler** application, we can locate the **DirectQuery end** event and review the SQL query that will be sent to our data source.

    ![DirectQuery end.](./Media/DQEndEventStoreSales.png)

    ```sql
    SELECT 
      TOP (1000001) * 
    FROM 
      (
        SELECT 
          [t4].[StoreName], 
          SUM([t0].[SalesAmount]) AS [a0] 
        FROM 
          (
            [FactOnlineSales] AS [t0] 
            INNER JOIN [DimStore] AS [t4] on (
              [t0].[StoreKey] = [t4].[StoreKey]
            )
          ) 
        GROUP BY 
          [t4].[StoreName]
      ) AS [MainTable] 
    WHERE 
      (
        NOT(
          ([a0] IS NULL)
        )
      )
    ```

<font size="6">✅ Lab check</font>

We've been able to create a proper data model and tested different storage modes. After speaking directly with our end users we learned they would rather have **blazing fast** performance as the reports prepare them for their business day so they need to be able to quickly slice-and-dice their insights.

We've also learned that new information only comes in overnight and as long as this information can be made fully available before they start their morning. The request for **near real-time** meant as soon as its available, as opposed to the previous wait period in the prior reporting solution.

---

## Import mode

Import mode is the most common mode used to develop datasets. This mode delivers extremely fast performance thanks to in-memory querying. It also offers design flexibility to modelers, and support for specific Power BI service features (Q&A, Quick Insights, etc.). Because of these strengths, it's the default mode when creating a new Power BI Desktop solution.

It's important to understand that imported data is always stored to disk. When queried or refreshed, the data must be fully loaded into memory of the Power BI capacity. Once in memory, Import models can then achieve very fast query results. It's also important to understand that there's no concept of an Import model being partially loaded into memory.

When refreshed, data is compressed and optimized and then stored to disk by the VertiPaq storage engine. When loaded from disk into memory, it's possible to see 10x compression. So, it's reasonable to expect that 10 GB of source data can compress to about 1 GB in size. Storage size on disk can achieve a 20% reduction from the compressed size. (The difference in size can be determined by comparing the Power BI Desktop file size with the Task Manager memory usage of the file.)

Design flexibility can be achieved in three ways. Data modelers can:

Integrate data by caching data from dataflows, and external data sources, whatever the data source type or format
Leverage the entire set of Power Query Formula Language (informally referred to as M) functions when creating data preparation queries
Leverage the entire set of Data Analysis Expressions (DAX) functions when enhancing the model with business logic. There's support for calculated columns, calculated tables, and measures.

[Learn more about import mode](https://docs.microsoft.com/power-bi/connect-data/service-dataset-modes-understand#import-mode)

---

1. Navigate to the model view on the side-rail.

    ![Full side rail.](./Media/ModelViewSideRail.png)

1. Within the model diagram view on the keyboard press **Ctrl+A** to select all tables (you can also hold ctrl and click to select them individually). Within the **Properties** pane expand the **Advanced** options and within the **Storage mode** option select **Import** to update all of our tables.

     ![Import storage mode.](./Media/ImportStorageMode.png)

1. Within the **Storage mode** window is a warning letting us know that **Setting our storage mode to Import is an irreversible operation. You will not be able to switch it back to DirectQuery.** - select **OK** to procee.

    Understanding our business requirements fully now, we recognize that **Import** will give us the blazing-fast performance to create an enjoyable experience for our end users as they slice-and-dice information and we can meet the overall data freshness requirements through a scheduled refresh of our results each day.

    ![Storage mode window](./Media/IrreversibleImport.png)

1. Select the **Report** view to return to the report canvas.

    ![Report view.](./Media/ReportView.png)

1. From our previous sales by store table visual select the **Analyze this visual** button above the table visual once again and once complete, expand the new **Table** object in the **Performance analyzer** pane. We can now review our results, and determine that only a **DAX query** entry is present.

    This means that Power BI was able to determine that we have all of the available data stored in-memory to satisfy our queries requirements now.

    ![Store sales Direct query.](./Media/ImportDAXQuery.png)

<font size="6">✅ Lab check</font>

At this stage in our projects development we've explored several potential benefits of each storage mode, ultimately though the most important thing we learned was that had we gone to our business users and understood their requirements directly we could choose the right solution to meet their needs.

Important questions we should ask next time:
- How often is the data updated?

---

## Incremental Refresh


1. From the **Home** tab of the **Power Query Editor** select the **Manage Parameters** and then the **New Parameter** option.

    ![New parameter.](./Media/NewParameter.png)

1. From the **Manage Parameters** window, select the **New** button and create the below two values.
    1. **Important Note**: these are case sensitive, reserved keywords and must match exactly for incremenetal refresh to properly work.

    | Name | Type | Current Value |
    |:----- | :------ | :------ |
    | RangeStart | Date/Time | 1/1/2020 |
    | RangeEnd | Date/Time | 12/31/2022 |

    ![RangeStart and RangeEnd.](./Media/RangeStartEnd.png)

1. From the **FactOnlineSales** table, select the **DateKey** field's drop down in the top right corner, the **Number Filters** option and then the **Between** value.

    ![Between.](./Media/Between.png)

1. Within the **Filter Rows** menu, set the following values below.

    Keep rows where 'DateKey'
    | Keep Rows | |
    |:- | :- |
    | is greater than or equal to | 1/1/2020 |
    | is less than | 12/31/2022 |

    ![Filter rows.](./Media/FilterRows.png)

    ⚠️ **Important** ⚠️

    Because our column type is **Date** and the parameters are required to be **DateTime** we were unable to select them within the dialog window and must populate them manually. In the following step will we will edit the formula bar to utilize our parameters and transform our values to extract only the date part.

1. In the **Power Query Editor** formula bar update the current date values to utilize the **RangeStart** and **RangeEnd** parameters by updating the formula to the below.

    ```powerquery-m
    = Table.SelectRows(#"Entity Name", each [DateKey] >= Date.From(RangeStart) and [DateKey] < Date.From(RangeEnd))
    ```

    ![fxCreateKey function](./Media/FxCreateKey.png)

1. Now that we're ready to return to our modeling view navigate to the **Home** tab and select the **Close & Apply** option.

    ![Close apply.](./Media/CloseApply.png)

1. Navigate to the **Model** view on the side-rail of Power BI Desktop, where we'll now setup our incremental refresh policy on the **FactOnlineSales** table.

    ![Model view.](./Media/ModelView.png)

1. Either select the vertical ellipses ( ⋮ ) in the top right corner of the **FactOnlineSales** and or right click the table title and then select **Incremental refresh** option.

    ![Agg relationships.](./Media/IncrementalRefreshSelection.png)

1. From the **Incremental refresh and real-time data** menu, set the following configurations below and select **Apply** once complete.
    1. ☑️Incrementally refresh this table
    1. Archive data starting **2 Years** before refresh date
    1. Incrementally refresh data starting **1 year** before refresh date

    ![Incremental refresh menu.](./Media/IncrementalRefreshMenu.png)

    ⚠️ **Important** ⚠️

    At the top of the Incremental refresh and real-time data window is the information section that states, **you won't be able to download it back to Power BI Desktop** once an incremental refresh policy has been applied. For this reason, we should ensure that our dataset is in a completed state prior to publishing, otherwise a full dataset refresh will be required for any subsequent re-publishing.

---

# Model properties

An important aspect of data modeling is usability.

---

## Descriptions

1. Select the **Model** view and update the following table properties with the instructions below for each:
    1. From the **Fields** pane select the Previous Table Name from the list.
    1. In the **Properties** pane update the **Name**, **Description** and **Key column** fields.

    | Previous Table Name | Name | Description | Key column |
    | :---- | :---- | :---- | :---- |
    | DimCustomer | Customers | Contains customer information including address and contact details.  | CustomerKey |
    | DimDate | Calendar | Contains the organizational calendar including any custom days, weeks, months and years. | DateKey |
    | DimEmployee | Employees | Contains all employee information including address and contact details. | EmployeeKey |
    | DimStore | Stores | Contains all store information including address and contact details. | StoreKey |
    | DimProduct | Products | Contains all product information including descriptions and categorization. | ProductKey | 
    | FactOnlineSales | Online Sales | Contains all online sales transactions including quantities and amounts.  | OnlineSalesKey |
    
    ![Table properties](./Media/TableProperties.png)

1. If we hover above the **Table** properties in any of the **Report**, **Data** or **Model** views we will now see the description field available in a tooltip. 
    1. The **Description** value can also be populated for columns/fields and measures upon active selection.
    1. For end users the **Description** fields will be available in various client applications and experiences ensuring they have a proper understanding of the property.

    ![Table description](./Media/TableDescription.png)

---

## Row label

1. Let's select the **Report** view to return to our report canvas.

    ![Report view](./Media/ReportView.png)

1. On the report canvas we'll create a new **Table** visual and add the **Full Name** column from the **Customers** table and the **Total Sales Amount** measure from the **Online Sales** table.

    Upon first inspection, everything is working as intended with returning our table but we learn that we actually have two customers that share the same name "**Abigail Barnes**" as displayed from our filters list, which is now problematic when we begin to aggregate our results as they are rolled up into this single user.

    ![Duplicate names](./Media/DuplicateNames.png)

1. Navigate again to the **Model** view on the side-rail.

    ![Full side rail](./Media/ModelViewSideRail.png)

1. From the **Fields** pane first we'll select the **Customers** table and within the **Properties** pane set the **Row label** to the **Full Name** field.

    ![Row label](./Media/RowLabel.png)


1. Return to the **Report** view once again.

    ![Report view](./Media/ReportView.png)

1. We'll return to our **Table** visual and remove the **Full Name** field from the **Columns** values and add the **Full Name** column back again from our **Customers** table to re-render the report.

    This time both **Abigail Barnes** names are rendered from our data.

    ![TwoAbigail.png](./Media/TwoAbigail.png)

---

## Sort by

1. On the report canvas we'll create a new **Table** visual and add the following column from the table below to visualize our data. One of the first things we may notice is that the **MonthName** field is being sorted in ascending (A to Z) order. In order to update the sort order, we'll first select the **MonthName** column from the **Calendar table** and navigate to the **Column tools** tab and then the **Sort by column** button.

    | Table | Column | 
    | :---- | :----- |
    | Calendar | MonthName |  
    
    ![Sort by monthname](./Media/SortByMonthName.png)

1. From the available fields in our **Calendar** table, select the **Month** column (which is an integer number).

    ![Sort by month](./Media/SortByMonth.png)

1. If we review our **Table** visual, our months have now been sorted in the correct order.
    
    **Ex.** (1 = January, 2 = February, etc.)

    ![Sort by month](./Media/SortedMonthName.png)

    ⚠️ **Important** ⚠️

    Even if our organizations calendar does not start in January, we can still utilize this feature to sort order data. We would simply want to start the name (text) along with the sort by (number) in the appropriate order.

    **Ex.** (1 = June, 2 = July, etc.)

Learn more about [Sort by column](https://learn.microsoft.com/power-bi/create-reports/desktop-sort-by-column)

---

## Data category

1. Navigate to the model view on the side-rail.

    ![Full side rail.](./Media/ModelViewSideRail.png)

1. From the **Fields** pane first we'll select the field name from the table below and within the **Properties** expand the "**v Advanced**" section, to update the **Data category** value from the options below:

    | Table | Field | Data category |
    | :--- | :--- |  :--- |
    | Customers | RegionCountryName | Country/Region |
    | Customers | StateProvinceName | State of Province |1

    ![Region category](./Media/RegionCategory.png)

Learn more about [data categorization](https://learn.microsoft.com/power-bi/transform-model/desktop-data-categorization)

---

## Default summarization

1. While still in the model view and from the **Fields** pane first we'll select the following aggregate fields from the table below.

    To bulk select fields/measures, we can hold and select **Shift** on the keyboard for adjacent fields, or hold **Ctrl** to select individual fields.

    | Table | Field |
    | :-- | :-- |
    | Onine Sales | DiscountAmount |
    | Onine Sales | DiscountQuantity |
    | Onine Sales | ReturnAmount |
    | Onine Sales | ReturnQuantity |
    | Onine Sales | SalesAmount |
    | Onine Sales | SalesQuantity |

    ![Select fields](./Media/SelectFields.png)

1. In the **Properties** pane we'll now expand the "**v Advanced**" section, to update the **Summarize by** value to **None**:

    ![Summarize by](./Media/SummarizeBy.png)

Learn more about [aggregate](https://learn.microsoft.com/power-bi/create-reports/service-aggregates) fields

## Display folder

1. While still in the model view and from the **Fields** pane first we'll select the following measures from the table below and within the **Properties** pane we'll add the text **Measures** into the **Display folder** field. 

    To bulk select fields/measures, we can hold and select **Shift** on the keyboard for adjacent fields, or hold **Ctrl** to select individual fields.

    | Table | Field |
    | :-- | :-- |
    | Onine Sales | Total Items Discounted |
    | Onine Sales | Total Returned Items |
    | Onine Sales | Total Sales Amount |

    ![Display folder](./Media/DisplayFolder.png)

1. Within our **Fields** pane, our measures are now displayed within a folder - this will help with managing like items and also for users who connect to our model ensure a seamless experience in which to locate our measures. 

    ![Measures folder](./Media/MeasuresFolder.png)

## Synonyms

1. Let's return to the **Report** view once again.

    ![Report view](./Media/ReportView.png)

1. We'll double click on the report page to add the **Q&A** visual and type in the question: **"salary by customer name"**. Unfrotunately the result wasn't quite what we were expecting, so let's select the **Add synonyms now** to include more business terminology in our dataset.

    ![Add synonyms](./Media/AddSynonyms.png)

1. Within the **Field synonyms** window, we'll navigate to the **Customers** table and add the following synonyms to the fields in the table below, by pressing the **"Add+"** button and typing in our text. Once complete select the **X** in the top right corner to close out of the window.

    | Table | Field | Synonym |
    | :--- | :--- | :--- |
    | Customers | Full Name | customer |
    | Customers | YearlyIncome | salary |

    ![Field synonyms](./Media/FieldSynonyms.png)

1. On the report page, we now have a table reflecting the correct fields for our synonyms **salary** and **customer name**.

    ![Updated synonyms](./Media/UpdatedSynonyms.png)

---

# Data Analysis Expressions


## SAMEPERIODLASTYEAR

1. We'll start by completing our **[Total Sales SPLY]** measure, by leveraging our **Calendar** table and our **DateKey** column.

    Within our **CALCULATE** we want to change our filtering context, by looking at the values within our current period and then previous one year.

    ```
    CALCULATE([Total Sales Amount], SAMEPERIODLASTYEAR(Calendar[DateKey]))
    ```

    Completed formula below:

    ```
    Total Sales SPLY = 
    VAR _hassalesdata =
        NOT ( ISBLANK ( [Total Sales Amount] ) )
    RETURN
        IF (
            _hassalesdata,
            CALCULATE ( [Total Sales Amount], SAMEPERIODLASTYEAR (Calendar[DateKey] ) ),
            BLANK ()
        )
    ```

Learn more about [SAMEPERIODLASTYEAR](https://learn.microsoft.com/dax/sameperiodlastyear-function-dax)


## USERELATIONSHIP

With needing to filter by the order date and the delivery date from our **Online Sales** table, we will need to be able to control the active relationship in our measure. For this we'll leverage the USERELATIONSHIP function within DAX to enable the relationship between our **Calendar** table's **DateKey** and the **Online Sales** table's **DeliveryDate** with the below formula.

1. From the **Fields** pane, we'll right click the **Online Sales** table and select **New measure**

    ![Sales new measure](./Media/SalesNewMeasure.png)

1. In the formula bar we'll write the following DAX function and using the **CALCULATE** function, we'll change our current filtering context - with the **USERELATIONSHIP** function.

    ```
    Total Sales By Delivery Date =
    CALCULATE (
        [Total Sales Amount],
        USERELATIONSHIP ( DimDate[DateKey], FactOnlineSales[DeliveryDate] )
    )

    ```

Learn more about [USERELATIONSHIP](https://docs.microsoft.com/dax/userelationship-function-dax)

---

# Security

1. On the report canvas we'll create a new **Table** visual and add the following column from the table below to visualize our data.

    | Table | Column / Measure | 
    | :---- | :----- |
    | Employees | EmailAddress |
    | Stores | StoreName |
    | Online Sales | Total Sales Amount |  
    
    ![Sort by monthname](./Media/SecurityTable.png)

1. From the ribbon we'll navigate to the **Modeling** tab and within the security group select the **Manage roles** button.

    ![Manage roles](./Media/ManageRoles.png)


1. From the **Manage roles** window, we'll select **Create** first and give our role the title **Employee Store**. From the available tables in our model we'll then select the ellipses next to the **Employeess** table and select the **[EmailAddress]** field.

    ![Manage roles](./Media/ManageEmailAddress.png)

1. Within the **Table filter DAX expression** section, we'll upate the statement to retrieve the logged in users e-mail whenever they consume content from Power BI with the following DAX expression below, once complete - we can select the checkmark to confirm and then the **Save** button to complete.

    ```
    [EmailAddress] = USERPRINCIPALNAME()
    ```

    ![UPN name](./Media/UPNDax.png)

1. From the ribbon we'll navigate to the **Modeling** tab and within the security group select the **View as** button.

    ![View as role](./Media/ViewAsRoles.png)


1. Within the **View as roles** window, we'll first select the **Other user** field to view our data by passing in a test value - in this case we'll use the email address - **"andy0@contoso.com"** and choose the **Employee Store** role. Once complete select **OK** to return to the report and valide that only Andy's results are now visible. Once complete we can then select **Stop viewing**.

    ![View as role](./Media/ViewAsAndy.png)


---

# Publish to Power BI

1. From the **Home** tab, select the **Publish** icon and navigate to a non-production workspace as our destination and select the **Select** button when complete.
    1. <i>This can also be the same workspace used in the data preparation lab.</i>

    ![Publish dataset](./Media/PublishDataset.png)

    ⚠️ **Important** ⚠️

    For enterprise scenarios, a recommended architectural approach may be to separate dataflows, datasets and reports into separate workspaces designated for specific use. For the purposes of this workshop we've edited/published all Power BI items in the same workspace to maintain simplicity of lab instructions.
    
    Learn more about [managed self-service BI](https://learn.microsoft.com/power-bi/guidance/powerbi-implementation-planning-usage-scenario-managed-self-service-bi) and for a complete overview [Power BI implementation planning](https://learn.microsoft.com/power-bi/guidance/powerbi-implementation-planning-introduction)

---

# Next steps
We hope this portion of the lab has shown how various storage modes and modeling options can offer a flexible and optimized experience to build enterprise scalable solutions using Power BI Desktop.

- Continue to the [Data Visualization](./DataVisualization.md) lab
- Return to the [Day After Dashboard in a Day](./README.md) homepage