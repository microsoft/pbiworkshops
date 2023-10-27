![Microsoft Fabric](https://raw.githubusercontent.com/microsoft/FabricCAT/main/Asset%20Library/MicrosoftFabric.png)
</br>
</br>

# Day After Dashboard in a Day with Microsoft Fabric

## Introduction
In the Day After Dashboard in a Day with Microsoft Fabric you will learn about various advanced analytics experiences, such as the [Direct Lake](https://learn.microsoft.com/power-bi/enterprise/directlake-overview) mode with Synapse Data Engineering, [data destinations](https://learn.microsoft.com/fabric/data-factory/dataflows-gen2-overview#data-destinations) with Dataflow Gen2 and [Pipelines](https://learn.microsoft.com/fabric/data-factory/create-first-pipeline-with-sample-data) in Data Factory, and designing stunning reports and more with Power BI.

This course assumes that you have a working knowledge of authoring using Power BI Desktop and content sharing via the Microsoft Fabric cloud service.

### Prerequisites
The content in this lab requires enablement of select tenant settings and licensing assignment within the Microsoft Fabric service. Please ensure that you have the following prerequisites before proceeding:
- **Microsoft Fabric enabled in your tenant:** To enable Microsoft Fabric, [follow the instructions provided in this link](https://learn.microsoft.com/fabric/admin/fabric-switch).

- **Premium capacity subscription:** You need a premium capacity subscription to use Microsoft Fabric. 
    - You can either use a [paid capacity (P or F SKUs)](https://learn.microsoft.com/power-bi/enterprise/service-premium-what-is) or a [Microsoft Fabric trial (preview)](https://learn.microsoft.com/fabric/get-started/fabric-trial).

    - **Note:** Premium Per User is not a supported license type to create Microsoft Fabric items.

- **Pro user license:** You need a Pro user license to create Power BI items in Microsoft Fabric.

For additional system requirements or to create a M365 developer trial tenant, see [additional prerequisites for the lab](./Prerequisites.md).

## Presentation material

To view or download the latest PowerPoint presentation of the lab material, visit the following link: [Day After Dashboard in a Day with Microsoft Fabric](https://github.com/microsoft/pbiworkshops/raw/main/Day%20After%20Dashboard%20in%20a%20Day/Day%20After%20Dashboard%20in%20a%20Day.pptx).

## Data Preparation

In this lab you'll learn about how to shape and orchestrate your data using Data Factory experiences.

1. How to create a [Dataflow Gen2](https://docs.microsoft.com/power-bi/transform-model/dataflows/dataflows-introduction-self-service) to prepare and load data using Power Query Online.
1. Understanding the [storage and compute staging](https://blog.fabric.microsoft.com/blog/data-factory-spotlight-dataflows-gen2?ft=Data-factory:category) architecture for large scale data transformations.
1. How to use [Pipelines](https://learn.microsoft.com/fabric/data-factory/activity-overview) to orchestrate and control your data movement.

To start the lab, visit [Data Preparation](./DataPreparation.md)

## Data Modeling

In this lab you'll learn how to create datasets optimized for scale and performance usability using web model editing in the Microsoft Fabric service (cloud).

1. How to create a [Direct Lake](https://docs.microsoft.com/power-bi/transform-model/desktop-storage-mode) semantic model.
1. How to properly model your [data](https://learn.microsoft.com/power-bi/guidance/star-schema) using the web model editing experience.
1. How to add metadata to your [semantic model](https://learn.microsoft.com/en-us/power-bi/transform-model/) for deeper analysis and insights.

To start the lab, visit [Data Modeling](./DataModeling.md)

## Data Visualization

In this lab you'll learn about designing efficient and stunning reports using Power BI Desktop.

1. How to use canvas backgrounds and shape elements to create professional report layouts.
1. How to create report level measures for dynamic report elements.
1. How to leverage no-code artificial intelligence to find new insights in your data.

To start the lab, visit [Data Visualization](./DataVisualization.md)
