// Orders query - Power Query (M)
// Combines the monthly order files in a folder.
// "Transform File" and "Sample File" are the helper function/query that
// Excel generates automatically when you use Combine Files on a folder.
let
    Source = Folder.Files("<path-to-data>\order"),
    #"Filtered Hidden Files1" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
    #"Invoke Custom Function1" = Table.AddColumn(#"Filtered Hidden Files1", "Transform File", each #"Transform File"([Content])),
    #"Renamed Columns1" = Table.RenameColumns(#"Invoke Custom Function1", {"Name", "Source.Name"}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Renamed Columns1", {"Source.Name", "Transform File"}),
    #"Expanded Table Column1" = Table.ExpandTableColumn(#"Removed Other Columns1", "Transform File", Table.ColumnNames(#"Transform File"(#"Sample File"))),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Table Column1", each [ProductID] <> null and [ProductID] <> ""),
    #"Filtered Rows1" = Table.SelectRows(#"Filtered Rows", each [Quantity] <> null and [Quantity] <> ""),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows1",{"OrderID"}),
    #"Added Index" = Table.AddIndexColumn(#"Removed Columns", "Index", 0, 1, Int64.Type),
    #"Added Index1" = Table.AddIndexColumn(#"Added Index", "Index.1", 1, 1, Int64.Type),
    #"Removed Columns1" = Table.RemoveColumns(#"Added Index1",{"Index"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns1",{"Source.Name", "Index.1", "CustomerID", "ProductID", "OrderDate", "Quantity"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Index.1", "OrderID"}}),
    #"Replaced Value" = Table.ReplaceValue(#"Renamed Columns","/","-",Replacer.ReplaceText,{"OrderDate"}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Replaced Value", "OrderDate", Splitter.SplitTextByDelimiter("-", QuoteStyle.Csv), {"OrderDate.1", "OrderDate.2", "OrderDate.3"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"OrderDate.1", Int64.Type}, {"OrderDate.2", Int64.Type}, {"OrderDate.3", Int64.Type}}),
    #"Added Conditional Column" = Table.AddColumn(#"Changed Type", "Year", each if [OrderDate.1] > 31 then [OrderDate.1] else if [OrderDate.3] > 31 then [OrderDate.3] else "nule"),
    #"Extracted Text Between Delimiters" = Table.TransformColumns(#"Added Conditional Column", {{"Source.Name", each Text.BetweenDelimiters(_, "_", "."), type text}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Extracted Text Between Delimiters",{{"Source.Name", Int64.Type}}),
    #"Renamed Columns2" = Table.RenameColumns(#"Changed Type1",{{"Source.Name", "Month"}}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Renamed Columns2",{"OrderID", "CustomerID", "ProductID", "OrderDate.1", "OrderDate.2", "OrderDate.3", "Quantity", "Year", "Month"}),
    #"Added Custom" = Table.AddColumn(#"Reordered Columns1", "Day", each if  [OrderDate.1]<=31 and [OrderDate.1]<>[Month] then
[OrderDate.1] else if [OrderDate.2]<=31 and [OrderDate.2]<>[Month] then [OrderDate.2]
else if  [OrderDate.3]<=31 and [OrderDate.3]<>[Month] then [OrderDate.3] 
else [Month]),
    #"Removed Columns2" = Table.RemoveColumns(#"Added Custom",{"OrderDate.1", "OrderDate.2", "OrderDate.3"}),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Removed Columns2", {{"Month", type text}, {"Day", type text}, {"Year", type text}}, "en-US"),{"Month", "Day", "Year"},Combiner.CombineTextByDelimiter("/", QuoteStyle.None),"New Date"),
    #"Changed Type2" = Table.TransformColumnTypes(#"Merged Columns",{{"New Date", type date}}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Changed Type2", {{"New Date", type date}}, "en-US"),
    #"Changed Type3" = Table.TransformColumnTypes(#"Changed Type with Locale",{{"New Date", type date}})
in
    #"Changed Type3"
