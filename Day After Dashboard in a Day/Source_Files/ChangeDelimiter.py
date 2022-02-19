import csv

with open('./DimProduct.csv') as fin:
    # newline='' prevents extra newlines when using Python 3 on Windows
    # https://stackoverflow.com/a/3348664/3357935
    with open('./DimProduct.csv', 'w', newline='') as fout:
        reader = csv.DictReader(fin, delimiter=',')
        writer = csv.DictWriter(fout, reader.fieldnames, delimiter='|')
        writer.writeheader()
        writer.writerows(reader)