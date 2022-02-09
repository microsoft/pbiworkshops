## Data Preparation

**TO DO** - Learning about the Power Query Online environment and dataflows.

To learn more, see [Premium features of dataflow](https://docs.microsoft.com/power-bi/transform-model/dataflows/dataflows-premium-features)

### Import a dataflow model into a workspace

1. Download the sample **model.json** file.

1. Navigate to a group workspace and select the **Settings** option in the top right. Within the **Settings** navigation pane select the **Premium** tab to ensure that a **Premium** license mode has been enabled from any of the following options below.

    **License mode:**
    - Premium per user
    - Premium per capacity
    - Embedded

    ![License mode](./Media/LicenseMode.png)

1. Within the top left of the current workspace select **New** and then **Dataflow**.

    ![New Dataflow](./Media/NewDataflow.png)

1. From the **Start creating your dataflow** screen select the **Import model** option.

    ![Import Model](./Media/ImportModel.png)

1. Once the import has completed, select **Edit credentials**.
    1. Alternatively you can click the ellipses (...) next to the dataflow and go to **Settings** within the workspace.

    ![Edit credentials](./Media/EditCredentials.png)

1. Expand the **Data source credentials** section and select **Edit credentials**. Within the **Configure** dialog box set the following values below and select **Sign in** when complete:
    1. Authentication method | **Anonymous**
    1. Privacy level setting for this data source | **Public**
        1. To learn more, see [Power Query privacy level settings](https://docs.microsoft.com/power-bi/admin/desktop-privacy-levels#configure-a-privacy-level)
    1. ☑️ **Skip test connection**

    ![Edit credentials](./Media/ConfigureCredentials.png)

### Edit a dataflow using Power Query Online

1. From the workspace, select the ellipses (...) adjacent to the dataflow name and then the **Edit** option.

    ![Edit dataflow](./Media/EditDataflow.png)

1. Within the top right select the **Edit tables** option to navigate into the Power Query Online interface.

    ![Edit tables](./Media/EditTables.png)

1. Within the Power Query Online editor's **Home** tab, select the **Options** - **Global options** property.

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
    **Parameters**
    1. Always allow parameterization in data source and transformation dialogs
1. 

### Generate a list of values

**Task:** New files are being dropped to a publicly accessible **Web page** which you have been tasked with collecting. All of the files maintain a consistent column - naming, data type - and the file names follow a format of **FactInternetSales_#.csv** to make combining the files easier.

1. From the **Home** tab select the drop-down for **Get data** and then **Blank query**.

    ![New Blank Query](./Media/NewBlankQuery.png)

1. Within the **Advanced editor** window update the current query to the text below - creating a custom function that [combines text](https://docs.microsoft.com/powerquery-m/text-combine) and converts to [text from](https://docs.microsoft.com/powerquery-m/text-from) a value. Select **Ok** when complete.

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

5. FactInternetSales - SURROGATE KEYS on Order Date and Ship Date columns.

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

1. Within the **Navigator** window, navigate to the group Workspace where your dataflow is located and select all of the tables located within the dataflow. Select **Transform Data** when complete to enter the **Power Query Editor** window.

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

1. From the **Formula bar** select the **Add Step** button and paste in the following formula below.
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

1. In the **Query settings** pane on the right, navigate to the **Custom1** step, right click and select the **View Native Query** option to review.

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