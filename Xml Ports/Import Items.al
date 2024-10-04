xmlport 52178700 "Import Items"
{
    Caption = 'Import Items';
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    DefaultFieldsValidation = false;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(Item; Item)
            {
                fieldattribute("No."; Item."No.")
                {
                }
                fieldattribute(Name; Item.Description)
                {
                }
                fieldattribute(UnitOfMeasure; Item."Base Unit of Measure")
                {
                }
                fieldattribute(InventoryPostingGroup; Item."Inventory Posting Group")
                {
                }
                fieldattribute(GenProductPostingGroup; Item."Gen. Prod. Posting Group")
                {
                }


                // trigger OnBeforeInsertRecord()
                // begin
                //     if Item."No." = '' then
                //         currXMLport.Skip();

                //     Counter := Counter + 1;
                //     Window.Update(1, Item.Description);
                //     Window.Update(2, Counter);
                // end;

            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        //Temporary
        Item.Reset();
        Item.DeleteAll();
        //

        Window.Open('Importing Item', Desc, Counter);
    end;

    var
        Window: Dialog;
        Desc: Text;

        Counter: Integer;
}