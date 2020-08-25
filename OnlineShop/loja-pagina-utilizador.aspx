<%@ Page Title="" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="loja-pagina-utilizador.aspx.cs" Inherits="OnlineShop.loja_pagina_utilizador" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <style>
        
    </style>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="container mt-5">

        <div class="row ">
            <div class="col-lg">
              <h1 class="text-muted  d-inline">Olá</h1><h3 class="ml-3 text-dark d-inline"><%= txt_nome.Text %></h3>
            </div>
        </div>
        

        <div class="row">
            <div class="col-lg-12">
                <asp:LinkButton ID="link_logout" class="btn-danger btn float-right btn-outline-light" runat="server" OnClick="link_logout_Click">Logout</asp:LinkButton>
            </div>
        </div>



         <!-- Alterar Password -->

        <div class="row justify-content-center">
            
            <div class="col-lg-4 mt-4">
                <div class="card shadow pb-4 bg-white">
                    <div class="card-body">

                        <h3 class="text-dark text-left">Alterar Password</h3>

                           <div class="form-row">

                                 <div class="col">
                                      <label for="lb_passwordAntiga">Password Antiga</label>
                                     <asp:TextBox type="password" ID="lb_passwordAntiga" runat="server" class="form-control" placeholder="*******" ValidationGroup="AlterarPassword"></asp:TextBox>
                                </div>
                            </div>

                             <div class="form-row">

                                <div class="col mt-3">
                                     <label for="lb_passwordNova">Password Nova</label>
                                    <asp:TextBox type="password" ID="lb_passwordNova" runat="server" class="form-control" placeholder="*******" ValidationGroup="AlterarPassword"></asp:TextBox>
                                 </div>
                              </div>
                                  
                            <div class="form-row">

                                  <div class="col mt-3">
                                       <label for="lb_passwordNovaRepetida">Repetir Password</label>
                                      <asp:TextBox type="password" id="lb_passwordNovaRepetida" runat="server" class="form-control" placeholder="*******" ValidationGroup="AlterarPassword"></asp:TextBox>
                                        <small id="passwordHelpBlock" class="form-text text-muted">
                                                8-20 caracteres, conter letras e numeros, um caracter especial e sem espaços
                                        </small>
                                  </div>

                             </div>

                
                        <div class="form-row mt-4">

                             <div class="col-md-8">
                                 <asp:Label ID="lbl_erro" runat="server" class="form-text text-dark" Font-Size="small" Text=""></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <asp:LinkButton ID="link_alterarPassword" class="btn btn-sm btn-danger btn-block" runat="server" OnClick="link_alterarPassword_Click" ValidationGroup="AlterarPassword">Alterar</asp:LinkButton>
                           </div> 

                       </div>

                    </div>
                </div>
            </div>

             <div class="col-lg-8 mt-4">
                <div class="card shadow bg-white pb-4">
                    <div class="card-body">
                        <h3 class="text-dark text-">Alterar Detalhes</h3>
    
    <!-- Alterar detalhes -->

   <div class="form-row">

    <div class="col-md-6 mb-3">
      <label for="txt_alteraNome">Nome</label>
        <asp:TextBox ID="txt_nome" class="form-control" runat="server" ValidationGroup="alteraDetalhes"></asp:TextBox>
    </div>

    <div class="col-md-6 mb-3">

           <label for="validationCustomUsername">Email</label>
                <div class="input-group">
                <div class="input-group-prepend">
                     <span class="input-group-text" id="inputGroupPrepend">@</span>
                </div>
                <asp:TextBox ID="txt_email" class="form-control" runat="server" ValidationGroup="alteraDetalhes" aria-describedby="inputGroupPrepend"></asp:TextBox>
            </div>
     
    </div>
  </div>

   <div class="form-row mb-3">
       <div class="col-md-12">
          <label for="txt_morada">Morada</label>
            <asp:TextBox ID="txt_morada" class="form-control" runat="server" ValidationGroup="alteraDetalhes"></asp:TextBox>
       </div>
   </div>

  <div class="form-row">
    <div class="col-md-6 mb-3">
      <label for="lb_empresa">Empresa</label>
      <asp:TextBox ID="txt_empresa" class="form-control" runat="server" ValidationGroup="alteraDetalhes"></asp:TextBox>
    </div>
    <div class="col-md-6 mb-3">
      <label for="lb_nif">NIF</label>
      <asp:TextBox ID="txt_nif" class="form-control" runat="server" ValidationGroup="alteraDetalhes"></asp:TextBox>
    </div>
  </div>
  
    <div class="form-row">

        <div class="col-md-6">

        </div>

        <div class="col-md-6">
            <asp:LinkButton ID="link_alterarDetalhes" class="btn btn-sm btn-dark mt-5 float-right w-50" runat="server" ValidationGroup="alteraDetalhes" OnClick="link_alterarDetalhes_Click">Alterar</asp:LinkButton>
        </div>
    </div>
   


                    </div>
                </div>
            </div>

        </div>


        <div class="row mb-5">

              <div class="col-lg-12 mt-4">
                <div class="card pb-4 shadow bg-white pb-5">
                    <div class="card-body">
                         <h3 class="card-title text-center p-2 text-dark bg-white">Encomendas</h3>
                            <div class="col-lg-12">
                           
 <table class="table table-borderless shadow text-center">
  <thead class="thead-dark small">
    <tr>
      <th>Data</th>
      <th>Qtd</th>
      <th>Total</th>
      <th>Estado</th>
      <th>Ver Encomenda</th>
    </tr>
  </thead>
  <tbody>

      <asp:Repeater ID="rptEncomendas" runat="server" DataSourceID="encomendasSQLsource" OnItemCommand="rptEncomendas_ItemCommand" OnItemDataBound="rptEncomendas_ItemDataBound">

          <ItemTemplate>

           <tr>
            <td><%# Eval("Data") %></td>
            <td><%# Eval("Qtd") %></td>
            <td><%# Eval("Total", "{0:F2}") %> €</td>
            <td class="badge badge-pill badge-dark text-light mt-1"><%# Eval("Estado") %></td>
            <td>
                <asp:LinkButton ID="link_pdf" CommandName="link_pdf" runat="server" class="text-dark">Ver Encomenda</asp:LinkButton></td>
           </tr>

          </ItemTemplate>

      </asp:Repeater>


  </tbody>
</table>



                       </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <asp:SqlDataSource ID="encomendasSQLsource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="selectEncomenda" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="IDcliente" SessionField="ID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
