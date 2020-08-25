<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="backofficeLogin.aspx.cs" Inherits="OnlineShop.backofficeLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Backoffice Login</title>



<style>

@import url(https://fonts.googleapis.com/css?family=Roboto:300);

.login-page {
  width: 360px;
  padding: 8% 0 0;
  margin: auto;
}
.form {
  position: relative;
  z-index: 1;
  background: #FFFFFF;
  max-width: 360px;
  margin: 0 auto 100px;
  padding: 45px;
  text-align: center;
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
}
.form input {
  font-family: "Roboto", sans-serif;
  outline: 0;
  background: #f2f2f2;
  width: 100%;
  border: 0;
  margin: 0 0 15px;
  padding: 15px;
  box-sizing: border-box;
  font-size: 14px;
}


.form .message {
  margin: 15px 0 0;
  color: #b3b3b3;
  font-size: 12px;
}
.form .message a {
  color: #4CAF50;
  text-decoration: none;
}
.form .register-form {
  display: none;
}
.container {
  position: relative;
  z-index: 1;
  max-width: 300px;
  margin: 0 auto;
}
.container:before, .container:after {
  content: "";
  display: block;
  clear: both;
}
.container .info {
  margin: 50px auto;
  text-align: center;
}
.container .info h1 {
  margin: 0 0 15px;
  padding: 0;
  font-size: 36px;
  font-weight: 300;
  color: #1a1a1a;
}
.container .info span {
  color: #4d4d4d;
  font-size: 12px;
}
.container .info span a {
  color: #000000;
  text-decoration: none;
}
.container .info span .fa {
  color: #EF3B3A;
}

body {
  background-image:url(images/backofficeloginbackground.jpg);
  font-family: "Roboto", sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;      
}

#bt_login{
    background-color:#000000;
}

#bt_login:hover{
    background-color:#1a1a1a;
}


</style>

  <!-- Bootstrap core CSS -->
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
  <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>

  <!-- Custom styles for this template -->
  <link href="css/modern-business.css" rel="stylesheet"/>
  <link href="css/Search.css" rel="stylesheet"/>

    <!-- FontAwesome & jQuery -->
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.7/css/all.css"/>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>


</head>
<body>
    <form id="form1" runat="server">
       

 <div class="login-page rounded shadow">
  <div class="form">
   <h3 class="text-dark mb-4">BackOffice</h3>
    <div class="login-form">
      <input type="text" id="txt_username" runat="server" placeholder="Username" required/>
      <input type="password" id="txt_password" runat="server" placeholder="password" required/>
       <asp:Button class=" btn btn-dark rounded mt-3" ID="bt_login" runat="server" Text="Entrar" OnClick="bt_login_Click" />
      <p class="message" id="lbl_erros" runat="server"></p>
    </div>
  </div>
</div>




    </form>
</body>
</html>
