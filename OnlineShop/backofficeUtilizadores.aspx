<%@ Page Title="" Language="C#" MasterPageFile="~/backoffice.Master" AutoEventWireup="true" CodeBehind="backofficeUtilizadores.aspx.cs" Inherits="OnlineShop.backofficeUtilizadores" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <script>
        $(function () {
            $('[data-toggle="tooltip"]').tooltip()
        })
    </script>


    <style>

        th{
            text-align: center; 
            vertical-align: middle;
        }

        td{
            text-align: center; 
            vertical-align: middle;
        }

        #iconsave:hover{
            color: orange;
        }

        #icontrash:hover{
            color:red;
        }

    </style>




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



                     <div class="container col-lg-12 mt-5">


                               <div class="mb-2 col-lg-1212">
                                    <asp:LinkButton ID="link_botaoInserir" class="btn btn-warning float-lg-right" runat="server" data-toggle="modal" data-target="#exampleModal">Adicionar Utilizador <i class="fas fa-plus"></i></asp:LinkButton>
                                </div>

                        <div class="card mb-4 mt-5 shadow-lg mt-2">
                            <div class="card-header bg-dark text-center text-light">
                                <i class="fas fa-users"></i>
                                Utilizadores
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Nome</th>
                                                <th>Email</th>
                                                <th>Empresa</th>
                                                <th>NIF</th>
                                                <th>Activo</th>
                                                <th>Tipo</th>
                                                <th>Pedido Rev.</th>
                                                <th class="text-hide"></th>
                                                <th class="text-hide"></th>
                                            </tr>
                                        </thead>
                                        
                                       

                                        <tbody>

                                         <!-- Utilizadores -->
                                            <asp:Repeater ID="rpt_utilizador" runat="server" DataSourceID="utilizadorSqlSource" OnItemCommand="rpt_utilizador_ItemCommand" OnItemDataBound="rpt_utilizador_ItemDataBound">

                                            <ItemTemplate>

                                             <tr>

                                                <td>
                                                    <asp:TextBox ID="txt_nome" style="text-align: center" runat="server" BorderStyle="None"></asp:TextBox>
                                                    <h6 class="text-hide" style="margin-bottom: -5px;"><%# Eval("nome") %></h6>
                                                </td>

                                                <td>
                                                    <asp:TextBox ID="txt_email" style="text-align: center" runat="server" BorderStyle="None"></asp:TextBox>
                                                    <h6 class="text-hide" style="margin-bottom: -5px;"><%# Eval("email") %></h6>
                                                </td>

                                                <td>
                                                    <asp:TextBox ID="txt_empresa" style="text-align: center" runat="server" BorderStyle="None"></asp:TextBox>
                                                    <asp:Label class="text-hide" ID="lbl_empresa" runat="server" Text=""></asp:Label>
                                                </td>

                                                <td>
                                                    <asp:TextBox ID="txt_nif" style="text-align: center" runat="server" BorderStyle="None"></asp:TextBox>
                                                    <asp:Label class="text-hide" ID="lbl_nif" runat="server" Text=""></asp:Label>
                                                </td>

                                                <td>
                                                     <h1 class="text-hide" style="margin-bottom: -5px;"><%# Eval("activo") %></h1> <!-- apenas para o filtro -->  
                                                    <asp:CheckBox ID="ck_activo" class="form-check-input" Checked='<%# Eval("activo") %>' runat="server" />
                                                </td>

                                                <td>
                                                    <h1 class="text-hide"><%# Eval("descricao") %></h1> <!-- apenas para o filtro -->  
                                                    <asp:DropDownList class="form-control" Width="120px" style="margin-bottom: -5px; margin-top:-10px" ID="ddl_updateCategoria" runat="server" DataSourceID="categoriaSqlSource" DataTextField="descricao" DataValueField="ID"></asp:DropDownList>
                                                </td>

                                                 <td>
                                                     <asp:Label ID="lbl_pendeteRevenda" runat="server" Text=""></asp:Label>
                                                 </td>
                                                
                                                <td> <!-- Editar o utilizador -->
                                                    <asp:LinkButton ID="link_editar" CommandName="link_editar" CommandArgument='<%# Eval("ID") %>' class="btn btn-sm" runat="server"><i id="iconsave" class="fas fa-sd-card"></i></asp:LinkButton>
                                                </td>

                                                <td>
                                                    <asp:LinkButton ID="link_eliminar" CommandName="link_eliminar" CommandArgument='<%# Eval("ID") %>' class="btn btn-sm" runat="server"> <i id="icontrash" class="fas fa-trash"></i></asp:LinkButton>
                                                </td>

                                            </tr>



                                            </ItemTemplate>

                                            </asp:Repeater>
                                          
                                        
                                        <!-- /Utilizadores -->     

                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>



 <div class="modal fade ml-5" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg shadow-lg" role="document">
    <div class="modal-content">
      <div class="modal-header py-3 modal-title bg-dark rounded-top text-light">
        <h5 class=" modal-title text-center" id="exampleModalLabel">Inserção de Utilizadores</h5>
        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">



    <!-- START CONTENT -->
       
     <div class="form-row"> 

    <div class="form-group col-md-6">
      <label for="tb_nomeCompleto">Nome Completo</label>
          <asp:TextBox ID="tb_nomeCompleto" class="form-control" runat="server" placeholder="Nome Completo"></asp:TextBox>
    </div>

   <div class="form-group col-md-6">
      <label for="tb_email">Email</label>
       <asp:TextBox ID="tb_email" class="form-control" runat="server" placeholder="Email"></asp:TextBox>
    </div>
  </div>

  <div class="form-group">
    <label for="tb_morada">Morada</label>
     <asp:TextBox ID="tb_morada" class="form-control" runat="server" placeholder="Morada"></asp:TextBox>
  </div>
 
  <div class="form-row" id="divrevenda">

    <div class="form-group col-md-6">
      <label for="tb_empresa">Empresa</label>
      <asp:TextBox ID="tb_empresa" class="form-control" runat="server" placeholder="Empresa"></asp:TextBox>
    </div>

    <div class="form-group col-md-6">
      <label for="tb_nif">NIF</label>
      <asp:TextBox ID="tb_nif" class="form-control" runat="server" placeholder="NIF"></asp:TextBox>
    </div>

  </div>


  <div class="form-row">

    <div class="form-group col-md-6">
      <button type="button" class="btn btn-secondary btn-danger" style="margin-top: 2em" data-dismiss="modal">Cancelar</button>
      <asp:LinkButton ID="link_inserirUtilizador" class="btn btn-primary btn-dark w-50 ml-3" style="margin-top: 2em" runat="server" OnClick="link_inserirUtilizador_Click">Inserir</asp:LinkButton>
    </div>

    <div class="form-group col-md-6">
        <label for="ddl_tipoUtilizador">Tipo Utilizador</label>
        <asp:DropDownList ID="ddl_tipoUtilizador" class="form-control" runat="server" DataSourceID="categoriaSqlSource" DataTextField="descricao" DataValueField="ID"></asp:DropDownList>
     </div>

  </div>
  
          <!-- END CONTENT -->

            </div>
        </div>
    </div>
</div>

    <asp:SqlDataSource ID="utilizadorSqlSource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="select * from utilizador inner join tipoUtilizador on utilizador.idUtilizador = tipoUtilizador.id where utilizador.id != 1"></asp:SqlDataSource>
    <asp:SqlDataSource ID="categoriaSqlSource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="select * from tipoUtilizador"></asp:SqlDataSource>
</asp:Content>
