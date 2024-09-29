# Data Preparation

In this lab, you will learn how to create a comprehensive data ingestion solution using a data pipeline and Dataflow Gen2 in Microsoft Fabric. We will begin by setting up the copy activity to transfer data from a sample source to a dynamic destination within a lakehouse. This process includes using the expression builder to create a dynamic folder structure based on the current date of execution.

Throughout the lab, you will validate and run the pipeline to ensure that the data ingestion process is successful and that the data is organized correctly in the lakehouse. By the end of this lab, you will have a solid understanding of how to efficiently manage a data ingestion workflow.

## Data pipelines

### Creating a data pipeline and data connection

1. Select **New item** from the **Collect data** task. This task is for ingesting data, ensuring that your processes are scalable and robust.

    ![Collect data new item](./Media/collect-data-new-item.png)

1. Within the Create an item window, the available options within Microsoft Fabric have been filtered down to **Recommended items** only again. Select the **Data pipeline** item which is essential for automating the movement and transformation of data from various sources to destinations.

    ![New item data pipeline](./Media/task-flow-new-item-data-pipeline.png)

1. In the New pipeline window, set the data pipeline name to "**getContosoSample**" and then select **Create**.

    ![New pipeline name](./Media/new-pipeline-name-getcontososample.png)

1. From the new and empty data pipeline, select the **Pipeline activity** watermark option and then choose **Copy data** to add this activity to the authoring canvas.

    ![Copy data from watermark](./Media/pipeline-activity-copy-data.png)

1. With the **Copy data** activity selected, navigate to the **Source** tab. Within the **Connection** drop-down menu, select the **More** option to launch the Get data navigator. This navigator provides a comprehensive interface for connecting to various data sources, ensuring that you can easily integrate different data streams into your pipeline.

    ![Copy data connection more option](./Media/source-connection-more.png)

1. From the Get data navigator, select **Add** from the left side-rail and then choose the **Http** connector. The Http connector allows you to connect to web-based data sources, providing flexibility in accessing data from various online resources.

    ![Get data http](./Media/get-data-http.png)

1. Paste the following sample Zip file address from GitHub into the **Url** path. Also set the **Connection name** property to something more discoverable for future use, such as your initials and then "ContosoSample." Naming your connections helps in easily identifying and managing different data sources within your project. Once complete, select **Connect** to establish the connection.

    ```text
    https://github.com/microsoft/pbiworkshops/raw/main/Day%20After%20Dashboard%20in%20a%20Day/Source_Files/ContosoSales.zip
    ```

    ![Contoso sample connection](./Media/contoso-sample-connection.png)

### Copy activity settings

1. With the **Copy data** activity selected and the **Source** tab displayed, select the **Settings** option next to the File format field. Within the **Compression type** setting, choose **ZipDeflate (.zip)** and select **OK** to complete.

    ![Contoso sample connection](./Media/zip-deflate-compression.png)

1. Next, with the Copy data activity still selected and the Source tab displayed, expand the **Advanced** section. Deselect the option to **Preserve zip file name as folder**. This allows you to customize the folder name for your zip contents, providing more flexibility in organizing your data.

    ![Deselect preserve zip file name](./Media/deselect-preserve-zip-file-name.png)

1. With the Copy data activity still selected, navigate to the **Destination** tab. From the list of connections, select the previously configured lakehouse **IADLake**. This step ensures that the data is being copied to the correct destination, which is essential for maintaining data integrity and organization.

    ![Destination lakehouse](./Media/destination-biadlake.png)

1. Within the Destination settings, select the **Files** option and then the **Directory** file path text input box. This will display the **Add dynamic content [Alt+Shift+D]** property. Select this text to open the pipeline expression builder. The expression builder allows us to create dynamic file paths, which can be customized based on various dynamic parameters such as date and time or static text values.

    ![Destination lakehouse](./Media/destination-files-directory.png)

1. In the Pipeline expression builder window, select the **Functions** tab. Here, you can explore various functions that exist within the expression library, in this example we'll use both date and string functions to create a dynamic folder path. When you're ready, copy and paste the code block below into the expression input box. Press **Ok** when complete.

    ```text
    @concat(
        formatDateTime(
            convertFromUtc(
                utcnow(), 'Central Standard Time'
            ),
            'yyyy/MM/dd'
        ),
        '/ContosoSales'
    )
    ```

    ![Destination folder](./Media/expression-builder-date-and-folder.png)

1. With the Copy data activity and Destination settings still selected, select the drop-down for the **Copy behavior** and then choose the **Preserve hierarchy** option. This option maintains the original file names as they are within the zip file, ensuring that the file structure is preserved during the copy process.

    ![Destination folder](./Media/copy-behavior-preserve.png)

