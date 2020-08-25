<%@ Page Title="" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="checkout.aspx.cs" Inherits="OnlineShop.checkout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>

        #removeItem:hover{
            color: red;
        }

    </style>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="container ">
       <h1 class="mt-5 mb-3">Carrinho de Compras</h1>
    </div>

    <!-- CHECKOUT -->

    <div class="container">
      <div class="row">
        <div class="col-lg-12 p-5 bg-white shadow-sm mb-5">

          <!-- Shopping cart table -->
          <div class="table-responsive">
            <table class="table">
              <thead>
                <tr>
                  <th scope="col" class="border-0 rounded-left bg-dark text-center text-white">
                    <div class="p-1 px-2 text-capitalize">ID</div>
                  </th>
                  <th scope="col" class="border-0 bg-dark text-center text-white">
                    <div class="p-1 px-2 text-capitalize">Produto</div>
                  </th>
                  <th scope="col" class="border-0 bg-dark text-center text-white">
                    <div class="py-1 px-2 text-capitalize">Preço</div>
                  </th>
                  <th scope="col" class="border-0 bg-dark text-center text-white">
                    <div class="py-1 px-2 text-capitalize">Qtd</div>
                  </th>
                  <th scope="col" class="border-0 rounded-right bg-dark text-center text-white">
                    <div class="py-1 px-2 text-capitalize">Remover</div>
                  </th>
                </tr>
              </thead>

             <!-- FIM CABEÇALHO -->

              <tbody>


    <!-- CHECKOUT -->
                

                 

                  <asp:Repeater ID="rpt_checkout" runat="server" OnItemCommand="rpt_checkout_ItemCommand" OnItemDataBound="rpt_checkout_ItemDataBound" DataSourceID="checkoutSQLsource">

                      <ItemTemplate>

              <!-- INICIO DO PRODUTO -->

                <tr>
                  <td class="align-middle text-center">
                      <strong>
                          <label id="lbl_ID" runat="server" class="text-dark"><%# Eval("ID") %></label>
                      </strong>
                  </td>
                  
                    <th>

                    <div class="col align-content-left">
                      <img src="<%# "data:image;base64," + Convert.ToBase64String((byte[])Eval("imagem")) %>" alt="" width="90" class="align-middle">
                      <div class="ml-3 d-inline-block align-middle">
                        <h5 class="mb-0"><a href="produtos-detalhe.aspx?prod=<%# Eval("ID") %>" class="text-dark d-inline-block"><%# Eval("titulo") %></a></h5>
                          <h6><%# Eval("resumo") %></h6>
                          <h6 class="text-muted font-weight-normal font-italic d-inline-block text-center">Categoria: <span class="badge-warning rounded-pill m-1 pl-1 pr-1 text-light small"><%# Eval("descricao") %></span></h6>
                      </div>
                    </div>

                  </th>

                  <td class="align-middle text-center">
                      <asp:Label ID="lb_total" runat="server" Font-Bold="true" Text=""></asp:Label></td> <!-- Total -->
                  
                   <td class="align-middle text-center">
                       <asp:LinkButton ID="link_diminuirQtd" CommandName="link_diminuirQtd" CommandArgument='<%# Eval("ID") %>' class="btn-warning small p-2 mr-1 rounded" runat="server"><i class="fas fa-minus"></i></i></asp:LinkButton>
                       <asp:Label ID="lb_Qtd" runat="server" Font-Bold="true" Text='<%# Eval("Qtd") %>'></asp:Label>
                       <asp:LinkButton ID="link_AumentarQtd" CommandName="link_AumentarQtd" CommandArgument='<%# Eval("ID") %>' class="btn-warning small ml-1 p-2 rounded" runat="server"><i class="fas fa-plus"></i></asp:LinkButton>
                   </td> <!-- Qtd -->
                 
                   <td class="align-middle text-center">
                      <asp:LinkButton ID="bt_eliminaItem" class="text-dark" CommandName="bt_eliminaItem" style="cursor:pointer; background-color: transparent; border-color: transparent" runat="server"><i id="removeItem" class="fa fa-trash"></i>
                   </asp:LinkButton>
                </tr>
                
               <!-- FIM DO PRODUTO -->

                          <!-- LABELS PARA EFEITOS DO PDF -->
                          <asp:Label ID="pdf_titulo"          Visible="false" runat="server" Text='<%# Eval("titulo") %>'></asp:Label>
                          <asp:Label ID="pdf_quantidade"      Visible="false" runat="server" Text='<%# Eval("Qtd") %>'></asp:Label>
                          <asp:Label ID="pdf_resumo"          Visible="false" runat="server" Text='<%# Eval("resumo") %>'></asp:Label>
                          <asp:Label ID="pdf_precounitario"   Visible="false" runat="server" Text='<%# Eval("Unitario") %>'></asp:Label>
                          <asp:Label ID="pdf_precototal"      Visible="false" runat="server" Text='<%# Eval("total") %>'></asp:Label>
                          <!-- LABELS PARA EFEITOS DO PDF -->

                      </ItemTemplate>
                  </asp:Repeater>

       
              </tbody>
            </table>

              
          </div>
            <!-- GERAR PDF -->
                <div class="row">
                      <div class="col">
                          <asp:LinkButton ID="link_pdfEncomenda" class="btn btn-warning mt-4 float-right" runat="server" OnClick="link_pdfEncomenda_Click">Gerar PDF do Carrinho</asp:LinkButton>
                      </div>
                  </div>
         
          <!-- End -->
        </div>
      </div>
       

     <div class="row py-5 p-4 bg-white rounded shadow-sm">
    
        <!-- Detalhes da Encomenda -->
        <div class="col-lg-6">
          <div class="bg-dark rounded-pill text-center px-4 py-3 text-uppercase text-light">Detalhes da Encomenda</div>
          <div class="p-4">

  <div class="form-row">

    <div class="form-group col-md-6">
      <label for="txt_detalheNome">Nome</label>
        <asp:TextBox ID="txt_detalheNome" class="form-control" runat="server" placeholder="Nome" ></asp:TextBox>
    </div>

    <div class="form-group col-md-6">
      <label for="txt_detalheNIF">NIF</label>
        <asp:TextBox ID="txt_detalheNIF" class="form-control" runat="server" placeholder="NIF" disabled></asp:TextBox>
    </div>
  </div>

  <div class="form-group">
    <label for="txt_detalheMorada">Morada</label>
      <asp:TextBox ID="txt_detalheMorada" class="form-control" runat="server" placeholder="Morada completa"></asp:TextBox>
  </div>

  <div class="form-row">

      <div class="form-group col-md-6">
          <label for="txt_contacto">Telefone</label>
            <asp:TextBox ID="TextBox1" class="form-control" runat="server" placeholder="Contacto Telefonico"></asp:TextBox>
      </div>

      <div class="form-group col-md-6">
          <label for="txt_empresa">Empresa</label>
            <asp:TextBox ID="txt_empresa" class="form-control" runat="server" placeholder="Empresa"></asp:TextBox>
      </div>
  </div>
 
