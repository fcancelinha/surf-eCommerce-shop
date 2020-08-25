<%@ Page Title="" Language="C#" MasterPageFile="~/backoffice.Master" AutoEventWireup="true" CodeBehind="backofficeProdutos.aspx.cs" Inherits="OnlineShop.backofficeProdutos" ValidateRequest="false"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <script>

        function openModal() { $('#modal-update-product').modal('show'); }

    </script>


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



    <script src="ckeditor/ckeditor.js"></script> <!-- CK EDITOR SCRIPT -->


    <!-- Botão inserir -->

                            <div class="container col-lg-12 mt-5">
                                <div class="form-group">
                                  <asp:LinkButton ID="link_botaoInserir" class="btn btn-warning float-lg-right" runat="server" data-toggle="modal" data-target="#exampleModal">Adicionar Produto <i class="fas fa-plus"></i></asp:LinkButton>
                                </div>
                             </div>



    <!-- TABELA PRODUTOS -->
    
                       <div class="container col-lg-12 mt-2">
                        <div class="card mb-4 mt-2 shadow-lg">
                            <div class="card-header bg-dark text-center text-light">
                               <i class="fas fa-warehouse"></i>
                                Produtos
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table" id="dataTable">

                                        <thead>
                                            <tr>
                                                <th style="text-align: center; vertical-align: middle;">ID</th>
                                                <th style="text-align: center; vertical-align: middle;">Imagem</th>
                                                <th style="text-align: center; vertical-align: middle;">Titulo</th>
                                                <th style="text-align: center; vertical-align: middle;">Preco</th>
                                                <th style="text-align: center; vertical-align: middle;">Categoria</th>
                                                <th class="text-hide"></th>
                                                <th class="text-hide"></th>
                                            </tr>
                                        </thead>
                                           

                                        <tbody class="text-center text-md-center">

                                         <!-- Produto -->
                                            <asp:Repeater ID="rpt_backofficeProduto" runat="server" DataSourceID="produtosSQLSource" OnItemCommand="rpt_backofficeProduto_ItemCommand" OnItemDataBound="rpt_backofficeProduto_ItemDataBound">

                                                <ItemTemplate>

                                             <tr>

                                                <td style="text-align: center; vertical-align: middle;">
                                                    <%# Eval("ID") %>
                                                </td>

                                                <td style="text-align: center; vertical-align: middle;">
                                                    <img src="<%# "data:image;base64," + Convert.ToBase64String((byte[])Eval("imagem")) %>" alt="" width="70" class="img-fluid rounded align-middle">
                                                </td>

                                                <td style="text-align: center; vertical-align: middle;">
                                                    <%# Eval("titulo") %>
                                                </td>

                                                <td style="text-align: center; vertical-align: middle;">
                                                   <%# Eval("preco") %> €
                                                </td>

                                                <td style="text-align: center; vertical-align: middle;">
                                                    <%# Eval("descricao1") %>
                                                </td>

                                                <td style="text-align: center; vertical-align: middle;">
                                                    <asp:LinkButton ID="lb_openModalUpdate" OnClick="lb_openModalUpdate_Click" class="btn btn-sm" CommandName="lb_openModalUpdate" CommandArgument='<%# Eval("ID") %>' runat="server" CausesValidation="false"><i id="produpdate" class="fas fa-pen"></i></asp:LinkButton>
                                                </td>

                                                <td style="text-align: center; vertical-align: middle;">
                                                    <asp:LinkButton ID="link_delete" CommandName="link_delete" class="btn btn-sm" runat="server"><i id="prodtrash" class="fas fa-trash"></i></asp:LinkButton>
                                                </td>

                                            </tr>

                                                </ItemTemplate>
                                      

                                            </asp:Repeater>
                                           
                                        
                                        <!-- /Produto -->     
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>




    <!-- UPDATE DE PRODUTOS -->



<!-- Modal -->