1. Navigate to the General tab with the Copy data activity selected. Update the **Name** and **Description** fields with the appropriate text. This step helps in identifying and managing the activity within your pipeline, making it easier to understand its purpose and functionality.

    | Property | Text |
    | :-- | :-- |
    | Name | Get and Unzip files |
    | Description | Copies sample data from GitHub and stores raw content in lakehouse files |

    ![Copy data general descriptions](./Media/copy-data-general.png)

1. From the **Home** tab, select the **Validate** option to first confirm that there are no issues with your pipeline. This validation step helps in identifying any errors to be fixed before running the pipeline. Once validated, select the **Save** option and then **Run** to start the ingestion from the data pipeline. Running the pipeline initiates the data transfer, allowing you to see the results of your configuration in action within the output window.

    ![Validate save and run the pipeline](./Media/pipeline-validate-save-run.png)

1. Deselect any previously selected activities within the authoring canvas. This action will make the global properties and **Output** view visible. After starting the run of your pipeline, both the Pipeline status and any individual Activity statuses should show a **Succeeded** status. This indicates that everything ran as intended, confirming that your data ingestion process was successful.

    ![Unzip copy output succeeded](./Media/unzip-pipeline-status-succeeded.png)

1. If we return to our previously created **IADLake** lakehouse item (either by selecting it on the left side rail if still open or by returning to the workspace item list to open), we can confirm that the zip file's content has now been added to the Files section. The files should be organized with a nested folder structure based on the year, month, date, and data source title for the pipeline run.

    ![Copy output succeeded](./Media/unzip-lakehouse-contents.png)

### Creating and applying variables

1. To avoid recreating the same expression throughout our solution, we'll create a variable to store our folder path. First, navigate to the **Activities** tab and select the **Set variable** activity. Once added to the canvas, move the activity card to the left of the copy data activity.

    ![Add set variable](./Media/add-set-variable.png)

1. With the **Set variable** activity selected, navigate to the **Settings** tab. Next to the **Name** property, select **New**. This step allows you to create a new variable that will be used in your pipeline.

    ![Set new variable name](./Media/set-variable-new-name.png)

1. In the Add new variable window, set the **Name** value to **fileDirectory** and ensure the **Type** remains as a string before selecting **Confirm**. Naming your variable helps in identifying its purpose and ensures that it is correctly referenced in subsequent steps.

    ![Create a new variable](./Media/new-variable-name.png)

1. With the set variable activity still active, select the **Value** text input box. This will display the **Add dynamic content [Alt+Shift+D]** property. Select this text to open the pipeline expression builder.

    In the Pipeline expression builder window copy and paste the code block below into the expression input box. Press **Ok** when complete.

    ```text
    @concat(
        formatDateTime(
            convertFromUtc(
                utcnow(), 'Central Standard Time'
            ),
            'yyyy/MM/dd'
        ),
        '/ContosoSales'
    )
    ```

    ![Create Contoso tables](./Media/new-variable-expression-folder.png)

1. First, navigate to the **General** tab with the **Set variable** activity selected. Update the **Name** field with the text "**Set file directory**" This step helps in identifying and managing the activity within your pipeline in subsequent steps, making it easier to understand its purpose and functionality.

    ![Set variable name](./Media/set-file-directory-name.png)

1. Next, drag and drop the **On completion** conditional path between the **Set file directory** activity and the **Get and unzip files** activity.

    ![Conditional path between variable and copy data](./Media/variable-on-completion.png)

1. Then, select the **Get and unzip files** activity and navigate to the **Destination** settings. Select the directory from the **File path** to open the expression builder. With the expression builder open, select **Clear contents** to clear the previous expression and navigate to the **Variables** tab. Select the **fileDirectory** variable and then click **OK**.

    ![Update to using variable](./Media/update-get-and-unzip-data.png)

1. Finally, with the **Get and unzip files** activity still selected, navigate to the **General** tab and select **Deactivated**. Since we've already run this activity earlier, we can avoid running it again but still provide activity states during our pipeline creation, such as Skipped, Succeeded, or Failed branches, which can be helpful for testing.

![Update to using variable](./Media/deactivated-copy-activity.png)

### Metadata contents

1. First, navigate to the **Activities** tab and select the **Get metadata** activity to add it to your canvas. Make sure it is your active selection.

    Next, within the **Settings** options, set the **Connection** to **IADLake** from the available connection options. 

    Choose the **Files** option and then click on the **Directory** file path text input box. This will display the Add dynamic content [Alt+Shift+D] property. Click on this text to open the pipeline expression builder.

    ![Add get metadata activity](./Media/add-get-metadata-activity.png)

1. In the Pipeline expression builder window, select the **Variables** option. Within the available variable list, select **fileDirectory** and then OK. This step ensures that the file path for the metadata retrieval is dynamically set based on the value of the fileDirectory variable.

    ![File directory variable](./Media/filedirectory-variable.png)

1. With the Get metadata activity still selected, navigate to the **Settings** tab. Add new Field list values by selecting **New** twice. Within each of the drop-downs, configure the values as **Child items**. This ensures that the metadata activity retrieves information about the child items and their names within the specified directory.

    ![Get metadata field list](./Media/get-metadata-field-list.png)