<div class="form-group mt-2 form-check text-center">
    <input type="checkbox" class="form-check-input" id="ck_termos" runat="server">
    <label class="form-check-label small text-muted" for="exampleCheck1"> Li e concordo com os termos e condições de venda</label>
</div>

          </div>
        </div>

         <!-- Detalhes do Carrinho -->

        <div class="col-lg-6">
          <div class="bg-dark text-light text-center rounded-pill px-4 py-3 text-uppercase">Checkout </div>
          <div class="p-4">
            <ul class="list-unstyled mb-4">
              <li class="d-flex justify-content-between py-3 border-bottom small"><strong class="text-dark">Desconto</strong><strong><asp:Label ID="lbl_desconto" runat="server" Text=""></asp:Label><label  runat="server"></label> %</strong></li>
              
               <li class="d-flex justify-content-between py-3 border-bottom small"><strong class="text-dark"># de Produtos</strong>
                  <label id="lbl_qtdTotal" class="text-black font-weight-bold" runat="server"></label>
              </li>

              <li class="d-flex justify-content-between py-3 border-bottom small"><strong class="text-dark">SubTotal</strong>
                <label id="lbl_subtotal" class="text-black font-italic" runat="server"></label>
              </li>

              <li class="d-flex justify-content-between py-3 border-bottom"><strong class="text-black">Total</strong>
                <label id="lbl_total" class="font-weight-bold text-black" runat="server"></label>
              </li>

            </ul>
              <asp:LinkButton ID="link_compra" class="btn btn-dark rounded-pill py-2 btn-block" runat="server" OnClick="link_compra_Click">Finalizar a compra</asp:LinkButton>
                <label id="lbl_erros" class="text-danger small" style="margin-left: 6em" runat="server"></label>
          </div>
        </div>
      </div>
    </div>
    
    

    <asp:SqlDataSource ID="checkoutSQLsource" runat="server" ConnectionString="<%$ ConnectionStrings:ONLINESHOP %>" SelectCommand="itemCart" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="1" Name="IDutilizador" SessionField="ID" Type="Int32" />
            <asp:CookieParameter CookieName="noLogID" DefaultValue="" Name="Cookie" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

       
</asp:Content>
