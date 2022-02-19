# Data Preparation

## Sample data

The data for this lab is from the AdventureWorks sample database, published by Microsoft to showcase how to design SQL Server databases and Analysis Services models.

---

# Download a sample dataflow model

We'll start our lab by importing a dataflow model and editing the dataflow's credentials so that we can ingest the sample files, transform data and perform a refresh operation once complete.

1. Download the sample [**Dataflow demo.json**](https://raw.githubusercontent.com/microsoft/pbiworkshops/main/Day%20After%20Dashboard%20in%20a%20Day/Source_Files/Dataflow%20demo.json) file which will be used as a starting point with pre-defined tables and custom functions for the lab.

---

# Premium license mode

1. Navigate to a new, empty or non-production workspace and confirm that a capacity has been assigned to the workspace, if not we'll use this opportunity to enable the option by selecting one of the below values.
    1. In the top right corner of the workspace, select the **Settings** option.
    1. In the navigation pane, select the **Premium** tab and verify one of the licensing modes listed below has been enabled.

    **License mode:**
    - [Premium per user](https://docs.microsoft.com/power-bi/admin/service-premium-per-user-faq)
    - [Premium per capacity](https://docs.microsoft.com/power-bi/admin/service-premium-gen2-faq)
    - [Embedded](https://docs.microsoft.com/power-bi/developer/embedded/embedded-capacity)

    ![License mode](./Media/LicenseMode.png)

## Import a dataflow model

1. In the top left of the workspace select **New** and then the **Dataflow** option.

    ![New Dataflow](./Media/NewDataflow.png)

1. From the **Start creating your dataflow** screen, select the **Import Model** option and import the existing dataflow model file from your local save destination.

    ![Import Model](./Media/ImportModel.png)

## Edit the dataflow credentials

1. Once the import has successfully completed, we can select the **Edit credentials** button from the toast notification in the top right.
    1. Alternatively within the workspace we can also select the vertical ellipses ( ⋮ ) adjacent to the dataflow name and then the **Settings** option to configure.

    ![Edit credentials](./Media/EditCredentials.png)

## Edit the dataflow credentials

1. Within the Settings page for the dataflow, expand the **Data source credentials** section and select **Edit credentials** adjacent to the **Web** source. In the **Configure** dialog window set the following values below and then select **Sign in** once complete:
    1. Authentication method | **Anonymous**
    1. Privacy level setting for this data source | **Public**
        1. To learn more, see [Power Query privacy level settings](https://docs.microsoft.com/power-bi/admin/desktop-privacy-levels#configure-a-privacy-level)
    1. ☑️ **Skip test connection**

    ![Edit credentials](./Media/ConfigureCredentials.png)

---

# Configure Global options in the Power Query Online editor

With our dataflow successfully imported and credentials set, we'll want to configure our development environment's experience when authoring in the Power Query Online editor.

---

1. From the group workspace, select the ellipses (...) adjacent to the dataflow name and then the **Edit** option.

    ![Edit dataflow](./Media/EditDataflow.png)

1. Our imported dataflow model includes additional standardized categories as part of the [metadata file (model.json)](https://docs.microsoft.com/common-data-model/model-json). The standardized format enables discovery across other Microsoft products and provides the semantic information to those applications - including the tables, columns, metadata descriptions and more. To update the dataflow model in the top right we'll select the **Edit tables** option to navigate into the Power Query Online experience.

    ![Edit tables](./Media/EditTables.png)

1. Before we begin using the Power Query Online interface we'll enable some additional authoring settings which will persist the next time we need to author new content. From the **Home** tab, select the **Options** > **Global options** property.

    ![Global options](./Media/GlobalOptions.png)

1. Within the **Global options** window ensure the following settings are enabled and select **OK** once complete.

    **Steps**
    1. Enable step cost indicators
    1. Show script in step callout

    **Column profile**
    1. Enable column profile
    1. Show column value distribution in data preview
    1. Show column value distribution in data preview
    1. Show column profile in details pane

    **Type detection**
    1. Never detect column types and headers for unstructured sources

    **Parameters**
    1. Always allow parameterization in data source and transformation dialogs

    ![Global options window](./Media/GlobalOptionsWindow.png)

---

# Generate a list of values

Now that we're ready to begin ingesting data, for this portion of the lab we'll want to combine new data which is added to a (**Web page**) file location. The total number of files that will be added to this location is unknown but will continue to grow with time, to which we'll need to account for with a [future proofed](https://docs.microsoft.com/power-query/best-practices#future-proofing-queries) solution. Fortunately for us, the files maintain a consistent column naming, data type and file naming structure (**FactInternetSales_#.csv**) to make collecting and combining the new data easier.

---

1. From the **Home** tab select the drop-down for **Get data** and the **Blank query** option to create a new query.
    1. Keyboard shortcut: **Ctrl + M**

    ![New Blank Query](./Media/NewBlankQuery.png)

1. Within the **Advanced editor** window, we'll create a custom function for our file name that [combines text](https://docs.microsoft.com/powerquery-m/text-combine) for our prefix, file number and file extension and converts the [text from](https://docs.microsoft.com/powerquery-m/text-from) a value. Select **Ok** when complete.
    1. You can test the return value of the function by supplying a numeric value and then selecting the **Invoke** option.

    ```fsharp
    let
      // A function that accept a file number value and concatenates text
      fxFileName = (#"File number" as number) as text =>
                    Text.Combine(
                        {
                            "FactInternetSales_",
                            Text.From(#"File number"),
                            ".csv"
                        }
                    )
    in
      fxFileName
    ```

2. We'll open the **Advanced Editor** once again and complete the following:
    1. Add a comma to end of the **fXFileName** step
    1. On a new line we'll create a step with the identifier name of **Source** which equals a [**Record**](https://docs.microsoft.com/powerquery-m/expressions-values-and-let-expression#record) type, containing the following name/value pairing as displayed below and update the return value to **Source** after the text **in**.
    
    | Name | Value |
    | :--- | :---- |
    | fileCount | 1 |
    | fileName | fxFileName(fileCount) |
    | data | fxGetFile(fileName) |

    ```fsharp
    let
      // A function that accept a file number value and concatenates text
      fxFileName = (#"File number" as number) as text =>
                    Text.Combine(
                        {
                            "FactInternetSales_",
                            Text.From(#"File number"),
                            ".csv"
                        }
                    ),
      Source = [
                fileCount = 1,
                fileName = fxFileName(fileCount),
                data = fxGetFile(fileName)
            ]
    in
      Source
    ```

4. Enable the **Query script** view, to view the full script in the center of the window. 
    1. To validate the results are updating, we can change the **fileCount** value to **2** and review the data preview's **fileName** and **data** values.
    1. If a change was made, return the **fileCount** value to **1** before proceeding.

    ![Query script](./Media/QueryScript.png)

5. Within the expanded **Query script** view, add a comma to the end of the **Source** step and add a new step with the step identifier name of **fileList** with the **List.Generate** function value, and update the text after the **in** statement to **fileList** to review the functions documentation.
    1. Typing any function name without the open and closed parenthesis proceeding will return the function's documentation.

    ```fsharp
    let
      // A function that accept a file number value and concatenates text
      fxFileName = (#"File number" as number) as text =>
                    Text.Combine(
                        {
                            "FactInternetSales_",
                            Text.From(#"File number"),
                            ".csv"
                        }
                    ),
      Source = [
                fileCount = 1,
                fileName = fxFileName(fileCount),
                data = fxGetFile(fileName)
            ],
      fileList = List.Generate
    in
      fileList
    ```

6. Now that we've reviewed the documentation, update the **Query script** view to the below.
    1. For the **initial** parameter include the goes-to "**=>**" symbol and then the **Source** step.
    1. For the **condition** parameter, we'll use square brackets to reference the initialized **Source** value's **[data]** to logically test that the returned value is **not** empty, when using the **[Table.IsEmpty()](https://docs.microsoft.com//powerquery-m/table-isempty)** function.
    1. For the **next** parameter, create a record that matches the **Source** step's **fileCount**, **fileName** and **data** fields and increment the **fileCount** by it's current integer value plus **one**.

    ```fsharp
    let
      // A function that accept a file number value and concatenates text
      fxFileName = (#"File number" as number) as text =>
                    Text.Combine(
                        {
                            "FactInternetSales_",
                            Text.From(#"File number"),
                            ".csv"
                        }
                ),
        Source = [
            fileCount = 1,
            fileName = fxFileName(fileCount),
            data = fxGetFile(fileName)
        ],
        fileList =
            List.Generate(
                () => Source,
                each not Table.IsEmpty([data]),
                each
                    [
                        fileCount = [fileCount] + 1,
                        fileName = fxFileName(fileCount),
                        data = fxGetFile(fileName)
                    ]
            )
    in
        fileList
    ```
1. To convert out returned list to a table, navigate to the **List tools** tab in the ribbon and select the **To table** option.

    ![List tools](./Media/ListToTable.png)

1. In the top right of the **Column1** column - we'll select the expand columns icon, and disable the **Use original column name as prefix** option and select **OK** when complete.

    ![Expand columns](./Media/ExpandColumns.png)

1. Right click the **data** column and select the **Remove other columns** option to remove all other columns from the current table. 

    ![Remove other columns](./Media/RemoveOtherColumns.png)

1. In the top right of the **data** column - select the expand columns icon, disable the **Use original column name as prefix** option and select **OK** when complete.(#tab/step)

    ![Expand data column](./Media/ExpandDataColumn.png)

1. While holding the **shift** key on our keyboard, select the **ProductKey** column and then **Freight** column to highlight all columns in our table. Navigate to the **Transform** tab and then select **Detect data type** to change the current columns [any value](https://docs.microsoft.com/power-query/data-types) (ABC123) to a more appropriate data type automatically.
    1. We can also select any cell in our table and press **Ctrl+A** to select all cells and columns.

    ![Detect data type](./Media/DetectDataType.png)

1. Within the **Query settings** pane, change the **Name** of the completed query to **FactInternetSales_raw**.

    ![Query name](./Media/QueryName.png)

### Optional: Power Query M function reference

To view a complete list of Power Query function documentation, from the **Home** tab select **Get data** and **Blank query**. Update the **Source** step value to **#shared** and select **Next** to proceed.

```fsharp
let
    Source = #shared
in
    Source
```
A record set is returned including the [Power Query M function reference](https://docs.microsoft.com/powerquery-m/power-query-m-function-reference) documentation.

# Grouping queries

1. In the **Queries** pane, while holding **ctrl**, select the following tables from the list below, once complete right click and select the **Move to group** > **New group...** option.

    1. DimProduct_raw
    1. DimProductCategory_raw
    1. DimProductSubcategory_raw
    1. FactInternetSales_raw

    ![Query name](./Media/StagingGroup.png)

    1. In the **New group** window set the name to **Data staging** and the **Description** to the following text below and select **Ok** once complete.

        ```
        Data that will be ingested from the source and referenced in computed tables for transformations via the enhanced compute engine.
        ```
    
        ![New group](./Media/NewGroup.png)

1. In the **Queries** pane, while holding **ctrl**, select the following tables from the list below, once complete right click and select the **Move to group** > **New group...** option.

    1. DimCustomer
    1. DimDate
    1. DimEmployee
    1. DimGeography

    ![Query name](./Media/NewGroupDataLoad.png)

    1. In the **New group** window set the name to **Data load** and the **Description** to the following text below and select **Ok** once complete.

        ```
        Data that will be ingested from the source without transformations.
        ```
    
        ![New group](./Media/NewGroupDataLoadDescription.png)

1. Our **Queries** pane now contains two groups to help make managing and distinguishing our queries intent more effective at a glance. For more detail we can also hover above the group's folder icon where the **description** value of each will be visible.

    ![New group](./Media/GroupDescription.png)

---

# Computed tables for transformation logic

With data now being ingested and stored in our dataflow's [Azure Data Lake Storage Gen2](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction), we'll want to leverage [computed tables](https://docs.microsoft.com/power-query/dataflows/computed-entities-scenarios) to apply our transformation logic via the enhanced compute engine. 

[Learn more about the benefits of loading data without transformation for Text/CSV files](https://docs.microsoft.com/power-query/dataflows/computed-entities-scenarios#load-data-without-transformation-for-textcsv-files)

---

## Reference a query to create a computed table

1. In the **Queries** pane, right click the **FactInternetSales_raw** table we created earlier and select the **Reference** option to create a computed table. Once complete we will see a new query has been created with a lightning bolt icon (⚡) indicating that this is a computed table.

    ![Query reference](./Media/QueryReference.png)

1. In the **Queries** pane - right click the **FactInternetSales_raw (2)** table, select **Rename** and update the query title to **FactInternetSales**.

    ![Rename option](./Media/RenameOption.png)

1. In the **Queries** pane - right click the **FactInternetSales** computed table, select the **Move to group** > **New group...** option and complete the following.
    1. **Name:** Data transformation
    1. **Description:** Data that will be ingested from the data lake storage for transformations.

    ![Transformation group](./Media/NewGroupTransformation.png)

## Transform multiple columns simultaneously

1. Before we begin we'll change the current **Script** view to **Step script** in the bottom right hand corner of the screen.

    ![Step secript](./Media/StepScript.png)

1. While still in the **FactInternetSales** query, we'll select the **fx** icon to the left of the formula bar to insert a new step into the query.

    ![Insert step](./Media/InsertStep.png)

1. Within the formula bar we'll utilize the [Table.TransformColumns](https://docs.microsoft.com/powerquery-m/table-transformcolumns) function to apply a [list](https://docs.microsoft.com/powerquery-m/expressions-values-and-let-expression#list) of transformation operations to multiple columns in a single step - in the order of { column name, transformation , *optional type* } from the table below -

    | Column name | Transformation | Type |
    | :--- | :--- | :--- |
    | OrderDate | fxCreateKey | Int64.Type |
    | ShipDate | fxCreateKey | Int64.Type |

    **Complete formula**

    ```fsharp
        Table.TransformColumns(
        Source,
        {
            {
                "OrderDate",
                fxCreateKey,
                Int64.Type
            },
            {
                "ShipDate",
                fxCreateKey,
                Int64.Type
            }
        }
    )
    ```

1. While holding the **shift** key select the **SalesAmount**, **TaxAmount** and **Freight** columns, right click any one of the selected columns and choose the **Change type** and then the **Currency** option.
    1. The [**Currency**](https://docs.microsoft.com/power-query/data-types) type is a fixed decimal number and always has four digits to its right.

    ![Currency type](./Media/CurrencyType.png)

---

# Enabling the enhanced compute engine

The enhanced compute engine in Power BI enables Power BI Premium subscribers to use their capacity to optimize the use of dataflows. 

Using the enhanced compute engine provides the following advantages:

1. Drastically reduces the refresh time required for long-running ETL steps over computed tables, such as performing joins, distinct, filters, and group by
1. Performs DirectQuery queries over tables

[Learn more about the enhanced compute engine](https://docs.microsoft.com/power-bi/transform-model/dataflows/dataflows-premium-features?tabs=gen2)

---

1. 

1. To ensure we can perform DirectQuery operations, we'll need to change the default setting from **Optimized** to **On** within the within the **Enhanced compute engine settings** and select the **Apply** button once complete.

    ![Enhanced compute engine settings.](./Media/EnhancedComputeEngineSettings.png)

1. After we've received the **Success!** notification, return to the workspace and select the **Refresh now** option of the datalfow for the optimization to take effect.

    ![Refresh now.](./Media/RefreshNow.png)

---

# Query folding

Query folding is the ability for a Power Query query to generate a single query statement to retrieve and transform source data. The Power Query mashup engine strives to achieve query folding whenever possible for reasons of efficiency.

[Learn more about query folding](https://docs.microsoft.com/power-query/power-query-folding)

---

1. Within **Power BI Desktop**'s **Home** ribbon select the **Get data** button. Within the **Get dialog** window select the **Power Platform** section and then **Dataflows** connector. Select **Connect** to continue to the **Dataflows** navigator window.

    ![Power Platform dataflows.](./Media/ppDataflows.png)

1. Within the **Navigator** window, navigate to the group Workspace where the dataflow is located and select all of the tables located within the dataflow. Select **Transform Data** when complete to enter the **Power Query Editor** window.

    ![Get dataflow tables.](./Media/getDataDataflow.png)

1. Navigate to the **DimCustomer** table, holding the **shift** key select the **FirstName**, **MiddleName** and **LastName** columns, right click one of the selected columns and choose the **Merge Columns** option.

    ![Merge Columns option.](./Media/MergeColumns.png)

1. Within the **Merge columns** window change the **Separator** option to **Space**, set the **New column name (optional)** option to **Full Name** and select **OK** when complete.

    ![Merge columns dialog window.](./Media/MergeColumnsBox.png)

1. In the **Query settings** pane on the right, navigate to the **Merge Columns** step, right click and select the **View Native Query** option.

    ![View Native Query.](./Media/ViewNativeQuery.png)

1. Navigate to the **Add Column** tab and select the **Conditional Column** option. Within the **Add Conditional Column** dialog complete the following and select **OK** when complete:
    1. New column name: **Gender**
    1. Match the following conditions to the table below.
        1. Use the **Add Clause** to add new conditions.

    |  | Column Name | Operator | Value | Output | 
    | :------- | :-------| :-------| :-------| :-------|
    | If | Title | equals | Mr. | Male |
    | If | Title | equals | Sr. | Male |
    | If | Title | equals | Ms. | Female |
    | If | Title | equals | Sra. | Female |
    | else | Unknown | | |

    ![View Native Query.](./Media/AddConditionalColumn.png)

1. In the **Query settings** pane on the right, navigate to the **Add Conditional Column** step, right click and select the **View Native Query** option.

    ![View Native Query for Conditional Column.](./Media/ConditionalQuery.png)

1. From the **Formula bar** select the **Add Step** button and type in the following formula below.
    1. If the **Formula Bar** is not enabled navigate to the **View** tab and select the **Formula Bar** checkbox.

    ![Add Step.](./Media/AddStep.png)

    ```fsharp
    = Table.AddColumn(
                #"Merged Columns",
                "Gender",
                each
                    if
                        List.Contains(
                            {
                                "Mr.",
                                "Sr."
                            },
                            [Gender]
                        )
                    then
                        "Male"
                    else if
                        List.Contains(
                            {
                                "Ms.",
                                "Sra."
                            },
                            [Gender]
                        )
                    then
                        "Female"
                    else
                        "Not Provided",
                type text
            )
    ```

1. In the **Query settings** pane on the right, navigate to the **Custom1** step, right click and select the **View Native Query** option to review the difference in the generated query which now uses the [IN (Transact-SQL)](https://docs.microsoft.com/sql/t-sql/language-elements/in-transact-sql?view=sql-server-ver15) clause.

    ![List contains.](./Media/ListContains.png)

1. Right click the **Applied Steps** step named **Custom1** and select **Properties...** to open the **Step Properties** dialog box. Once the **Step Properties** is visible update the **Name** property to **Custom: Gender** and the **Description** field to the below text. Once complete select **OK** to complete.

    ```bash
    If value is Mr. or Sr. replace with Male.
    If value is Ms. or Sra. replace with Female.
    Otherwise replace with Not Provided.
    ```

    ![Step Properties.](./Media/StepProperties.png)

1. Review the new **Custom: Gender** step's properties by hovering above the step name to view the documentation.

    ![Step documentation.](./Media/StepDocumentation.png)

1. Right click the original **Added Conditional Column** step and select the **Delete** option to remove.
    1. Selecting the adjacent **X** to the left of the step name is also an option.

    ![Delete.](./Media/DeleteStep.png)

## Next steps
We hope this tour has shown how the data preparation capabilities in Power BI can provide...

- Continue to the [Data Modeling](./DataModeling.md) lab
- Return to the [Day After Dashboard in a Day](./README.md) homepage