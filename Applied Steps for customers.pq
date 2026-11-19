// Customers query - Power Query (M)
let
    Source = Csv.Document(File.Contents("<path-to-data>\Customers.csv"),[Delimiter=",", Columns=3, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Use First Row as Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Change Type" = Table.TransformColumnTypes(#"Use First Row as Headers",{{"CustomerID", Int64.Type}, {"CustomerName", type text}, {"Region", type text}}),
    #"Removed Duplicates" = Table.Distinct(#"Change Type", {"CustomerID"}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Removed Duplicates",{{"CustomerName", Text.Proper, type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Capitalized Each Word",{{"CustomerName", Text.Trim, type text}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Trimmed Text", "CustomerName", Splitter.SplitTextByEachDelimiter({" "}, QuoteStyle.Csv, false), {"CustomerName.1", "CustomerName.2"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Split Column by Delimiter",{{"CustomerName.1", type text}, {"CustomerName.2", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"CustomerName.1", "First Name"}, {"CustomerName.2", "Last Name"}}),
    #"Cleaned Text" = Table.TransformColumns(#"Renamed Columns",{{"Region", Text.Clean, type text}}),
    #"Replaced Value" = Table.ReplaceValue(#"Cleaned Text"," ","",Replacer.ReplaceText,{"Region"}),
    #"Capitalized Each Word1" = Table.TransformColumns(#"Replaced Value",{{"Region", Text.Proper, type text}})
in
    #"Capitalized Each Word1"
