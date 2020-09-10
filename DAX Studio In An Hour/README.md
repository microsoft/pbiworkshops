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
- [DAX Queries](#dax-queries)
- [DAX Formulas](#dax-formulas)
    
___

# Setup

## Instructions
### [Optional: Guided Video](https://www.youtube.com/watch?v=pFX20PPxXjs&list=PLKW7XPyNDgRCOiC69kZWfRQdOxcnQy2yA&index=2)

### Power BI Desktop
1. Ensure the Power BI preview feature [Store datasets using enhanced metadata format](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-enhanced-dataset-metadata) is enabled.

**Important Note:** Always create a backup of your PBIX file prior to editing to avoid any issues in the event of a corrupted model.

# Data Analysis Expressions (DAX)
**Source:** Microsoft Docs

Data Analysis Expressions (DAX) is the native formula and query language for Tabular models in Analysis Services (SSAS/AAS), Power BI, and Power Pivot in Excel. DAX includes some of the functions that are used in Excel formulas with additional functions that are designed to work with relational data and perform dynamic aggregation.

[Learn More About DAX](https://docs.microsoft.com/en-us/dax/dax-overview) 

___

# DAX Queries



### Objective: Return tables, single column tables (list) and scalar values leveraging DAX as a query language.

## Instructions
### [Optional: Guided Video]()
1. Navigate to the repository, https://github.com/TabularEditor/BestPracticeRules
2. Navigate to the [BPARules-standard.json](https://github.com/TabularEditor/BestPracticeRules/blob/master/BPARules-standard.json) file and press the Raw button.
    1. Copy the web address in your browser (must match the below with the prefix raw) - 
    
    ``https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-standard.json``
    
3. Within Tabular Editor:
    1. Navigate to **Tools** and select **Manage BPA Rules...**
    2. Within the Manage Best Practice Rules dialog:
        1. Press **Add..**
        2. Select **Include Rule File from URL** and press **OK**
        3. Paste the above BPARules-standard.json web address and press **OK**
4. Within Tabular Editor:
    1. Navigate to **Tools** and select **Best Practice Analyzer...** or press the hotkey (**F10**)
    2. Review the current list of objects needing attention based on the rules.
    3. Select the header **Hide foreign key columns (11 objects)**
    4. Press the **Generate fix script** icon to copy to the clipboard.
    ![Generate Fix](./Images/generate_fix_script.png)
    5. In the **Fix script generation** dialog box prompt press **OK**.
5. Within Tabular Editor:
    1. Select the **Advanced Scripting** tab and paste the generated script (**Ctrl+V**) or from the navigation menu (**Edit > Paste**)
    2. Press the **Run script (selection only) F5** button. ▶
    3. Press the **Saves the changes to the connected database (Ctrl+S) button.**
    ![Advanced Scripting and Save](./Images/advanced_scripting_and_save.png)
6. Within Power BI Desktop:
    1. Review the **Orders** table to confirm that all the applicable columns (CustomerID, SalesPersonID, Order Date and Expected Delivery Date) are now hidden.
    2. Right click any field and select **Unhide All**
7. Within Tabular Editor:
    1. In the **External change detected** dialog box press **Yes**
    1. Confirm that the fields hidden are now visible.
    2. Navigate to **Tools** and select **Best Practice Analyzer...** or press the hotkey (**F10**)
    3. Select the header **Hide foreign key columns (11 objects)**
    4. Press the **Apply fix** icon to instantly apply fixes.
    ![Apply Fix](./Images/apply_fix.png)
    5. Press the **Saves the changes to the connected database (Ctrl+S) button.**
    
### Objective: Create a new rule that can be utilized within the Best Practices Rules.

1. Within Tabular Editor:
    1. Navigate to **Tools** and select **Manage BPA Rules...**
    2. Within the Manage Best Practice Rules dialog
        1. Select from the Rule collections: **Rules on the local machine**
        2. Press **New rule...** and insert the following values from the hash table below.
        3. Once completed press **OK** to save.

| Key | Value |
| :--- | :----- |
| Name | Disable auto time intelligence |
| ID | DISABLE_AUTO_TIME_INTELLIGENCE |
| Severity | 1 |
| Category | Performance |
| Description | Navigate to the Power BI Desktop's Current File properties and disable the setting Auto date/time in Data Load. Note: To disable for all new files created in Power BI Desktop disable the setting Auto date/time for new files in the Global settings Data Load. |
| Applies to | Model |
| Rule Expression Editor | Tables.Any(Name.StartsWith("LocalDateTable_")) |
| Minimum Compatability Level | CL 1200 (SQL Server 2016 / Azure AS) |

2. Navigate to **Tools** and select **Best Practice Analyzer...** or press the hotkey (**F10**) to view the newly created rule.

**Important Note:** Changes to the model can be both read from and written to the Power BI dataset. Any changes within Tabular Editor will need to be saved back to the connected database.
___

# Advanced Scripting (Automation)

Advanced Scripting, lets users write a script, to more directly manipulate the objects in the loaded Tabular Model, that can be saved as Custom Actions for easy invocation directly in the Explorer Tree.

Website: https://github.com/otykier/TabularEditor/wiki/Advanced-Scripting

**Important Note:** 
- You can use CTRL+Z to undo or CTRL+Y to redo changes.
- The scripting language is C#

### Objective: Create a script to automate the addition of measures in the model.

## Instructions
### [Optional: Guided Video](https://www.youtube.com/watch?v=qtNVvaaCKnc&list=PLKW7XPyNDgRCOiC69kZWfRQdOxcnQy2yA&index=5)

### Tables

1. Select the **Advanced Scripting** tab and enter the below script
```
Selected.Table.AddMeasure( 
    "Total Count of " + Selected.Table.Name,
    "COUNTROWS('" + Selected.Table.Name + "')",
    "Measurements" 
);
```
**Recommended Practice:** Utilize a single quote in the event of a table name containing a space for the expression.

2. Select the **Orders** table and then press the **Run script (selection only) F5** button. ▶
3. Within the Model Explorer navigate to the **Orders** table, the **Measurements** folder and select the **Total Count of Orders** measure.
4. Review the following arguments from the script earlier in comparison with the Property Pages
```
Selected.Table.AddMeasure( 
    Argument1 // Name ,
    Argument2 // DAX expression ,
    Argument3 // Display Folder
);
```
![Property Pages](./Images/property_pages.png)

5. Press the **Saves the changes to the connected database (Ctrl+S) button.**
6. Navigate to Power BI Desktop to confirm the new measure has been added to the file.
7. With the Model Explorer focused, press **CTRL+Z** to undo actions until the folder and measure have been removed from the **Orders** table.
8. Within the **Advanced Scripting** tab update the script to include a variable
```
var tableName = Selected.Table.Name;

Selected.Table.AddMeasure(
    "Total Count of " + tableName,
    "COUNTROWS('" + tableName + "')",
    "Measurements"
);
```
9. Select the **Orders** table and then press the **Run script (selection only) F5** button. ▶
10. Confirm within the Model Explorer in the the **Orders** table and the **Measurements** folder the the **Total Count of Orders** measure exists.
11. Select the **Customers** and **Employees** table and press the **Run script (selection only) F5** button. ▶
12. An error will now be displayed stating **The selection contains more than one object of type Table** indicating only one active object can be selected.
13. Within the  **Advanced Scripting** tab select **Samples**, **Tutorials** and **Loop through all selected tables**
![All Selected Tables](./Images/all_selected_tables.png)
14. Update the script to include the below:

```
foreach(var table in Selected.Tables) {
   
    var tableName = table.Name;
   
    table.AddMeasure(
        "Total Count of " + tableName,
        "COUNTROWS('" + tableName + "')",
        "Measurements"
    );
    
};
```
15. Select the **Orders**, **Customers**, **Employeees** and **Customer Transactions** tables and then press the **Run script (selection only) F5** button. ▶
16. Press the **Saves the changes to the connected database (Ctrl+S) button.**
17. Navigate to Power BI Desktop to confirm the new measure has been added to the file.

### Columns

1. Within the  **Advanced Scripting** tab select **Samples**, **Tutorials** and **Loop through all selected columns**
2. Update the script to include the below:
```
foreach(var column in Selected.Columns) {

    column.Table.AddMeasure(
        "Sum of " + column.Name,
        "SUM(" + column.DaxObjectFullName + ")",
        "Measurements"
    );

}
```
**Important Note:** The DaxObjectFullName property provides the fully qualified name of the column for use in the DAX expression: 'TableName'[ColumnName].

3. Select the following columns in the **Sales Order Lines** table and then press the **Run script (selection only) F5** button. ▶
    1. **Quantity**
    2. **Unit Price**
    3. **Picked Quantity**
4. Review the **Measurements** folder in the **Sales Order Lines** table to confirm the new measures have been added.
5. Select the **Model Explorer** to focus and press **Ctrl+Z** to undo the above script.
6. Update the script to include the below:
```
foreach(var column in Selected.Columns) {

    column.Table.AddMeasure(
        "Sum of " + column.Name,
        "SUM(" + column.DaxObjectFullName + ")",
        "Measurements"
    );
    
    column.Table.AddMeasure(
        "Average of " + column.Name,
        "AVERAGE(" + column.DaxObjectFullName + ")",
        "Measurements"
    );

}
```
**🏆 Challenge:** Update the above code to include variables.

7. Select the following columns in the **Sales Order Lines** table and then press the **Run script (selection only) F5** button. ▶
    1. **Quantity**
    2. **Unit Price**
    3. **Picked Quantity**
8. Review the **Measurements** folder in the **Sales Order Lines** table to confirm the new measures have been added.
9. Press the **Saves the changes to the connected database (Ctrl+S) button.**

___

# Calculation Groups

A calculation group is a set of calculation items that are conveniently grouped together because they are variations on the same topic.

### Objective: Create a calculation group for various time intelligence expressions.

## Instructions
### [Optional: Guided Video](https://www.youtube.com/watch?v=xOkmNZd0SY4&list=PLKW7XPyNDgRCOiC69kZWfRQdOxcnQy2yA&index=6)

Within Tabular Editor:
1. Navigate to the **Calendar** table's **Date** column and edit the Property Pages **Hidden** property to **False**.
2. Right click the **Tables** object and select **Create New** and **Calculation Group ALT+7**
3. Rename the **New Calculation Group** to **Time Intelligence**
4. Change the **Name** column's, **Name** property to **Time Calculation** (Pro Tip: **F2** for Edit Mode)
5. Right click **Calculation Items** and select **New Calculation Item**, repeat the following three times.
6. For each of the following insert the following expression:

| Key | Value |
| :--- | :----- |
| New Calculation | CALCULATE ( SELECTEDMEASURE (), DATESMTD ( 'Calendar'[Date] ) ) |
| New Calculation 1 | CALCULATE ( SELECTEDMEASURE (), DATESQTD ( 'Calendar'[Date] ) ) |
| New Calculation 2 | CALCULATE ( SELECTEDMEASURE (), DATESYTD ( 'Calendar'[Date] ) ) | 

7. Individually select and rename each of the following Calcuation Items individually within the Property Page's **Name** property:

| Key | Value |
| :--- | :----- |
| New Calculation | MTD |
| New Calculation 1 | QTD |
| New Calculation 2 | YTD | 

![Calculated Items](./Images/calc_items.png)

8. Select all three calculation items (MTD, QTD, YTD) to bulk update the Property Page's **Format String Expression** property to **"$#,0.00"**

![Format String](./Images/format_string.png)

9. Press the **Saves the changes to the connected database (Ctrl+S) button.**
 
Within Power BI Desktop:
1. Navigate to the **Time Intelligence** table, right click and select **Refresh data**
2. Using a **Matrix** visual insert the following:

| Key | Value |
| :--- | :----- |
| Rows | 'Calendar'[Date] |
| Values | [Total Unit Price] |
| Columns | 'Time Intelligence'[Time Calculation] |

![Power BI Matrix](./Images/pbi_matrix.png)

___

# Continue Your Journey

### An indepth walk through of Tabular Editor
[PowerBI.Tips - Tabular Editor Playlist](https://www.youtube.com/watch?v=c-jZMzsvKnM&list=PLZjKz7bVsqV1mmA48wXqrSDPbDSGBvLdL)

Includes:
- Intro to Tabular Editor (1:03:33)
- Using Scripts (1:09:31)
- Best Practice Analyzer (1:05:42)
- Using Devops (1:24:05)

### Advanced Scripting
[Script Snippets](https://github.com/otykier/TabularEditor/wiki/Useful-script-snippets)

[Community Scripts](https://github.com/TabularEditor/Scripts)

### Calculation Groups
[Microsoft Docs](https://docs.microsoft.com/en-us/analysis-services/tabular-models/calculation-groups?view=asallproducts-allversions)

[SQLBI - Creating calculation groups in Power BI Desktop using Tabular Editor](https://www.youtube.com/watch?v=a4zYT-N-zsU)

[SQLBI - Calculation Groups (Blog)](https://www.sqlbi.com/calculation-groups/)