<div class="modal fade ml-5" id="modal-update-product" tabindex="-1" role="dialog" aria-labelledby="modal-update-product" aria-hidden="true">
  <div class="modal-dialog modal-lg shadow-lg" role="document">
    <div class="modal-content">
      <div class="modal-header py-3 modal-title bg-dark rounded-top text-light">
        <h5 class=" modal-title text-center" id="modal-update-label">Inserção de Produtos</h5>
        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">



    <!-- END CONTENT -->
       
   <div class="p-4">
     <div class="form-row"> <!-- Titulo e Imagem -->
      
      <div class="form-group col-md-6">
        <label for="tb_updateTitulo">Titulo</label>
        <input type="text" class="form-control" runat="server" id="tb_updateTitulo" placeholder="Titulo" required>
      </div>

     <div class="form-group col-md-6" style="margin-top: 2em">
         <asp:FileUpload ID="fl_updateUpload" runat="server"/>
     </div>  
     
     </div>
                   
    <div class="form-row mt-1"> <!-- Descricão -->

        <div class="col-lg-12">
            <label for="tb_updateDescricao">Descrição</label>
            <textarea class="form-control" id="tb_updateDescricao" runat="server" rows="4" required></textarea>
              <script type="text/javascript">

                  CKEDITOR.replace('<%=tb_updateDescricao.ClientID%>', { customConfig: 'custom/menu.js' });

              </script>
        </div>

    </div>

    <div class="form-row mt-4"> <!-- Resumo -->

        <div class="col-lg-12">
            <label for="tb_updateResumo">Resumo</label>
            <input class="form-control" runat="server" type="text" id="tb_updateResumo" required/>
        </div>

    </div>

    <div class="form-row mt-1"> <!-- Detalhe#1 || Detalhe#2 -->

        <div class="col">
            <label for="tb_updateDetalhe1">Detalhe #1</label>
            <input class="form-control" runat="server" type="text" id="tb_updateDetalhe1" required/>
        </div>

         <div class="col">
            <label for="tb_updateDetalhe2">Detalhe #2</label>
            <input class="form-control" runat="server" type="text" id="tb_updateDetalhe2" required/>
        </div>

    </div>

    <div class="form-row mt-1"> <!-- Preço || Categoria -->

        <div class="col">

            <label for="tb_updatePreco">Preço</label>
                <div class="input-group">
                    <div class="input-group-append">
                        <span class="input-group-text" id="inputGroupPrepend3">€</span>
                    </div>
                <input type="number" class="form-control" runat="server" id="tb_updatePreco" aria-describedby="inputGroupPrepend3" required>
            </div>

        </div>

        <div class="col">
            <label for="ddl_updateCategoria">Categoria</label>
            <asp:DropDownList class="form-control" ID="ddl_updateCategoria" runat="server" DataSourceID="categoriaSQLsource" DataTextField="descricao" DataValueField="ID"></asp:DropDownList>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="SELECT * FROM [categoria]"></asp:SqlDataSource>
        </div>

    </div>

    <div class="form-row mt-4">
        <div class="col text-center">
             <asp:LinkButton ID="link_updateProduct" CommandName="link_updateProduct" class="btn btn-primary btn-dark w-25 mr-1" type="submit" runat="server" OnClick="link_updateProduct_Click" >Actualizar</asp:LinkButton>
             <button type="button" class="btn btn-secondary btn-danger" data-dismiss="modal">Cancelar</button>
        </div>
    </div>   
  </div>

          <!-- END CONTENT -->

      </div>
    </div>
  </div>
</div>

<!-- / Modal -->


<!-- INSERÇÃO DE PRODUTOS -->


