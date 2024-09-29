# Data Preparation (continued)

## Task flow customization

1. First, return to the workspace by selecting its name on the left side rail. With the task view visible, select the **Add** option and then choose **Prepare data**. Hover above the bottom of the **Collect data** task until a rectangle connector box becomes visible, then drag and drop to connect the **Collect data** task to the **Prepare** task.

    ![Create a task connection](./Media/prepare-data-task.png)

1. Next, select the connection between **Store data** and **Create visualization** and press **Delete** on your keyboard to remove it.

    ![Delete task connection](./Media/delete-store-data-task-link.png)

1. Then, select **Add** for a new task and choose **Store data**. Once on the canvas, create a new connection that attaches both **Prepare** and **Store data** to the new **Store** task.

    ![Delete task connection](./Media/task-links-new-store-data.png)

1. Select the **Store** task and then, on the right hand side, select the **Edit** option to customize the name field.

    ![Edit task](./Media/task-flow-edit.png)

1. In the task edit menu, update the **Task name** field to **Curated data** and then select **Save** to continue.

    ![Edit task flow name](./Media/task-flow-edit-name.png)

1. Create a new connection between the **Curate data** task and the **Create visualizations** task.

    ![New connection curate to visualize](./Media/task-flow-new-connection-curate-visualize.png)

1. Select the **New item** option on the **Curated data** task and from the recommended items list, select **Lakehouse**.

    ![New lakehouse item](./Media/task-flow-new-item-lakehouse.png)

1. For the new lakehouse item name, type in **c_IADLake** (c is shorthand for curated) and then press **Create**.

    ![Create lakehouse item](./Media/new-lakehouse-ciad.png)

### Default destination entry point

1. Within the lakehouse item from the **Home** tab select **Get data** from **New Dataflow Gen2**.

    ![New dataflow gen2 from lakehouse](./Media/new-dataflow-gen2-from-lakehouse.png)

1. Select the current dataflow name in the top left corner and update the **Name** field to **PrepContoso**.

    ![Name the dataflow](./Media/name-dataflow.png)

    **Important:** When using the lakehouse item to create a new Dataflow Gen2, any queries you create or connect to will automatically be configured to use the lakehouse as the default destination for new tables. If you prefer to write to a different location or modify certain configurations, such as the update method, these settings can be manually overwritten.

## Dataflow Gen2

### Connecting to lakehouse tables

1. From the **Home** tab, select **Get data** and then the **More...** option. This step allows you to access a wider range of data sources and connectors, providing flexibility in integrating different data streams into your project.

    ![Get data from more](./Media/get-data-more.png)

1. Within the Get data explorer's search bar, type **iad** to locate the lakehouse items that include those letters. Select the **IADLake** item within the OneLake data hub's returned results.

    You can also navigate to the OneLake data hub tab to view all items that you have access to in your tenant. This step ensures that you are connecting to the correct data source, which is essential for accurate data retrieval and analysis.

    ![Search for silver lakehouse](./Media/dataflow-choose-data-source.png)

1. From the Get data table navigator, select the tables listed below to perform data transformation operations and merge the tables for our downstream business intelligence projects.

    | Table Name |
    | :--- |
    | DimCustomer |
    | DimGeography |
    | DimProduct |
    | DimProductCategory |
    | DimProductSubcategory |

    ![Get data select tables](./Media/choose-data-dims.png)

### Preparing data and writing to Lakehouse data destination

1. Select the **DimCustomer** table and from the Home tab, navigate to the **Merge queries** option and select **Merge queries**.

    Note that there are two options: Merge queries, which will merge a table with the existing query, or Merge queries as new, which will create a new query in your editor. This step allows you to combine data from different tables, enhancing the comprehensiveness of your dataset.

    ![Merge dim customer](./Media/merge-dimcustomer.png)

1. From the Merge query window, set the **Right table for merge** to **DimGeography**. In the top right corner, select the lightbulb which has detected a possible column match. In this example, both tables contain a column titled **GeographyKey**. Select this option to set the columns to be merged on. For the join kind, select **Inner** and then **OK** to proceed. This activity ensures that the data is accurately combined based on matching columns.

    ![Merge dim customer window](./Media/merge-dimcustomer-window.png)

1. Navigate to the far right of the **DimCustomer** table and select the joined **DimGeography** table column's top right corner to expand the table. From the available column selections, deselect **GeographyKey** since this column is what we used to merge on and already exists in the dataset. Select **OK** to continue.

1. Navigate to the far right fo the **DimCustomer** table and select the joined **DimGeography** table column's top right corner to expand the table, from the avaialble column selections deselect **GeographyKey** since this column is what we used to merge on and already exists in the dataset before selecting **OK** to continue.

    ![Expand DimGeography](./Media/merge-dimcustomer-expand.png)

