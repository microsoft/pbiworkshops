![Power BI](https://raw.githubusercontent.com/microsoft/pbiworkshops/main/_Asset%20Library/powerbi.svg)

# Day After Dashboard in a Day


## Introduction
In the Day After Dashboard in a Day you will learn about various concepts and features of Power BI. This course assumes that you have a working knowledge of report authoring using Power BI Desktop and content sharing via the Power BI service.

By the end of this lab, you will have learned:
1. How to prepare and load data into a dataflow using Power Query Online.
1. How to configure different [Storage Modes](https://docs.microsoft.com/power-bi/transform-model/desktop-storage-mode) and create [Aggregations](https://docs.microsoft.com/power-bi/transform-model/aggregations-advanced) using Power BI Desktop.

    Storage modes:
    1. [DirectQuery](https://docs.microsoft.com/power-bi/connect-data/desktop-directquery-about)
    1. [Mixed](https://docs.microsoft.com/power-bi/transform-model/desktop-composite-models)
1. How to analyze the performance and optimize a Power BI dataset.
1. How to design effective reports

[Learn more about the prerequisites for the lab](./Prerequisites.md).

#### Sample data
The AdventureWorks sample database is published by Microsoft to show how to design a SQL Server databases and Analysis Services models.

To learn more, see [AdventureWorks sample databases](https://docs.microsoft.com/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms).

#### Important note
The content for this lab must be in a **Power BI Premium** (Premium Per User or a Premium capacity subscription) workspace.

## Data Preparation

To learn more, see [Premium features of dataflow](https://docs.microsoft.com/power-bi/transform-model/dataflows/dataflows-premium-features)

### Import a dataflow model into a workspace


1. Navigate to a group workspace and select the **Settings** option in the top right. Within the navigation pane select the **Premium** tab. and ensure that a **Premium** license mode has been enabled.
    
    Any of the following options:
    - [x] Premium per user
    - [x] Premium per capacity
    - [x] Embedded 

| ![License mode](./Media/LicenseMode.png) |
    

1. Within the workspace select **New** and **Dataflow**.

    ![New Dataflow](./Media/NewDataflow.png)

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

To view a complete list of function documentation, from the **Home** tab select **Get data** and **Blank query**. You can update the **Source** step value to **#shared** and select **Next** to proceed.

```bash
let
    Source = #shared
in
    Source
```
A record set is returned including the [Power Query M function reference](https://docs.microsoft.com/powerquery-m/power-query-m-function-reference) documentation.

### Data profile


### Dataflow manifest



### Import dataflow model and enable DirectQuery with dataflows

1. Download the model.json file to a local file.

1. Select the **Import model** option.

    ![Import Model](./Media/ImportModel.png)

1. Select the SAMPLE.json from your local drive and then 

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

    ![Merge columns dialogue window.](./Media/MergeColumnsBox.png)

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

    ```bash
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



## Data Modeling

1. Add a **Table** visualization using the following columns:

| Table | Column |
|:----- | :------ |
| Customer | EmailAddress|
| Internet Sales | Sales Amount |



1. Navigate to the **View** tab and select **Performance analyzer**.

    ![Performance analyzer.](./Media/PerformanceAnalyzer.png)

1. Within the **Performance analyzer** pane, select **Start recording**.
    ![Start recording button.](./Media/StartRecording.png)

1.	Press the Clear option, Refresh visuals and Copy query
1.	Navigate to the Model view, select the Dimension tables, navigate to Advanced and Storage mode to change to Dual


## Data Visualization
