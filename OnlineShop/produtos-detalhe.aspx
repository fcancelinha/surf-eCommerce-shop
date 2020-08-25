<%@ Page Title="" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="produtos-detalhe.aspx.cs" Inherits="OnlineShop.produtos_detalhe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



      <!-- Page Content -->
  <div class="container">

    <!-- Page Heading/Breadcrumbs -->
    <h1 class="mt-4 mb-3">Detalhe do Produto</h1>

    <ol class="breadcrumb bg-white">
      <li class="breadcrumb-item">
        <a href="frontpage.aspx">Home</a>
      </li>
      <li class="breadcrumb-item active">Detalhe</li>
    </ol>

    <!-- Portfolio Item Row -->
    <div class="row">

      <div class="col-md-8">
          <asp:Image class="img-fluid" ID="control_image" alt="" runat="server"/>
      </div>

      <div class="col-md-4 mt-5">
        <h3 id="control_tituloProduto" runat="server" class="my-3 text-dark"></h3>
          <asp:Literal ID="control_resumoProduto" runat="server"></asp:Literal>
        <h3 class="my-3 mt-3 text-dark">Detalhes</h3>
        <ul>
          <li id="control_detalhe1" runat="server"></li>
          <li id="control_detalhe2" runat="server"></li>
        </ul>

          <br />
           <h6 class="text-dark small badge badge-warning" id="control_categoriaProduto" runat="server"></h6>
          <br />
          
        <div class="row">
          <div class="col-6">
                 <h5 class="text-dark mt-2" id="control_precoProduto" runat="server"></h5>
          </div>
           
           <div class="col-2">
                <asp:LinkButton ID="link_adicionarItem" class="btn btn-warning" runat="server" OnClick="link_adicionarItem_Click"><i class="fas fa-cart-plus"></i></asp:LinkButton>
          </div>
        </div>

        </div>
    </div>
    <!-- /.row -->

    <!-- Related Projects Row -->
    <h3 class="my-4">Produtos Relacionados</h3>

    <div class="row">


        <asp:Repeater ID="rpt_produtoRelacionado" runat="server" DataSourceID="detalheSQLSource">

            <ItemTemplate>

                 <div class="col-md-3 col-sm-6 mb-4 text-center">
                  
                    <a href="produtos-detalhe.aspx?prod=<%# Eval("ID") %>">
                        <img class="img-fluid" src="<%# "data:image;base64," + Convert.ToBase64String((byte[])Eval("imagem")) %>" alt="">
                   </a>
                 <h5 class="my-3 text-dark"><%# Eval("titulo") %></h5>
                  <h6 class="my-3 text-dark"><%# Eval("preco") %>€</h6>
                </div>

            </ItemTemplate>

        </asp:Repeater>

    </div>
    <!-- /.row -->
  </div>
  <!-- /.container -->

    <asp:SqlDataSource ID="detalheSQLSource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="produtoRelacionado" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter Name="ID" QueryStringField="prod" Type="Int32" />
        </SelectParameters>
      </asp:SqlDataSource>
</asp:Content>