1. On the right-hand side, you can review the Applied steps list, which indicates that our queries are successfully folding back to the lakehouse's SQL endpoint. The options View data source query and View query plan also exist to review the SQL generated or the execution plan for the query. This step allows you to verify that the data transformations are being applied correctly and efficiently, ensuring the integrity and performance of your data pipeline.

    ![Confirm query folding for DimCustomer](./Media/merge-dimcustomer-queryfold.png)

1. Select the **DimGeography** table and in the bottom right corner for the **Data destination** setting, select the **X** to remove this item from being written to the gold lakehouse. Since we have already prepared our tables by merging data, we only want to surface the clean tables to our end users.

    ![Remove dimgeography](./Media/merge-dimcustomer-removedestination.png)

1. Next, select the **DimProduct** table and from the **Home** tab, navigate to the **Merge queries** group and select **Merge queries**.

1. Select the **DimProduct** table and from the **Home** tab navigate to the **Merge queries** group and select **Merge queries**.

    ![Merge dimproduct](./Media/merge-dimproduct.png)

1. From the Merge query window, set the **Right table for merge** to **DimProductSubcategory**. In the top right corner, select the lightbulb which has detected a possible column match. In this example, both tables contain a column titled **ProductSubcategoryKey**. Select this option to set the columns to be merged on. For the join kind, select **Inner** and then **OK** to proceed.

    ![Merge dimproductsubcategory](./Media/merge-dimproduct-dimproductsubcategory.png)

1. Navigate to the far right fo the **DimProduct** table and select the joined **DimProductSubcategory** table column's top right corner to expand the table, from the avaialble column selections deselect **ProductSubCategoryKey** since this column is what we used to merge on and already exists in the dataset before selecting **OK** to continue.

    ![Expand dimproductsubcategory](./Media/merge-dimproduct-expand-dimproductsubcategory.png)

1. Select the **DimProduct** table again and from the **Home** tab, navigate to the **Merge queries** group and select **Merge queries**.

    ![Merge another table to DimCustomer](./Media/merge-dimproduct.png)

1. From the Merge query window, set the **Right table for merge** to **DimProductCategory**. In the top right corner, select the lightbulb which has detected a possible column match. In this example, both tables contain a column titled **ProductCategoryKey**. Select this option to set the columns to be merged on. For the join kind, select **Inner** and then **OK** to proceed.

    ![Merge dimproductcategory](./Media/merge-dimproduct-dimproductcategory.png)

1. Navigate to the far right fo the **DimProduct** table and select the joined **DimProductCategory** table column's top right corner to expand the table, from the avaialble column selections deselect **ProductCategoryKey** since this column is what we used to merge on and already exists in the dataset before selecting **OK** to continue.

    ![Expand dimproductcategory](./Media/merge-dimproduct-expand-dimproductcategory.png)

1. On the right-hand side, you can review the Applied steps list, which indicates that our queries are successfully folding back to the lakehouse's SQL endpoint.

    ![DimProdcut query folding](./Media/merge-dimproduct-queryfold.png)

1. Select the **DimProductCategory** table and in the bottom right corner for the **Data destination** setting, select the **X** to remove this item from being written to the gold lakehouse.

    ![Remove dimproductcategory destination](./Media/dimproductcategory-remove.png)

1. Select the **DimProductSubcategory** table and in the bottom right corner for the **Data destination** setting, select the **X** to remove this item from being written to the gold lakehouse.

    ![Remove dimproductsubcategory destination](./Media/dimproductsubcategory-remove.png)

1. Select both the **DimCustomer** and **DimProduct** queries by holding the control key. Right-click and choose **Move group**, then select **New group**.

    ![Create new data load group](./Media/new-group-data-load.png)

1. In the New group window, set the properties as needed below and select **OK**. This step helps in organizing your queries into logical groups, making it easier to manage and navigate your data.

    | Name | Description |
    | :-- | :-- |
    | Data load | Data loaded to the gold lakehouse |

    ![New group data load description](./Media/data-load-group.png)

1. Select the **DimGeography**, **DimProductCategory** and **DimProductSubcategory** queries by holding the shift key, as they are all adjacent to each other. Right-click and select **Move group**, then select **New group**.

    ![Data reference group](./Media/new-group-data-reference.png)

1. In the New group window, set the properties as needed below and select **OK**.

    | Name | Description |
    | :-- | :-- |
    | Data reference | Data used only as a source from the silver lakehouse |

    ![New data reference group](./Media/data-reference-group.png)

1. In the bottom right corner, click **Publish** to save and refresh the final dataflow.

    **Note:** Selecting Publish later will only save the metadata and underlying formula logic of your dataflow. Choosing Publish will save, close your dataflow, and initiate the refresh process.

    ![Publish dataflow](./Media/publish-dataflow.png)

# Next steps

This part of the lab has demonstrated how data pipelines can help ingest data at scale easily into your lakehouse and how processing raw files into highly optimized tables

- Continue to the [Data Modeling](./DataModeling.md) lab
- Return to the [Day After Dashboard in a Day](./README.md) homepage