<!-- Modal -->
<div class="modal fade ml-5" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg shadow-lg" role="document">
    <div class="modal-content">
      <div class="modal-header py-3 modal-title bg-dark rounded-top text-light">
        <h5 class=" modal-title text-center" id="exampleModalLabel">Inserção de Produtos</h5>
        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">



    <!-- END CONTENT -->
       
   <div class="p-4">
     <div class="form-row"> <!-- Titulo e Imagem -->
      
      <div class="form-group col-md-6">
        <label for="tb_titulo">Titulo</label>
        <asp:TextBox class="form-control" ID="tb_titulo" runat="server" placeholder="Titulo" ValidationGroup="inserirProduto" MaxLength="100"></asp:TextBox>
      </div>

     <div class="form-group col-md-6" style="margin-top: 2em">
         <asp:FileUpload ID="fl_produtoImagem" runat="server"/>
     </div>  
     
     </div>
                   
    <div class="form-row mt-1"> <!-- Descricão -->

        <div class="col-lg-12">
            <label for="tb_descricao">Descrição</label>
            <asp:TextBox class="form-control" ID="tb_descricao" runat="server" placeholder="Descrição" ValidationGroup="inserirProduto" TextMode="MultiLine" Rows="3"></asp:TextBox>
              <script type="text/javascript">


                  CKEDITOR.replace('<%=tb_descricao.ClientID%>', { customConfig: 'custom/menu.js' });



              </script>
        </div>

    </div>

    <div class="form-row mt-4"> <!-- Resumo -->

        <div class="col-lg-12">
            <label for="tb_resumo">Resumo</label>
            <asp:TextBox class="form-control" ID="tb_resumo" runat="server" placeholder="Resumo" ValidationGroup="inserirProduto"></asp:TextBox>
        </div>

    </div>

    <div class="form-row mt-1"> <!-- Detalhe#1 || Detalhe#2 -->

        <div class="col">
            <label for="tb_resumo">Detalhe #1</label>
            <asp:TextBox class="form-control" ID="tb_detalhe1" runat="server" placeholder="Detalhe" ValidationGroup="inserirProduto" MaxLength="100"></asp:TextBox>
        </div>

         <div class="col">
            <label for="tb_resumo">Detalhe #2</label>
             <asp:TextBox class="form-control" ID="tb_detalhe2" runat="server" placeholder="Detalhe" ValidationGroup="inserirProduto" MaxLength="100"></asp:TextBox>
        </div>

    </div>

    <div class="form-row mt-1"> <!-- Preço || Categoria -->

        <div class="col">

            <label for="tb_preco">Preço</label>
                <div class="input-group">
                    <div class="input-group-append">
                        <span class="input-group-text" id="inputGroupPrepend2">€</span>
                    </div>
                 <asp:TextBox class="form-control" ID="tb_preco" runat="server" placeholder="Preço" aria-describedby="inputGroupPrepend2" TextMode="Number" ValidationGroup="inserirProduto"></asp:TextBox>
            </div>

        </div>

        <div class="col">
            <label for="ddl_categoria">Categoria</label>
            <asp:DropDownList class="form-control" ID="ddl_categoria" runat="server" DataSourceID="categoriaSQLsource" DataTextField="descricao" DataValueField="ID"></asp:DropDownList>
            <asp:SqlDataSource ID="categoriaSQLsource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="SELECT * FROM [categoria]"></asp:SqlDataSource>
        </div>

    </div>

    <div class="form-row mt-4">
        <div class="col text-center">
             <asp:LinkButton ID="link_inserir" class="btn btn-primary btn-dark w-25 mr-1" type="submit" runat="server" OnClick="link_inserir_Click" ValidationGroup="inserirProduto">Inserir</asp:LinkButton>
             <button type="button" class="btn btn-secondary btn-danger" data-dismiss="modal">Cancelar</button>
        </div>
    </div>   
  </div>

          <!-- END CONTENT -->

      </div>
    </div>
  </div>
</div>

<!-- / Modal -->


  


    <asp:SqlDataSource ID="produtosSQLSource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="select * from produto inner join categoria on produto.IDcategoria = categoria.ID"></asp:SqlDataSource>


</asp:Content>
