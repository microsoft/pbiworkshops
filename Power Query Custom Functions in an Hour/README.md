![Power Query icon](https://github.com/microsoft/pbiworkshops/blob/main/_Asset%20Library/PowerQuery.png?raw=true)

# Power Query Custom Functions in An Hour



___

## Power Query language service for VS Code

Available in the [Visual Studio Code Marketplace](https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery), the Power Query / M Language extension provides a language service for the Power Query / M formula language with the following capabilities:

- Fuzzy autocomplete
- Hover
- Functional hints
- Code formatting

![Language extension](https://github.com/microsoft/vscode-powerquery/raw/HEAD/imgs/fuzzyAutocomplete.gif)

___

# Power Query Values

A single piece of data is called a value. Broadly speaking, there are two general categories of values: **primitive values**, which are atomic, and **structured values**, which are constructed out of primitive values and other structured values.

[Learn more about values](https://docs.microsoft.com/powerquery-m/m-spec-basic-concepts)

## Primitive values

| Type | Value |
|:-- | :-- |
| Null | null |
| Logical | true, false |
| Number | 10.15, 10, -15 |
| Time | #time(15,05,15) |
| Date | #date(2022,06,30) |
| DateTime | #datetime(2022,06,03,15,05,15) |
| DateTimeZone | #datetimezone(2022,06,03,15,05,15,-6) |
| Text | "Hello, world!" |
| Binary | #binary("AQFO") |
| Type | text |

## Structured values

| Type | Value |
|:-- | :-- |
| List | {10, "cats", #date(2022,07,04)} |
| Record | [a = 10, b = {1,2,3}, c = "pizza"] |
| Table | #table({"Animal","Count"},{{"Cat",99},{"Dog",1},{"Bear",3}}) |

## Custom functions