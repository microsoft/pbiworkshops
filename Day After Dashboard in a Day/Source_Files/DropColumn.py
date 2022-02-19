import pandas as pd
import csv

# Read column names from file
cols = list(pd.read_csv("DimCustomer.csv", sep='|'))
print(cols)

# Use list comprehension to remove the unwanted column in **usecol**
df = pd.read_csv("DimCustomer.csv", sep='|',  usecols =[i for i in cols if i != 'Gender'])

print(df)

df.to_csv('DimCustomerUpdate.csv', sep='|', index=False)
