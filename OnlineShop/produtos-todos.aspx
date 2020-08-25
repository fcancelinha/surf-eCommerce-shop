<%@ Page Title="" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="produtos-todos.aspx.cs" Inherits="OnlineShop.produtos_todos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <style>

        #alert-popup{
            position:fixed;
            bottom:0;
            margin-bottom: 30px;
            margin-left: 30em;
            display: none;
        }

    </style>


    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <asp:UpdatePanel ID="ProdutosUpdate" runat="server" UpdateMode="Conditional">
        <ContentTemplate>


    <!-- Page Content -->
  <div class="container">

       <div class="row">
       
          <div class="col-lg-12 text-center">
                <h1 class="my-1 mt-5 text-dark">Produtos</h1><br />
          <asp:Label ID="lbl_categoriaPagina" class="text-muted text-monospace h4" runat="server" Text="Todos"></asp:Label>

        </div>

        <!-- Filtros -->
    <div class="col-lg-5 text-center">
        <h5 class="mb-3 mt-5 text-dark text-monospace">Filtros</h5>
            
       <div class="d-flex justify-content-between">

          <asp:LinkButton class="btn btn-light ml-3" style="margin-bottom: 35px; cursor: pointer" ID="link_resetFilter" runat="server" OnClick="link_resetFilter_Click">
               <i class="far fa-minus-square" ></i>
           </asp:LinkButton>
          

        <div class="dropdown mb-4 w-100" style="margin-left: -10px">
            <button class="btn dropdown-toggle border-dark w-75 text-dark text-monospace" runat="server" type="button" id="ddl_filtros" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Ordenação por
            </button>
             <div class="dropdown-menu w-75" aria-labelledby="dropdownMenuButton">
                 <asp:LinkButton class="dropdown-item" style="cursor:pointer" ID="link_az" runat="server" OnClick="link_filtragem">A - Z</asp:LinkButton>
                 <asp:LinkButton class="dropdown-item" style="cursor:pointer" ID="link_za" runat="server" OnClick="link_filtragem">Z - A</asp:LinkButton>
                 <asp:LinkButton class="dropdown-item" style="cursor:pointer" ID="link_precoAscendente" runat="server" OnClick="link_filtragem">Preço: Ascedente</asp:LinkButton>
                 <asp:LinkButton class="dropdown-item" style="cursor:pointer" ID="link_precoDescendente" runat="server" OnClick="link_filtragem">Preço: Descendente</asp:LinkButton>
            </div>
        </div>

       </div> 
              

    </div>


    <div class="col-lg-7 mt-5">
        <h5 class="text-dark text-center text-monospace">Categorias</h5>

        <div class="col-lg-12 d-flex justify-content-around">
          
          <asp:LinkButton class="mt-2 text-light btn btn-dark" style="cursor:pointer; text-decoration:none; width: 10em;" ID="link_categoriaPranchas" runat="server" OnClick="link_filtragem">
              Pranchas
          </asp:LinkButton>
            
          <asp:LinkButton class="mt-2 text-light btn btn-dark" style="cursor:pointer; text-decoration:none; width: 10em;" ID="link_categoriaFatos" runat="server" OnClick="link_filtragem">
              Fatos
          </asp:LinkButton>
            
          <asp:LinkButton  class="mt-2 text-light btn btn-dark" style="cursor:pointer; text-decoration:none; width: 10em;" ID="link_categoriaRoupa" runat="server" OnClick="link_filtragem">
              Roupa
          </asp:LinkButton>
            
        </div>
    </div>

        <!-- //Categorias -->
     


    <div class="col-lg-12">
        <br />
        <br />

    <div class="row">      
        
        <asp:Repeater ID="rpt_produto" runat="server" OnItemDataBound="rpt_produto_ItemDataBound" OnItemCommand="rpt_produto_ItemCommand" DataSourceID="SQLtesting">
            <ItemTemplate>

            <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12 portfolio-item">
              <div class="card h-100 border-white">
                <a href="produtos-detalhe.aspx?prod=<%# Eval("ID") %>"><img class="img-fluid card-img card-img-top" alt="#" src="<%# "data:image;base64," + Convert.ToBase64String((byte[])Eval("imagem")) %>"/></a>
                 <div class="card-body">
                <h5 class="card-title text-center">
                    <a href="produtos-detalhe.aspx?prod=<%# Eval("ID") %>" class="text-dark"><%# Eval("titulo") %></a>
                </h5>
                 <h6 class="card-text text-muted text-center align-middle"><%# Eval("resumo") %></h6>
             
                <div class="card-footer bg-transparent">

                    <div class="row d-flex d-inline-block">
                        <div class="col-xl-10 col-lg-8 col-md-8 col-sm-10 col-10">
                          <asp:Label ID="lbl_preco" class="card-text text-left" runat="server" Font-Bold="true" Text=""></asp:Label><br />
                           <h6 class="card-subtitle mb-2 text-white small badge badge-warning text-right"><%# Eval("descricao") %></h6>
                        </div>

                        <div class="col-xl-2 col-lg-4 col-md-4 col-sm-2 col-2">
                            <asp:LinkButton ID="bt_adicionarCarrinho" CommandName="bt_adicionarCarrinho" class="btn btn-warning btn-sm text-right mt-2" runat="server"><i class="fas fa-cart-plus"></i></asp:LinkButton>
                        </div>
                            

                    </div>
                  
                 
                 </div>
                </div>
               </div>
              </div>

            </ItemTemplate>
        </asp:Repeater>

                </div>
            </div>
        </div>
    </div>
  <!-- /.container -->
 

<!-- PAGINAÇÃO -->
            <asp:Panel ID="pagePanel" class="col-lg-12 text-center mb-5" runat="server">

            </asp:Panel>
<!-- //PAGINAÇÃO -->


<!-- SEARCH -->

<asp:SqlDataSource ID="searchSqlSource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="searchItem" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:QueryStringParameter Name="search" QueryStringField="search" Type="String" />
    </SelectParameters>
</asp:SqlDataSource>

<!-- SQL PRODUCTS -->
<asp:SqlDataSource ID="SQLtesting" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="productsPaginatedFiltered" SelectCommandType="StoredProcedure">
    <SelectParameters>
        <asp:Parameter Name="Campo" Type="String" DefaultValue="Nome" />
        <asp:Parameter Name="Ordem" Type="String" DefaultValue="ASC" />
        <asp:Parameter Name="Categoria" Type="String" DefaultValue="Todos" />
        <asp:Parameter Name="Pagina" Type="Int32" DefaultValue="1" />
        <asp:Parameter Name="ItemsPagina" Type="Int32" DefaultValue="5" />
    </SelectParameters>
</asp:SqlDataSource>


</ContentTemplate>
  </asp:UpdatePanel>

</asp:Content>