1. Next, navigate to the General tab with the Get metadata activity selected. Update the **Name** field with the text "**Get items in folder**". This step helps in identifying and managing the activity within your pipeline, making it easier to understand its purpose and functionality.

    ![Get child items in folder name](./Media/get-child-items-in-folder.png)

1. Create a conditional path by dragging and dropping the **On completion** option between the **Get and unzip files** activity and the **Get items in folder** activity. This step establishes a logical flow in your pipeline, ensuring that the metadata retrieval occurs only after the file directory has been set.

    **Note:** Our activity Get and unzip files is currently deactivated but its activity state is marked as **On success** during testing and building. Before releasing to production we will want to set the property back to **Activate**.

    ![Conditional path on success](./Media/conditional-path-on-success.png)

1. Once complete, select **Validate** on the **Home** tab to ensure there are no errors within the pipeline. After validation, select **Run** to start the pipeline.

    A new window will prompt you as unsaved changes have been detected. Select **Save and run** to continue.

    ![Validate and run](./Media/validate-and-run.png)

1. Deselect any previously selected activities within the authoring canvas and navigate to the **Output** view. This view allows you to monitor the current status of your pipeline both during and after its run. In this example, both the Pipeline status and the individual activitiy statuses should show a **Succeeded** status. This indicates that everything ran as intended, confirming that your data ingestion process was successful.

    From the **Get child items in folder** activity, select the last column called **Output** to review the contents of the activity. This step allows you to verify that the filenames from your directory have been correctly retrieved and included in the output.

    Of note, the output contains two keys one for **name** and another for **type** which we will access in the next portion of the tutorial.

    ![Output window](./Media/output-metadata-run.png)

## Dataflow Gen2

### Dataflow Gen2 and default destinations

---

1. In your workspace, select the **Store data** task to limit your selection to only items associated with this task. From the workspace list select the **IADLAke** lakehouse item, to open the lakehouse editor.

    ![Show all items](./Media/select-iadlake-item.png)

1. Once we're in the lakehouse editor, select **New Dataflow Gen2**.

    ![New Dataflow Gen2](./Media/NewDataflowGen2.png)

    > [!NOTE]
    > We can also select Get data from the ribbon and then New Dataflow Gen2.

1. In the top left corner, select the Dataflow name (this title may differ) and update the **Name** field to **OnlineSalesDataflow**.

    ![Dataflow name](./Media/DataflowName.png)

    > [!NOTE]
    > If you have Microsoft Information Protection in your organization, you can also set the Sensitivity label on this screen.

### Import a Power Query template

