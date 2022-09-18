# Data Visualization

✏️ Lab scenario
---

For this portion of the lab, we've been tasked with creating a Power BI report to unlock new insights for our users. The interactivity of our report should be both **functional** and **fast** to ensure a pleasant viewing experience for our users.

# Report design

The content throughout this lab utilizes the proven design processes created by leading report design experts. These processes encompasses the phases of understanding the report users and their requirements, exploring pleasing report designs, and developing reports all the way into production.

Learn more about [Designing effective Power BI reports](https://docs.microsoft.com/users/heyrob/collections/o4dhk4z8xpr8q) by visiting Microsoft Learn

## Live Connection

For enterprise scale deployments, it's recommended to separate dataset development, and the development of reports and dashboards.

This approach should start from Power BI Desktop, by creating a separate PBIX file for datasets and reports. For example, you can create a dataset PBIX file and uploaded it to the development stage. Later, your report authors can create a new PBIX only for the report, and connect it to the published dataset using a live connection. This technique allows different creators to separately work on modeling and visualizations.

With shared datasets, you can also use this method across workspaces.

Learn more about [connecting to Power BI datasets](https://learn.microsoft.com/power-bi/connect-data/desktop-report-lifecycle-datasets).

---

1. We'll start by creating a new Power BI file by selecting the **File** and **New** option (shortcut **Ctrl+N**) if Power BI Desktop is currently open.
    1. If Power BI Desktop is not currently open, a new application instance will automatically create a new file upon opening.

    ![New file](./Media/NewFile.png)

1. From the **Home** tab, we'll select the **Data hub** option and then **Power BI datasets** to create a new live connection to an existing dataset.
    
    ![Data hub](./Media/DataHub.png)

1. From the **Data hub** window, we'll select the published dataset from the **Data modeling** lab and then the **Connect** button to create a new **Live connection** to our dataset.

    ![Data hub connect](./Media/DataHubConnect.png)

1. In the bottom right corner of our current file, the text **Connected live to the Power BI dataset** is now present, including the name of the dataset and the workspace it's located within.

    ![Connected live](./Media/ConnectedLive.png)

---

## Page canvas and elements

Utilize PowerPoint to design backgrounds.

Learn more about [themeable backgrounds](https://alluringbi.com/2020/05/05/themeable-backgrounds-for-power-bi/) from the community resource [AlluringBI.com](https://alluringbi.com)

---

### Canvas background

1. In the bottom left of the current file select the "**+**" icon to create a new page.

    ![Create new page](./Media/CreateNewPage.png)

1. Right click the following page names and select the **Rename Page** option to update to the following names in the table below.

    | Previous Page Name | Renamed Page Name |
    | :--- | :--- |
    | Page1 | Summary |
    | Page2 | Detail |

    ![Rename page](./Media/RenamePage.png)

1. For each of the pages below, we'll navigate to the **Visualizations** pane, select the **Format your report page** button and update the following settings within the **Canvas background** section from the table below
    1. For the **Image** field select **Browse...** and then copy/paste the according url into the **File name:** field.

        ![File name](./Media/FileOpen.png)

    | Page | Image (file) | Image fit | Transparency |
    | :--- | :--- | :--- | :--- |
    | Summary | ```https://raw.githubusercontent.com/microsoft/pbiworkshops/main/Day%20After%20Dashboard%20in%20a%20Day/Media/ContosoSummary.svg``` | Fit | 0% |
    | Detail | ```https://raw.githubusercontent.com/microsoft/pbiworkshops/main/Day%20After%20Dashboard%20in%20a%20Day/Media/ContosoDetail.svg``` | Fit | 0% |

    ![Contoso Summary background](./Media/ContosoSummary.png)

---

### Elements

1. Navigate to the **Insert** tab, select the **Text box** element and complete the following steps below.
    1. Update the Font size to: **18**
    1. Update the Font color to: **White, 50% Darker**
    1. Type the text within the text box: **SALES REPORT**

    ![Sales report text box](./Media/SalesReportTextBox.png)

1. With the text box still active, we'll navigate to the **Format** pane and in the search box type in **background**. 

    From the matching options navigate to the **Effects** group and set the **Background** property to **Off**.

    ![Sales report text box](./Media/TextBoxBackgroundDisabled.png)

1. Navigate to the **Insert** tab, select the **Buttons** element and then **Navigator** option. From the available choices select the **Page navigator** option. 

    Reposition the buttons on the top right side of the canvas.

    ![Page navigator](./Media/PageNavigator.png)

1. We'll now click and hold the left mouse click and select both the text box and the page navigator elements on the **Summary** page. Once selected, we can navigate to the **Home** tab and select **Copy** or press the keyboard shortcut **Ctrl+C**
    
    **Note**: we can also select all elements by pressing CTRL+A or holding ctrl when clicking each item.

    ![Select multiple](./Media/SelectMultiple.png)

1. Navigate to the **Detail** page and from the **Home** tab select the **Paste** button or press the keyboard shortcut **Ctrl+V**. 
    
    This will ensure our elements are perfectly aligned between both the **Summary** and **Detail** page.

    ![Paste multiple detail](./Media/PasteMultipleDetail.png)

1. Select the **Text box** element on the **Detail** page and update the text from "**SALES REPORT**" to "**SALES DETAIL |**"

    ![Sales detail](./Media/SalesDetail.png)

## Visuals


## Artificial Intelligence

## Tooltips


# Next steps
We hope this portion of the lab has shown how various storage modes and modeling options can offer a flexible and optimized experience to build enterprise scalable solutions using Power BI Desktop.

- Return to the [Day After Dashboard in a Day](./README.md) homepage