![Power Query icon](https://github.com/microsoft/pbiworkshops/blob/main/_Asset%20Library/PowerQuery.png?raw=true)

# Power Query Custom Functions and Documentation in An Hour

Microsoft Power Query provides a powerful "Get data" experience that encompasses many features. A core capability of Power Query is to filter and combine, that is, to "mash-up" data from one or more of a rich collection of supported data sources. Any such data mashup is expressed using the Power Query Formula Language (informally known as "**M**").

The Power Query Formula Language is a powerful **query language** optimized for building queries that **mashup** data. It's a **functional**, **case sensitive** language.

For computer language theorists: Power Query is a mostly pure, higher-order, dynamically typed, partially lazy, functional language.

[Learn more about the Power Query formula language](https://docs.microsoft.com/powerquery-m/m-spec-introduction)

___

## Optional: Install Power Query language service for VS Code

Available in the [Visual Studio Code Marketplace](https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery), the Power Query / M Language extension provides a language service for the Power Query / M formula language with the following capabilities:

- **Fuzzy autocomplete**
    - Suggests keywords, local variables, and the standard Power Query library.
- **Hover**
    - Displays function documentation if it exists, and validates the types for function arguments.
- **Functional hints**
    - Displays function documentation if it exists, and validates the types for function arguments.
- **Code formatting**
    - Provides a formatter for the "Format Document" (Ctrl + Shift + F) command.

![Language extension](https://github.com/microsoft/vscode-powerquery/raw/HEAD/imgs/fuzzyAutocomplete.gif)

___

# Power Query Values

A single piece of data is called a value. Broadly speaking, there are two general categories of values: **primitive values**, which are atomic, and **structured values**, which are constructed out of primitive values and other structured values.

[Learn more about values](https://docs.microsoft.com/powerquery-m/m-spec-basic-concepts)

## Primitive values

| Name | Type | Value |
|:-- | :-- | :-- |
| Null | Null.Type | null |
| Logical | Logical.Type | true, false |
| Number | Int8.Type<br> Int16.Type<br> Int32.Type<br> Int64.Type<br> Currency.Type<br> Decimal.Type |  10, -15, 10.15 |
| Time | Time.Type | #time(15,05,15) |
| Date | Date.Type | #date(2022,06,30) |
| DateTime | DateTime.Type | #datetime(2022,06,03,15,05,15) |
| DateTimeZone | DateTimeZone.Type |  #datetimezone(2022,06,03,15,05,15,-6) |
| Text | Text.Type | "Hello, world!" |
| Binary | Binary.Type | #binary("AQID") |
| Function | Function.Type | (bar as number) as any => let foo = bar * 10 in foo |

## Structured values

| Name | Type | Value |
|:-- | :-- | :-- |
| List | List.Type | {10, "cats", #date(2022,07,04)} |
| Record | Record.Type | [a = 10, b = {1,2,3}, c = "pizza"] |
| Table | Table.Type | #table({"Animal","Count"},{{"Cat",99},{"Dog",1},{"Bear",3}}) |

## Custom functions

In the Power Query M formula language, a function is a mapping from a **set of** input values to a **single output** value. A function is written by first **naming the function parameters**, and then **providing an expression to compute** the result of the function.

The body of the function follows the goes-to (=>) symbol.

### Goes-to symbol

```powerquery-m
() => "Hello, world"
```

Optionally, type information can be included on **parameters** and the function **return value**.

### Implicit return value

```powerquery-m
() => "Hello, world"
```

### Explicit return value

```powerquery-m
() as text => "Hello, world"
```

If the function has a declared return type, then the result **is compatible** if the value yielded by evaluating the function with the supplied arguments **is compatible with the return type**.

### Required parameter

```powerquery-m
(#"Full name" as text) => "Hello, " & #"Full name"
```

### Optional parameter

```powerquery-m
(optional #"Full name" as text) => if (#"Full name" = null) then "Hello" else "Hello, " & #"Full name"
```

Parameters and/or return value can be implicit or explicit. Implicit parameters and/or return value are of type any. Type any is similar to an object type in other languages. All types in M derive from type any.

[Learn more about Power Query functions](https://docs.microsoft.com/powerquery-m/understanding-power-query-m-functions)

## let expressions

The let expression encapsulates a **set of values** to be *computed*, **assigned names**, and then used in a subsequent expression that **follows the in statement**.

### Step identifiers

An identifier can take the following two forms:

- identifier_name
- #"Identifier name"

```powerquery-m
(Repeated as number, optional #"First name" as text) =>
let
    Greeting = "Hey" & (if #"First name" = null then "" else Text.Combine({" ", #"First name", "!"})),
    YELLING = Text.Upper(Greeting),
    #"Why are we yelling a lot?" = List.Repeat({YELLING}, Repeated)
in
    #"Why are we yelling a lot?"
```

## Comments

### Single line

Single line comments start with: **//**

Keyboard shortcut: **Ctrl+/**

```powerquery-m
let
    // This step stores the current system datetime
    currentDateTime = DateTime.LocalNow(),
    // This step extracts the date part
    dateOnly = DateTime.Date(currentDateTime),
    // This step extracts the year part
    yearOnly = Date.Year(dateOnly)
in
    yearOnly
```

### Multi-line

Multi-line comments start with: **/*** and end with ***/**

Keyboard shortcut: **Alt+Shift+A**

```powerquery-m
let
    /* A nested operation that performs the following activities:
        • Gets current system datetime
        • Extracts the date part
        • Extracts the year part */
    yearOnly = Date.Year(
                    DateTime.Date(
                        DateTime.LocalNow()
                    )
                )
in
    yearOnly
```
[Learn more about comments](https://docs.microsoft.com/powerquery-m/comments)

[Learn more Advanced Editor shortcuts](https://xxlbi.com/blog/pq-advanced-editor-keyboard-shortcuts/)

## Documentation

You can provide documentation for your function by defining custom type values. The process looks like this:

- Define a type for each parameter.
- Define a type for your function.
- Add various Documentation.* fields to your types metadata **record**.
- Call [Value.ReplaceType](https://docs.microsoft.com/powerquery-m/value-replacetype) to ascribe the type to your shared function.

### Replacing metadata

```powerquery-m
let
    fxHelloWorld = () => "Hello, World",
    fxDocumentation = [
        Documentation.Name = "My first line of code"
    ]
in
    Value.ReplaceType(
        fxHelloWorld,
        Value.ReplaceMetadata(
            Value.Type(fxHelloWorld),
            fxDocumentation
        )
    )
```

### Viewing metadata
Returns a record containing the input's metadata.

```powerquery-m
Value.Metadata( Value.Type( Sql.Database ) )
```
[Learn more about Value.Metadata](https://docs.microsoft.com/powerquery-m/value-metadata)

### Function documentation

The following table lists the Documentation fields that can be set in the metadata for your function. All fields are optional.

| Field | Type | Details |
| :--- | :--- | :--- |
| Documentation.Name | text | Text to display across the top of the function invocation dialog. |
| Documentation.LongDescription | text | Full description of what the function does, displayed in the function info. <br><br> *Supports limited HTML properties |
| Documentation.Examples | list | **List** of **record** objects with example usage of the function. Only displayed as part of the function info.<br><br>Each record should contain the following optional text fields: **Description**, **Code**, and **Result**. |

```powerquery-m
let
    fxHelloWorld = () => "Hello, World",
    fxDocumentation = [
        Documentation.Name = "My first line of code",
        Documentation.Description = "This function will return the text: Hello, World",
        Documentation.Examples = {
            [
                Description = "The text Hello, World",
                Code = "Hello, World",
                Result = "Hello, World"
            ],
            [
                Description = "Even more of the text Hello, World",
                Code = "Hello, World",
                Result = "Hello, World"
            ]
        }
    ]
in
    Value.ReplaceType(
        fxHelloWorld,
        Value.ReplaceMetadata(
            Value.Type(fxHelloWorld),
            fxDocumentation
        )
    )
```
### Parameter documentation

The following table lists the Documentation fields that can be set in the metadata for your function parameters. All fields are optional.

| Field | Type | Details |
| :--- | :--- | :--- |
| Documentation.FieldCaption | text | Friendly display name to use for the parameter. |
| Documentation.FieldDescription | text | Description to show next to the display name. |
| Documentation.SampleValues | list | **List** of sample values to be displayed (as faded text) inside of the text box. |
| Documentation.AllowedValues | list | List of valid values for this parameter. Providing this field will change the input from a textbox to a drop down list.<br><br> **Note**, this doesn't prevent a user from manually editing the query to supply alternative values. |
| Formatting.IsMultiLine | boolean | Allows you to create a multi-line input, for example for pasting in native queries. |
| Formatting.IsCode | boolean | Formats the input field for code, commonly with multi-line inputs. Uses a code-like font rather than the standard font. |

```powerquery-m
let
    PizzaType = type function (#"First topping" as
        (
            type text
            meta
            [
                Documentation.FieldCaption = "First topping choice",
                Documentation.FieldDescription = "Choose the first topping of your pizza",
                Documentation.SampleValues = {
                    "Pepperoni",
                    "Sausage",
                    "Pineapple"
                },
                Formatting.IsMultiLine = false,
                Formatting.IsCode = true
            ]
        ), #"Second topping" as
        (
            type text
            meta
            [
                Documentation.FieldCaption = "Second topping choice",
                Documentation.FieldDescription = "Choose the second topping of your pizza",
                Documentation.SampleValues = {
                    "Olive",
                    "Mushroom",
                    "Jalapeño"
                },
                Formatting.IsMultiLine = false,
                Formatting.IsCode = false
            ]
        )) as text,
    PizzaFunction =
        (#"First topping" as text, #"Second topping" as text) as text =>
            Text.Combine(
                {
                    "The best pizza in the world is",
                    #"First topping",
                    "and",
                    #"Second topping"
                },
                " "
            )
in
    Value.ReplaceType(
        PizzaFunction,
        PizzaType
    )
```

[Learn more about function documentation](https://docs.microsoft.com/power-query/handlingdocumentation)