In this section of the lab, we will use an existing [Power Query template](https://learn.microsoft.com/power-query/power-query-template) file to skip the basic steps of connecting to data and focus on more advanced capabilities.

Once we import and refresh our Power Query template file, it will enable discovery across other Microsoft products and services such as Excel and Power Apps.

---

1. In the Power Query Online editor for Dataflows Gen2, select **Import from a Power Query template**. By leveraging an existing Power Query template, we can easily import and export our Power Query queries and their associated metadata.

    ![Impower Power Query template file](./Media/ImportPQT.png)

1. Paste the following file path in the **File name** field and select **Open** to continue.

    ```text
    https://github.com/microsoft/pbiworkshops/raw/main/Day%20After%20Dashboard%20in%20a%20Day/Source_Files/OnlineSalesDataflow.pqt
    ```

    ![Open PQT](./Media/OpenPQT.png)

1. Once the template has been loaded select the Url parameter and paste the above copied lakehouse id into the field and select **Apply**.

    ![Lakehour URL](./Media/lakehouse-url-parameter.png)

1. Select the pUTCOffset parameter and enter the number of hours offset from UTC time that corresponds to your data pipelines time sone before selecting **Apply**.

    ![Lakehour URL](./Media/putcoffset-number.png)

1. Select the **DimCustomer** query and if prompted, click the **Configure connection** button from the yellow banner.

    ![Configure credentials](./Media/ConfigureConnection.png)

### Dataflow Gen2 scalability

There are several components in the Dataflow Gen2 architecture. The Lakehouse item is used to stage data being ingested, while the Warehouse item serves as a compute engine and enables faster writing back of results to staging or supported output destinations. In cases where warehouse compute is unavailable or staging is disabled for a query, the mashup engine will extract, transform, or load the data to staging or a destination.

Learn more about the [Dataflow Gen2 engine](https://blog.fabric.microsoft.com/blog/data-factory-spotlight-dataflows-gen2/#:~:text=The%20Dataflow%20Gen2%20Engine)

---

1. In the **Queries** pane, right-click each of the queries listed below and select the **Enable staging** option.

    | Table |
    | :---- |
    | DimCustomer |
    | DimGeography |
    | DimProduct |
    | DimProductCategory |
    | DimProductSubcategory |

    ![Enable staging](./Media/enable-staging-queries.png)

---
# Power Query Online

## Global options

Now that we have imported our dataflow and set our credentials, we’ll adjust some settings for authoring in Power Query Online. These settings will stay the same when we author new content in the future.

---

1. From the **Home** tab, select the **Options** > **Global options** property.

    ![Global options](./Media/GlobalOptions.png)

1. Within the **Global options** windows **General** section ensure the following settings are enabled.

    **Steps**
    - Enable step cost indicators
    - Show script in step callout

    **Column profile**
    - Enable column profile
    - Show column value distribution in data preview
    - Show column value distribution in data preview
    - Show column profile in details pane

    **Column profile evaluation**
    - Based on top 1,000 rows

    **Data view**
    - Enable details pane
    - Show whitespace and newline characters

    **Parameters**
    - Always allow parameterization in data source and transformation dialogs

    ![Global options window](./Media/GlobalOptionsWindow.png)

1. Now select the **Data load** group and from the **Type detection** select **Never detect column types and headers for unstructured sources**. Select **OK** once complete.

    ![Global options data load](./Media/GlobalOptionsDataLoad.png)

1. (Optional) Select the **Scale** option, enable the setting **Allow use of fast copy connectors** and then **OK**.

![Global options data load](./Media/enable-fast-copy.png)

---

## Data view

The Power Query Online editor is a user interface that allows us to create and edit queries, organize queries by grouping them or adding descriptions to each step, and view our queries and their structure in different ways.

Learn more about the [Power Query editor](https://docs.microsoft.com/power-query/power-query-ui#the-power-query-editor-user-experience)

---

1. To view all of our queries with the text "Dim" in their name, we’ll type **Dim** in the **global search bar** at the center of the Power Query Online editor. Then we’ll select the **DimCustomer** query to proceed.
    1. Shortcut: **Alt+Q**
    1. We can use the up/down arrow keys to browse the results and press **Enter** to confirm our choices.

    ![Global search Dim tables](./Media/GlobalSearchDim.png)

1. From the **Queries** pane, we'll right click the **DimCustomer** query and select **Reference** from the menu.

    ![Reference query](./Media/DimCustomerReference.png)

1. If we inspect the **Queries** pane again we'll now notice that a new query titled **DimCustomer (2)** has now been created, with a lightning bolt icon (⚡) indicating that this is a computed table.

    This query will leverage the Dataflow Gen2 compute engine which can drastically reduces refresh time required for long-running data preparation steps - such as performing joins between tables.

    ![Computed table](./Media/ComputedTable.png)

1. With the **DimCustomer (2)** query selected, we'll leverage the global search bar to type the text **merge** and select the **Merge queries** action.

    ![Computed table](./Media/MergeQueriesDimCustomer.png)

1. In the **Merge** window complete the following instructions below and then select **OK** when complete.

    | Merge | Table |
    | :--- | :---- |
    | Left table for merge | DimCustomer_raw (2) |
    | Right table for merge | DimGeography_raw |

    1. In the top right a light bulb indicator suggests that a match exists based on the shared columns from each table. Select light bulb and choose the option for the **GeographyKey** match.
    1. Set the **Join kind** to **Inner**

    ![Computed table](./Media/DimCustomerDimGeography.png)

1. Within the data view, navigate to the **DimGeography_raw** column and select the **Expand** icon. Deselect the **GeographyKey** since we this column already exists in our original query and then select **OK**.

    ![Remove GeographyKey](./Media/RemoveGeographyKey.png)

1. Within the **Query settings** pane, update the name of our query from **DimCustomer_raw (2)** to the name **DimCustomer**.

    ![Query settings DimCustomer](./Media/QuerySettingsDimCustomer.png)


Now that our data is being ingested and stored in our Lakehouse, we'll leverage [computed tables](https://docs.microsoft.com/power-query/dataflows/computed-entities-scenarios) to apply transformation logic via Fabric compute engines.

Learn more about the [Global search box](https://learn.microsoft.com/power-query/search-box)

Learn more about the [benefits of loading data without transformation for Text/CSV files](https://docs.microsoft.com/power-query/dataflows/computed-entities-scenarios#load-data-without-transformation-for-textcsv-files)

---

## Diagram view

Diagram view in Power Query Online offers a visual way to prepare data in the Power Query editor. It simplifies the experience of getting started with data wrangling, speeds up the data preparation process, and helps you quickly understand the dataflow. With the diagram view, we can easily create queries and visualize the data preparation process. It provides both the "big picture view" of how queries are related and the "detailed view" of the specific data preparation steps in a query.

---

1. In the bottom right of the **Power Query** editor, click the **Diagram view** option.

    ![Diagram view](./Media/DiagramView.png)

1. To merge queries as a new query, follow these steps:
    - In the top right of the **DimProduct_raw** table, click the Actions option **( ⋮ )**
    - From the dropdown menu, choose the **Merge queries as new** option.

    ![Merge queries as new](./Media/MergeNew.png)

1. In the Merge window, follow these steps and then click **OK** to confirm.

    | Merge | Table |
    | :--- | :---- |
    | Left table for merge | DimProduct_raw |
    | Right table for merge | DimProductSubcategory_raw |

    - In the top right, select the light bulb indicator, which suggests that a match exists based on the shared columns from each table.
    - Choose the option for the **ProductSubcategoryKey** match.
    - Set the **Join kind** to **Inner**

    ![Merge DimProductSubcategory](./Media/MergeDimProductSubcategory.png)

1. On the **Home** tab, click the drop-down arrow next to **Choose columns** and choose the **Go to column** option (Shortcut: Ctrl+G).

    - In the search dialog, type the column name **DimProductSubcategory_raw** until it shows up.
    - Either double-click the name or select the column name and click OK to go to the column.

    ![Go to column](./Media/GoToColumn.png)

1. In the top right of the **DimProductSubcategory_raw** column, click the expand columns icon and follow these steps:
    - Uncheck the **ProductSubcategoryKey** column since we already have this column in our original DimProduct_raw table.
    - Check only the **ProductSubcategoryName** and **ProductCategoryKey** columns.
    - Uncheck the **Use original column name** as prefix option (if checked).
    - Click **OK** to confirm.

    ![Expand product subcategory](./Media/ExpandProductSubcategory.png)

1. After the **Expanded DimProduct** step, click the **"+"** icon to insert a new step and follow these steps:
    - In the transformations list search, type **Merge**.
    - Click the **Merge queries** option from the list.

    ![Merge queries](./Media/MergeQueries.png)

1. In the **Merge** window, follow these steps and then click **OK** to confirm.

    | Merge | Table |
    | :--- | :---- | 
    | Left table for merge | (Current) |
    | Right table for merge | DimProductCategory_raw |

    - In the top right, select the light bulb indicator, which suggests that a match exists based on the shared columns from each table.
    - Choose the option for the **ProductSubcategoryKey** match.
    - Set the **Join kind** to **Inner**

    ![Merge ProductCategory_raw](./Media/MergeProductCategory.png)

1. In the top right of the **DimProductCategory_raw** column, click the expand columns icon and follow these steps:
    - Deselect all columns except **ProductCategoryName**.
    - Disable the **Use original column name as prefix** option (if enabled).
    - Click **OK** to confirm.

    ![Expand product category](./Media/ExpandProductCategory.png)

1. In the top left of our merged queries, double click the **Merge** query text and update the table name to **DimProduct**.

    ![DimProduct rename](./Media/DimProductRename.png)

---

<font size="6">✅ Lab check</font>

In summary, diagram view in Power Query Online is a powerful tool that offers a visual way to prepare data in the Power Query editor and helps us easily view the flow of data, both at the query level and at the step level to better determine how our queries are connected and what data preparation steps we have applied to each query.

Learn more about [diagram view](https://docs.microsoft.com/power-query/diagram-view).

---

## Schema view

Schema view helps us work on schema level operations by showing only our query’s column information in the editor.

---

To use the schema view and mark some columns as keys, we’ll do the following:

1. In the bottom right of the Power Query editor, click the **Show schema view** option.

    ![Schema view](./Media/SchemaView.png)

1. Click the **DimProduct** query and follow these steps:

    1. In the schema list, click the following column names listed below and either select the ellipses **(...)** or right click the **Remove columns** option for any any step selected.

    **Important note:** We can maximize or minimize the view by clicking the chevrons next to the formula bar.

    | Column |
    | :--- |
    | ClassID |
    | StyleID |
    | ColorID |
    | WeightUnitMeasurementID |
    | UnitOfMeasureID |
    | StockTypeID |
    | ProductCategoryKey |

    ![Remove columns](./Media/RemoveSchemaView.png)

1. Now that we're finished adjusting our queries schema navigate to **Schema tools** tab and select **Close schema view** to return to the data view.

    ![Close schema view](./Media/CloseSchemaView.png)

---

<font size="6">✅ Lab check</font>

Schema view lets us shape our data structure with contextual interactions, and speed up our operations as it only needs the column metadata and not the full data results.

Learn more about [Schema view](https://docs.microsoft.com/power-query/schema-view)

---

## Applied step icons

Identifiers are names given to elements in a program like variables, functions etc. Identifiers can either be regular identifiers or quoted identifiers.

Learn more about [Environments and variables](https://docs.microsoft.com/powerquery-m/m-spec-basic-concepts#environments-and-variables)

---

1. In the Query settingspane Applied steps, right click the **Removed columns** step and click **Properties**.

    ![Step properties documentation](./Media/StepProperties.png)

1. In the **Step properties** window, enter the following text below into the **Description** field and select **OK** once complete.
    - **Important note:** A **(ℹ️)** icon will be displayed next to the step indicating a description has been added.

    ```text
    Removed ProductCategoryKey and all ID columns.
    ```

    ![Step properties](./Media/StepDescription.png)

1. Hover above the **Removed columns** step to view details like the step name, transformation type, description, step folding indicator and formula script.

    ![Step properties](./Media/StepHover.png)

---

## Query plan

The query plan in Power Query Online provides a view of how your query is evaluated. It can help you understand what is happening under the hood of your query and why a particular query might not fold at a particular step as well as the performance and cost of each step.

Learn more about [query plan](https://docs.microsoft.com/power-query/query-plan)

---

To view the query plan for the Removed columns step, we’ll do the following:

1. In the **Query settings** pane on the right, we’ll right click the **Removed columns** step and click the **View query plan** option.

    ![View query plan](./Media/ViewQueryPlan.png)

1. In the **Query plan** window, we can click any of the **Table.Join** and the **View details** to understand what join algorithm is being used. We’ll click **Close** when we are done.

    ![Join algorithm](./Media/JoinAlgorithm.png)

---

## Advanced Editor

The advanced editor in Power Query is a tool that lets you see and edit the code that Power Query Editor is creating with each step. The code is written in M language, which is a powerful and flexible language that allows you to create custom transformations that are not easily achievable through the Power Query user interface.

---

1. Select the **fxGetFact** query in the **Queries** pane.

    ![fxGetFact query](./Media/fxGetFact.png)

1. Before invoking our custom function, we can enable the **Query script** view to see the full M script by selecting **Query** and then **Query script** from the ribbon in the bottom right corner. Once done, select the **Step script** to return to the normal formula view.

    > [!NOTE]
    > To adjust the code block you can drag up or down on the bottom of the editor.

    ![Query script](./Media/QueryScript.png)

1. Select **Invoke** to create a new query.

    ![Invoke function](./Media/InvokeFunction.png)

1. In the **Query settings** pane, right click the **Invoked function** query and select **Rename**.

    ![Query name](./Media/QueryName.png)

1. Update the name of the query to **FactOnlineSales**.

    ![FactOnlineSales](./Media/FactOnlineSales.png)

---

## Query groups

When we have many tables in our solutions, it can be hard to keep track of their use. To make it easier, we can organize our queries into groups based on their design patterns.

1. In the **Queries** pane, hold **ctrl** and select the tables from the list below that you want to group together. Then, right click and choose **Move to group** > **New group…**.

    1. DimCustomer_raw
    1. DimGeography_raw
    1. DimProduct_raw
    1. DimProductCategory_raw
    1. DimProductSubcategory_raw

    ![Query name](./Media/StagingGroup.png)

    1. In the **New group** window, type **Data staging** as the Name and the text below as the Description. Then, click **Ok**.

        ```text
        Data that will be ingested from the source and referenced in computed tables for transformations via compute engines.
        ```

        ![New group](./Media/NewGroup.png)

1. In the **Queries** pane, hold **ctrl** and select the tables from the list below that you want to group together. Then, right click and choose **Move to group** > **New group…**.

    1. DimDate
    1. DimEmployee
    1. DimStore

    ![Query name](./Media/NewGroupDataLoad.png)

    1. In the **New group** window, type **Data load** as the Name and the text below as the Description. Then, click **Ok**.

        ```text
        Data that will be ingested from the source without transformations.
        ```

        ![New group](./Media/NewGroupDataLoadDescription.png)

1. In the **Queries** pane, hold **ctrl** and select the tables from the list below that you want to group together. Then, right click and choose **Move to group** > **New group…**.

    1. DimCustomer
    1. DimProduct
    1. FactOnlineSales

    ![Query name](./Media/NewGroupDataTransformation.png)

    1. In the **New group** window, enter **Data transformation** as the name and the following text as the Description. Then, click **Ok**.

        ```text
        Data that will be ingested from the lake storage for transformations via compute engines.
        ```

     ![New group](./Media/GroupDescriptionTransformation.png)

1. We have created three groups in our **Queries** pane to help us manage and identify our queries more easily. To see more information about each group, we can hover over the group’s folder icon and read the description value.
    1. You can also hover over a query to see its description value, if it has one and to add a description for a query, right click on the query name in the Queries pane and select **Properties**.

    ![Group description](./Media/GroupDescription.png)

---

Transforming data at scale

[Learn more about the benefits of loading data without transformation for Text/CSV files](https://docs.microsoft.com/power-query/dataflows/computed-entities-scenarios#load-data-without-transformation-for-textcsv-files)

---

## Edit data destinations

The data destination logic in Dataflows Gen2 is configured as an additional step at the end of a chosen query. When you select the query, you’ll find the **Output destination** option available in the ribbon, diagram view, or applied steps section. Currently, users have two choices for handling their destination outputs:

- **Replace**: Users can replace existing data in the destination.
- **Append**: Users can append new data to the existing destination.

---

1. With any query in our dataflow selected, in the bottom right corner there is a **Data destination** field well including an information icon indicator. This configuration is set because in our earlier lab instructions we entered the Dataflow Gen2 authoring experience from our Lakehouse. This setting is applied to all queries in the editor and can also be removed by selecting the **X** or configured by selecting the settings icon.

    ![Default append](./Media/default-replace.png)

    > [!IMPORTANT]
    > The default setting is **Replace** and **Auto mapping** for column shcema changes.
    >
    > Default destinations configurations are also available when using the Lakehouse, Warehouse or Kusto DB as the Get data entry point when authoring a dataflow.

1. Select the **FactOnlineSales** query, and in the bottom right corner of the editor, locate the **Data destination** field well, and click the **Settings** icon.

    For the dimension tables, which are small and undergo infrequent changes, we will leave the default **Replace** method to delete rows and insert their values during each run. However, for our larger fact tables, we want to **Append** our new sales data during subsequent runs.

    ![Edit destination settings](./Media/destination-setting.png)

1. If prompted, authenticate into your Lakehouse and within the **Choose destination target** window, ensure **New table** is selected, along with the **SalesLakehouse** in the lab workspace and click **Next**.

    ![Existing table target settings](./Media/new-table-target.png)

1. In the **Choose destination settings** window, deselect the **Use automatic settings** option. With the newly visible options change the update method to **Append** and then click **Save settings**.

    > [!IMPORTANT]
    > The update method **Replace** includes **Schema options** on publish, **Dynamic schema** ensures that any time you add or remove columns in your dataflow the subsequent created table automatically inherits these changes. For **Fixed schema** you will need to manually configure the changes via the destination configuration window.

    ![Append method](./Media/append-method.png)

1. With the **FactOnlineSales** query still selected, and in the bottom right corner of the editor, locate the **Data destination** field well to easily review the updated configurations. You'll also notice the default destination indicator has been removed as this was manually configured and allows for **Dynamic schema** changes.

    ![Append method](./Media/append-factonlinesales.png)

Lean more about [data destination settings and configurations](https://learn.microsoft.com/fabric/data-factory/dataflow-gen2-data-destinations-and-managed-settings)

---

## Saving and refreshing a dataflow

1. In the bottom right corner click **Publish** to save and refresh the final dataflow.
    - Reminder: **Publish later** will only publish the metadata and underlying formula logic of your dataflow. **Publish** will save and close your dataflow and start the refresh.

    ![Publish](./Media/PublishLater.png)

---

## Orchestrate a data pipeline

Using pipelines, we will orchestrate the refresh of our dataflow. If an error occurs, we will send a customized Outlook email that includes important details.

---

1. With our workspace, select **New** and then **Show all**.

    ![Show all items](./Media/ShowAllItems.png)

1. In the **New** item creation screen, select **Data pipeline** under the Data Factory category.

    ![New data pipeline](./Media/NewDataPipeline.png)

1. Set the pipeline name to **SalesPipeline**. Then select **Create**.

    ![New pipeline name](./Media/new-pipeline-name.png)

1. Once we’re in the pipeline editor, select **Add pipeline activity**, and then select **Dataflow**.

    > [!NOTE]
    > You can also select *Dataflow* from the Home tab.

    ![Add dataflow activity](./Media/add-dataflow-activity.png)

1. Select the dataflow activity within the pipeline editor and change its **Name** value to **OnlineSalesActivity** within the General section.

    ![Dataflow activity name](./Media/dataflow-activity-name.png)

1. With the dataflow activity still selected, select **Settings** and choose **OnlineSalesDataflow** from the Dataflow list. If necessary to update the list, select the **Refresh** icon.

    ![Dataflow activity settings](./Media/dataflow-activity-dataflow.png)

1. Select the **Activities** tab and then the **Office365 Outlook** activity. 

    ![O365 Activity](./Media/office-365-activity.png)

1. Select the **Office365 Outlook** activity within the pipeline editor and change its **Name** value to **Mail on failure** within the General section.

    ![Mail on failure](./Media/office-365-activity-name.png)

1. With the Office365 Outlook activity still selected, select **Settings** and update the following fieds:
    - **To** field to your e-mail address
    - **Subject** to **Pipeline failure**
    - Select **Body** and the option **Add dynamic content [Alt+Shift+D]** will be presented.

    ![Mail settings](./Media/office-365-activity-settings.png)

    > [!NOTE]
    > If a Sign in to Office 365 Outlook account window appears, select Sign in and use your organizational account and then select Allow access.    
    > More e-mail configuration options such as From (Send as), Cc, Bcc, Sensitivity label and more are available with Advanced properties.

1. In the **Pipeline expression builder**, paste the following expression code block:

    ```text
    @concat(
        'Pipeline: '
        , 
        , '<br>'
        , 'Workspace: '
        , 
        , '<br>'
        , 'Time: '
        , 
    )
    ```

    ![Expression builder](./Media/expression-builder.png)

1. Select **System variables** and insert the following variables by selecting the corresponding name from the following table.

    | Value name | Line | System variable |
    | :- | :- | :- |
    | Pipeline: | 3 | Pipeline ID |
    | Workspace: | 6 | Workspace ID |

    ![System variables](./Media/system-variables.png)

1. Select **Functions** and insert the following function by selecting the corresponding name from the following table. Once complete select **OK**.

    | Value name | Line | System variable |
    | :- | :- | :- |
    | Time: | 9 | utcnow |

    ![System functions](./Media/functions.png)

1. Select **OnlineSalesActivity** and from the available path options, select and hold the **"X" (On fail)** to create an arrow that will be dropped on the **Mail on failure** activity. This activity will now be invoked if the **OnlineSalesActivity** fails.

    ![On failure](./Media/on-failure.png)

1. From the **Home** tab, select **Schedule**. Once you have updated the following configurations, select **Apply** to save your changes.

     | Name | Value |
     | :- | :- |
     | Scheduled run | On |
     | Repeat | Daily |
     | Time | 12:00:00 AM |

    ![Schedule](./Media/schedule.png)

1. From the **Home** tab, select the **Save** option and we'll then select our workspace from the siderail to proceed with the data modeling portion of the lab.

    ![Schedule](./Media/save-pipeline.png)

    > [!NOTE]
    > As we're developing our pipeline we can also select **Run** to manually trigger our pipeline. We can then monitor the pipeline’s current status from the **Output** table, which displays the current activity progress. The table will periodically refresh on its own, or we can manually select the refresh icon to update it.

    ![Output window](./Media/output.png)

# Next steps

This part of the lab has demonstrated how dataflows can help you prepare data in the cloud and use it in Power BI easily.

- Continue to the [Data Modeling](./DataModeling.md) lab
- Return to the [Day After Dashboard in a Day](./README.md) homepage

---

# Completed files

To download the completed files from the lab instructions:
```text
https://github.com/microsoft/pbiworkshops/raw/main/Day%20After%20Dashboard%20in%20a%20Day/Source_Files/DayAfterDataflow.pqt
```


1. In the bottom right corner click the chevron next to **Publish** to view all options, before selecting the **Publish** option.

    > [!IMPORTANT]
    > The **Publish** (also known as **Publish now**) option is the default behavior that will publish and refresh your dataflow. Alternatively, the **Publish later** to only publish the metadata and underlying formula logic of your dataflow.

    ![Publish later](./Media/PublishLater.png)

## View lakehouse tables

1. In the Workspace, select the ellipsis **(…)** next to the Lakehouse item named **IADLake**, and then choose the **View details** option.

    ![View Lakehouse details](./Media/ViewDetailsLakehouse.png)

1. On the Lakehouse details page, you can find the SQL connection string. This connection string allows you to use external tools like [Azure Data Studio](https://azure.microsoft.com/products/data-studio/)  or [SQL Server Management Studio](https://learn.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16) to explore lakehouses and query the data. You can also find additional information about downstream items and their relation to the lakehouse for lineage. Let’s select **Open** to continue.

    ![Open lakehouse](./Media/OpenLakehouse.png)

1. To view the created tables in the object explorer, select any of the tables from the list (e.g., choose DimDate). These tables are created using the Delta Lake format, which is a parquet file format optimized for analytics. They have been further optimized using [V-Order](https://learn.microsoft.com/fabric/data-engineering/delta-optimization-and-v-order?tabs=sparksql) to enable lightning-fast reads under Microsoft Fabric compute engines (such as Power BI, SQL, Spark, and others).

    > [!IMPORTANT]
    > If you do not see your tables or they are undefined, select the **Refresh** option in the top left of the Lakehouse explorer.

    When you right-click either the Tables or the Files section folder, you’ll find additional options like:

    - **New shortcut**: This option allows you to create a shortcut that can access tables or files in another location within your organization, helping avoid data duplication.
    - **Properties**: In this section, you’ll find details such as the Azure Blob File Storage (ABFSS) path. You can use this path to connect external tools like Azure Storage Explorer or for writing files from external systems.

    ![Lakehouse properties](./Media/LakehouseProperties.png)

    When you right-click the tables directlty, you'll find common operations such as Delete and Rename, and additional options like:
    - **Maintenance**: the table maintenance feature efficiently manages delta tables and keeps them always ready for analytics with three operations (Optimize, V-Order, Vaccum).

        Learn more about [table maintenance](https://learn.microsoft.com/fabric/data-engineering/lakehouse-table-maintenance)

    ![Lakehouse maintenance](./Media/LakehouseMaintenance.png)

1. Once we’re done, we can return to the Workspace view by selecting our workspace from the side-rail on the left.

    ![Lakehouse view](./Media/LakehouseView.png)

1. In the Workspace, select the eppises **(...)** next to the **Dataflow Gen2** item named **OnlineSalesDataflow**, and choose the **Edit** option.