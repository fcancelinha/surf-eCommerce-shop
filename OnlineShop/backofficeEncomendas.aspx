<%@ Page Title="" Language="C#" MasterPageFile="~/backoffice.Master" AutoEventWireup="true" CodeBehind="backofficeEncomendas.aspx.cs" Inherits="OnlineShop.backofficeEncomendas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">




        <style>

        #prodtrash:hover{
            color: darkred;
        }

        #produpdate:hover{
            color: orange;
        }

       
        </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


            <main>
                    <div class="container-fluid">
                        <div class="row mt-4">
                            <div class="col-xl-4 col-lg-12 col-md-12">
                                <div class="card bg-dark text-white mb-4 d-flex justify-content-center">
                                    <div class="card-body"><i class="fas fa-users h3 mr-3"></i><span class="mr-2">Utilizadores</span> <asp:Label ID="lbl_nrutilizadores" class="h5 font-weight-bold" runat="server" Text=""></asp:Label></div>
                                </div>
                            </div>
                            <div class="col-xl-4 col-md-6">
                                <div class="card bg-warning text-white mb-4  d-flex justify-content-center">
                                    <div class="card-body"><i class="fas fa-warehouse h3 mr-3"></i><span class="mr-2">Produtos</span><asp:Label ID="lbl_nrprodutos" class="h5 font-weight-bold" runat="server" Text=""></asp:Label></div>
                                </div>
                            </div>
                            <div class="col-xl-4 col-md-6">
                                <div class="card bg-warning text-white mb-4 d-flex justify-content-center">
                                    <div class="card-body"><i class="fas fa-box h3 mr-3"></i><span class="mr-2">Encomendas</span><asp:Label ID="lbl_nrencomendas" class="h5 font-weight-bold" runat="server" Text=""></asp:Label></div>
                                </div>
                            </div>
                         
                        </div>

                        <div class="card mb-4">
                            <div class="card-header text-center bg-dark text-light">
                                <i class="fas fa-box"></i>
                                Encomendas
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-borderless" id="dataTable">
                                        <thead class="bg-white text-center">
                                            <tr>
                                                <th>Data Compra</th>
                                                <th>Cliente</th>
                                                <th>Morada</th>
                                                <th># Produtos</th>
                                                <th>Total</th>
                                                <th>Estado</th>
                                                <th class="text-hide"></th>
                                                <th class="text-hide"></th>
                                            </tr>
                                        </thead>
                                        

                                        <tbody>

                                         <!-- ENCOMENDAS -->
                                        <asp:Repeater ID="rpt_encomendas" runat="server" DataSourceID="SqlSourceEncomendas" OnItemCommand="rpt_encomendas_ItemCommand" OnItemDataBound="rpt_encomendas_ItemDataBound">
                                        <ItemTemplate>

                                            <tr class="text-center">
                                                <td><%# Eval("Data") %></td>
                                                <td><%# Eval("nome") %></td>
                                                <td><%# Eval("morada") %></td>
                                                <td><%# Eval("Qtd") %></td>
                                                <td><%# Eval("Total") %> €</td>
                                                <td>
                                                    <asp:DropDownList ID="ddl_estado" runat="server" class="form-control border-white btn-outline-dark" DataSourceID="EstadoEncomendaSqlSource" DataTextField="estado" DataValueField="id"></asp:DropDownList>
                                                </td>
                                                 <td style="text-align: center; vertical-align: middle;">
                                                    <asp:LinkButton ID="bt_save" class="btn btn-sm" CommandName="bt_save" runat="server" CausesValidation="false"><i id="produpdate" class="fas fa-pen"></i></asp:LinkButton>
                                                </td>

                                                <td style="text-align: center; vertical-align: middle;">
                                                    <asp:LinkButton ID="bt_delete" CommandName="bt_delete" class="btn btn-sm" runat="server"><i id="prodtrash" class="fas fa-trash"></i></asp:LinkButton>
                                                </td>
                                            </tr>

                                        </ItemTemplate>
                                        </asp:Repeater>
                                        <!-- /ENCOMENDAS -->     

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
         

    
    <asp:SqlDataSource ID="EstadoEncomendaSqlSource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="SELECT * FROM [estadoEncomenda]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlSourceEncomendas" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="selectEncomendaBackoffice" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
</asp:Content>
