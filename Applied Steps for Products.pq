// Products query - Power Query (M)
let
    Source = Csv.Document(File.Contents("<path-to-data>\Products.csv"),[Delimiter=",", Columns=4, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Use First Row as Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Replaced Value" = Table.ReplaceValue(#"Use First Row as Headers","Two Hundred","200",Replacer.ReplaceText,{"Price"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Replaced Value",{{"Price", Currency.Type}}),
    #"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"ProductName", Text.Trim, type text}, {"Category", Text.Trim, type text}}),
    #"Capitalized Each Word" = Table.TransformColumns(#"Trimmed Text",{{"ProductName", Text.Proper, type text}, {"Category", Text.Proper, type text}})
in
    #"Capitalized Each Word"
