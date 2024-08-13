![Microsoft Fabric](./Media/DataFactory.png)
</br>
</br>

# Data Factory in a Day with Microsoft Fabric

## Introduction

In Data Factory in a Day with Microsoft Fabric, you will explore various data ingestion and transformation experiences. This includes the orchestration of end-to-end projects with [data pipelines](https://learn.microsoft.com/fabric/data-factory/create-first-pipeline-with-sample-data) and an introduction to [dataflow gen2]() which represents the next generation of no-code/low-code data transformation that now support [data destinations](https://learn.microsoft.com/fabric/data-factory/dataflows-gen2-overview#data-destinations) and [fast copy](https://learn.microsoft.com/fabric/data-factory/dataflows-gen2-fast-copy) data ingestion, which enhances the efficiency of data movement.

This tutorial assumes that you have a working knowledge of accessing content and creating items using the Microsoft Fabric cloud service. By the end of the course, you will have a comprehensive understanding of how to leverage these tools to streamline your data ingestion workflows.

### Prerequisites
The content in this lab requires enablement of select tenant settings and licensing assignment within the Microsoft Fabric service. Please ensure that you have the following prerequisites before proceeding:
- **Microsoft Fabric enabled in your tenant:** To enable Microsoft Fabric, [follow the instructions provided in this link](https://learn.microsoft.com/fabric/admin/fabric-switch).

- **Premium capacity subscription:** You need a premium capacity subscription to use Microsoft Fabric. 
    - You can either use a [paid capacity (P or F SKUs)](https://learn.microsoft.com/power-bi/enterprise/service-premium-what-is) or a [Microsoft Fabric trial (preview)](https://learn.microsoft.com/fabric/get-started/fabric-trial).

    - **Note:** Premium Per User is not a supported license type to create Microsoft Fabric items.

For additional system requirements or to create a M365 developer trial tenant, see [additional prerequisites for the lab](./Prerequisites.md).

## Presentation material

To view or download the latest PowerPoint presentation of the lab material, visit the following link: [Data Factory in a Day with Microsoft Fabric]().

## Getting started

In this lab, you will learn how to create a project task flow and understand the basics of Data Factory experiences. This tutorial is designed to provide you with hands-on experience in building and managing data workflows using Microsoft Fabric. By the end of this lab, you will have a foundational understanding of key concepts and tools that are essential for efficient data management and transformation.

1. First, you will learn how to create a medallion architecture [task flow](https://learn.microsoft.com/fabric/get-started/task-flow-overview) within a workspace. The medallion architecture is a design pattern that organizes data into different layers, such as bronze, silver, and gold, to improve data quality and accessibility. This task flow will help you understand how to structure and manage your data effectively.

1. Next, you will create a [lakehouse](https://learn.microsoft.com/fabric/data-engineering/lakehouse-overview) item for data storage. A lakehouse combines the best features of data lakes and data warehouses, providing a unified platform for storing and analyzing large volumes of data. This step is crucial for setting up a scalable and efficient data solution that supports various data processing and analytics tasks.

1. Finally, you will create a data pipeline to ingest sample data using the [copy activity](https://learn.microsoft.com/fabric/data-factory/copy-data-activity) within a data pipeline. Data pipelines are essential for automating the movement and transformation of data from various sources to destinations. The copy activity is a powerful tool that allows you to efficiently transfer data between different storage systems, ensuring that your data is always up-to-date and ready for analysis.

To start the lab, visit [Getting started](./GettingStarted.md)

## Data pipeline

1. Creating a dynamic pipeline using variables to manage and copy data efficiently through reusable components.
1. Setting up conditional paths to handle different scenarios and ensure logical flow within your pipeline.
1. Moving data between medallion layers, specifically the bronze and silver layers, to optimize data storage and retrieval for analysis.

To start the lab, visit [Data pipeline](./DataPipeline.md)

## Dataflow Gen2

In this lab you'll learn about how to shape and orchestrate your data using Data Factory experiences.

1. How to create a [Dataflow Gen2](https://docs.microsoft.com/power-bi/transform-model/dataflows/dataflows-introduction-self-service) to prepare and load data using Power Query Online.
1. Understanding the [storage and compute staging](https://blog.fabric.microsoft.com/blog/data-factory-spotlight-dataflows-gen2?ft=Data-factory:category) architecture for large scale data transformations.
1. Configuring [data destination outputs](https://learn.microsoft.com/fabric/data-factory/dataflow-gen2-data-destinations-and-managed-settings).

To start the lab, visit [Dataflow Gen2](./DataflowGen2.md)