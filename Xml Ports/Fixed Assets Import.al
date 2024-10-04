xmlport 52178703 "Fixed Assets Import"
{
    Caption = 'Import Fixed Assets';
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    DefaultFieldsValidation = false;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(fa; "Fixed Asset")
            {

                fieldelement(No; fa."No.")
                {
                }
                fieldelement(Description; fa.Description)
                {
                }
                fieldelement(FAClassCode; fa."FA Class Code")
                {
                }
                fieldelement(FASubclassCode; fa."FA Subclass Code")
                {
                }
                fieldelement(SerialNo; fa."Serial No.")
                {
                }
                fieldelement(TagNo; fa."Tag No")
                {
                }


            }
        }
    }
}