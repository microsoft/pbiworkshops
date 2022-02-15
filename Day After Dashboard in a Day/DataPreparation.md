## Data Preparation

#### Sample data
The data for this lab is the AdventureWorks sample database, published by Microsoft to showcase how to design SQL Server databases and Analysis Services models.

### Import a dataflow model into a group workspace and edit credentials

A dataflow has been partially started, which we'll now be responsible for editing to the labs completion. To get started we'll import the existing dataflow model and edit credentials, so that you can transform the data and perform refresh operations.

1. Download the sample **Dataflow demo.json** file, which contains the metadata format.

1. To use the [premium features of dataflows](https://docs.microsoft.com/power-bi/transform-model/dataflows/dataflows-premium-features) in this lab we'll need to ensure the group workspace has a capacity assigned. In the top right corner of the group workspace, select the **Settings** option and in the navigation pane select the **Premium** tab to confirm that a **Premium** license mode has been enabled from any one of the options below.

    **License mode:**
    - [Premium per user](https://docs.microsoft.com/power-bi/admin/service-premium-per-user-faq)
    - [Premium per capacity](https://docs.microsoft.com/power-bi/admin/service-premium-gen2-faq)
    - [Embedded](https://docs.microsoft.com/power-bi/developer/embedded/embedded-capacity)

    ![License mode](./Media/LicenseMode.png)

1. After you've confirmed the group workspace has the appropriate license mode enabled, in the top left of the group workspace select **New** and then the **Dataflow** option.

    ![New Dataflow](./Media/NewDataflow.png)

1. From the **Start creating your dataflow** screen, select the **Import model** option to import the an existing model and select the **Dataflow demo.json** file from the local destination.

    ![Import Model](./Media/ImportModel.png)

1. Once the import has successfully completed, select the **Edit credentials** button from the toast notification.
    1. Alternatively within the workspace you can also select the vertical ellipses ( ⋮ ) adjacent to the dataflow name and then select the **Settings** option to configure.

    ![Edit credentials](./Media/EditCredentials.png)

1. Within the Settings page for the dataflow, expand the **Data source credentials** section and select **Edit credentials** adjacent to the **Web** source. For this lab, we'll be connecting to publicly accessible sample files - to configure the connection in the **Configure** dialog box set the following values below and select **Sign in** when complete:
    1. Authentication method | **Anonymous**
    1. Privacy level setting for this data source | **Public**
        1. To learn more, see [Power Query privacy level settings](https://docs.microsoft.com/power-bi/admin/desktop-privacy-levels#configure-a-privacy-level)
    1. ☑️ **Skip test connection**

    ![Edit credentials](./Media/ConfigureCredentials.png)

---

### Configure Global options in the Power Query Online editor

Now that our dataflow has been successfully imported and the credentials set, we'll want to configure the development experience for an optimal workflow when authoring in the Power Query Online editor.

---

1. From the group workspace, select the ellipses (...) adjacent to the dataflow name and then the **Edit** option.

    ![Edit dataflow](./Media/EditDataflow.png)

1. The imported dataflow model included additional standardized metadata as part of the [metadata file (model.json)](https://docs.microsoft.com/common-data-model/model-json). The standardized format enables discovery across other Microsoft products and provide semantic information to applications - including the table information's column types, metadata descriptions and more. To update the dataflow model in the top right select the **Edit tables** option to navigate into the Power Query Online interface.

    ![Edit tables](./Media/EditTables.png)

1. Within the Power Query Online editor you'll want to enable additional authoring settings which will persist across all projects - from the **Home** tab - select the **Options** > **Global options** property.

    ![Global options](./Media/GlobalOptions.png)

1. Within the **Global options** window ensure the following settings are enabled.

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

### Generate a list of values

Now that you're ready to begin transforming data, this portion of the labs requirements are as follows - new information is being added to a file location (**Web page**) which you will need to combine during refresh activities for ongoing analysis. The total number of files that will be added is unknown but will continue to grow with time, to which you should account for with a [future proof](https://docs.microsoft.com/power-query/best-practices#future-proofing-queries) solution. Fortunately, the files maintain a consistent column naming, data type and file naming (**FactInternetSales_#.csv**) to make collecting and appending new data easier.

---

1. From the **Home** tab select the drop-down for **Get data** and the **Blank query** option to create a new query.

    ![New Blank Query](./Media/NewBlankQuery.png)

1. Within the **Advanced editor** window, we'll create a custom function for our file name that [combines text](https://docs.microsoft.com/powerquery-m/text-combine) for our prefix, file number and file extension and converts the [text from](https://docs.microsoft.com/powerquery-m/text-from) a value. Select **Ok** when complete.

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
2. Open the **Advanced Editor** once again, add a comma to end of the **fXFileName** step and add a new step with the identifier name **Source** which equals a **Record** data type, containing the key values of **fileCount**, **fileName** and **data** and their corresponding values as displayed below and update the return value to **Source** after the text **in**.

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
    1. To validate the results are updating, change the **fileCount** value to **2** and review the data preview's **fileName** and **data** values.
    1. Return the **fileCount** value to **1** before proceeding.

    ![Query script](./Media/QueryScript.png)

5. Within the expanded **Query script** view, add a comma to the end of the **Source** step and add a new step with the identifier name **fileList** and value **List.Generate**, and update the return value to **fileList** after the text **in**.

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

6. Update the script

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
1. Within the **List tools** tab, select the **To table** option to convert the list to a table.

    ![List tools](./Media/ListToTable.png)

1. In the top right of the **Column1** column - select the expand columns icon, disable the **Use original column name as prefix** option and select **OK** when complete.

    ![Expand columns](./Media/ExpandColumns.png)

1. Right click the **data** column and select the **Remove other columns** option to remove all other columns from the current table. 

    ![Remove other columns](./Media/RemoveOtherColumns.png)

1. In the top right of the **data** column - select the expand columns icon, disable the **Use original column name as prefix** option and select **OK** when complete.

    ![Expand data column](./Media/ExpandDataColumn.png)

1. While holding the **shift** key on our keyboard, select the **ProductKey** column and then **Freight** column to highlight all columns in your table. Navigate to the **Transform** tab and then select **Detect data type** to change the current columns [any value](https://docs.microsoft.com/power-query/data-types) (ABC123) to a more appropriate data type automatically.
    1. You can also select any cell in your table and press **Ctrl+A** to select all cells and columns.

    ![Detect data type](./Media/DetectDataType.png)

1. FactInternetSales - SURROGATE KEYS on Order Date and Ship Date columns.



### Power Query M function reference

To view a complete list of function documentation, from the **Home** tab select **Get data** and **Blank query**. Update the **Source** step value to **#shared** and select **Next** to proceed.

```fsharp
let
    Source = #shared
in
    Source
```
A record set is returned including the [Power Query M function reference](https://docs.microsoft.com/powerquery-m/power-query-m-function-reference) documentation.


### Enhanced compute engine

1. Within the **Enhanced compute engine settings**, select the **On** option and then select the **Apply** button.

![Enhanced compute engine settings.](./Media/EnhancedComputeEngineSettings.png)

1. After you've received the **Success!** notification, return to the workspace and select the **Refresh now** option of the datalfow for the optimization to take effect.

    ![Refresh now.](./Media/RefreshNow.png)

[Learn more about DirectQuery with dataflows](https://docs.microsoft.com/power-bi/transform-model/dataflows/dataflows-premium-features#use-directquery-with-dataflows-in-power-bi)

### Query folding

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

## Next steps:
We hope this tour has shown how the data preparation capabilities in Power BI can provide...

- Continue to the [Data Modeling](./DataModeling.md) lab
- Or return to the [Day After Dashboard in a Day](./README.md) homepage