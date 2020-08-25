<%@ Page Title="" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="loja-pagina-registo-utilizador.aspx.cs" Inherits="OnlineShop.loja_pagina_registo_utilizador" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>

        body{
            background-image: url(images/backofficeloginbackground.jpg);
            background-size: contain;
        }

    </style>



</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <asp:UpdatePanel ID="RegistoUtilizador" runat="server">
        <ContentTemplate>

  
        
                    <div class="container mt-5 mb-5">
                        <div class="row justify-content-center">
                            <div class="col-lg-7">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-body">
                                        <h3 class="card-text text-center mb-2"> Registo Utilizador</h3>
                                            <div class="form-row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small mb-1" for="txt_registaNome">Nome</label>
                                                        <input ID="txt_registaNome" class="form-control" runat="server" placeholder="Introduza o nome" type="text" />
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small mb-1" for="txt_registaEmail">Email</label>
                                                        <input ID="txt_registaEmail" class="form-control" runat="server" placeholder="Introduza o email" type="email"  />
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="small mb-1" for="txt_morada">Morada</label>
                                                <input ID="txt_registaMorada" class="form-control" runat="server" type="text" placeholder="Introduza a Morada"  />
                                            </div>

                                            <div class="form-row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small mb-1" for="txt_registaPassword1">Password</label>
                                                        <input ID="txt_registaPassword1" class="form-control" runat="server" title="Password não reune os requisitos" pattern="(?=^.{8,}$)(?=.*\d)(?=.*[!@#$%^&*]+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$" type="password" placeholder="Introduza a password"   />
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small mb-1" for="txt_registaPassword2">Confirmar Password</label>
                                                        <input ID="txt_registaPassword2" class="form-control" runat="server" title="Password não reune os requisitos" pattern="(?=^.{8,}$)(?=.*\d)(?=.*[!@#$%^&*]+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$" type="password" placeholder="Confirme a password"  />
                                                    </div>
                                                </div>
                                            </div>

                                             <div id="bloco-revenda" class="form-row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small mb-1" for="txt_registaEmpresa">Empresa</label>
                                                        <asp:TextBox ID="txt_registaEmpresa" class="form-control" runat="server" placeholder="Introduza a Empresa"></asp:TextBox>

                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label class="small mb-1" for="txt_registaNIF">NIF</label>
                                                        <asp:TextBox ID="txt_registaNIF" class="form-control" runat="server" placeholder="Introduza a NIF"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                                
                                                <asp:CheckBox ID="ck_revenda" class="form-check text-center font-weight-lighter mb-3 form-text" runat="server" Text="&nbsp;&nbsp;Deseja tornar-se revendedor ?" ValidationGroup="registo" />
                                                 <label class="small h6 ml-5 mb-1 text-center text-muted">A sua password deve ser alfanumerica, com caracteres especiais, e no minimo 8 caracteres</label>

                                                <asp:Button ID="bt_registar" class="btn btn-primary btn-dark btn-block" runat="server" Text="Registar" ValidationGroup="registo" OnClick="bt_registar_Click" /> 
                                        
                                        <div class="col-lg-12 text-center align-middle">
                                               <label class="small mb-1 text-danger mt-2 text-center align-middle" id="lbl_erros" runat="server"></label>
                                        </div>
                                          
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
         



          </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
