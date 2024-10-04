report 52178809 "Proc-Contracts Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './procurement/reportlayouts/procContracts.rdl';

    dataset
    {
        dataitem(procContracys; "Proc-Contracts")
        {
            column(ContractCode_procContracys; "Contract Code")
            {
            }
            column(ContractDate_procContracys; "Contract Date")
            {
            }
            column(ContactPerson_procContracys; "Contact Person")
            {
            }
            column(ContractName_procContracys; "Contract Name")
            {
            }
            column(ContractPeriod_procContracys; "Contract Period")
            {
            }
            column(ContractStatus_procContracys; "Contract Status")
            {
            }
            column(DVCAdminEmail_procContracys; "DVC Admin Email")
            {
            }
            column(LegalDepartmentEmail_procContracys; "Legal Department E-mail")
            {
            }
            column(CancelationReason_procContracys; "Cancelation Reason")
            {
            }
            column(ServiceDescription_procContracys; "Service Description")
            {
            }
            column(ServiceProvider_procContracys; "Service Provider")
            {
            }
            column(ServiceProviderName_procContracys; "Service Provider Name")
            {
            }
            column(SuplierTelephone_procContracys; "Suplier Telephone")
            {
            }
            column(SupplierEMail_procContracys; "Supplier E-Mail")
            {
            }
            column(Requisition_Date;"Requisition Date")
            {

            }
            column(Requestor_Id;"Requestor Id")
            {
                
            }
            column(CompName;CompanyInformation.Name)
            {

            }
            column(pic;CompanyInformation.Picture)
            {

            }
           
        }
    }

    requestpage
    {
        layout
        {

        }

        actions
        {

        }
    }


    trigger OnInitReport()
    begin
        if CompanyInformation.Get() then begin
            CompanyInformation.CalcFields(CompanyInformation.Picture);
        end;
    end;

    var
        myInt: Integer;
        CompanyInformation: Record "Company Information";
}