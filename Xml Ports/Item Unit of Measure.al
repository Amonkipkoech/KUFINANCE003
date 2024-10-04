xmlport 52178702 "Item Unit of measure"
{
    Caption = 'Import Unit of measure';
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    DefaultFieldsValidation = false;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(UnitMeasure; "Item Unit of Measure")
            {
                fieldattribute(Item; UnitMeasure."Item No.")
                {

                }
                fieldattribute(Code; UnitMeasure.Code)
                {

                }
            }
        }
    }
}