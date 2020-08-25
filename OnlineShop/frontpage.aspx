<%@ Page Title="" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="frontpage.aspx.cs" Inherits="OnlineShop.frontpage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


 <!-- !Nav -->

  <header>
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
      <ol class="carousel-indicators">
        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner" role="listbox">
        <!-- Slide One - Set the background image for this slide in the line below -->
        <div class="carousel-item active" style="background-image: url('images/slider1.jpg')">
        </div>
        <!-- Slide Two - Set the background image for this slide in the line below -->
        <div class="carousel-item" style="background-image: url('images/slider2.jpg')">
        </div>
        <!-- Slide Three - Set the background image for this slide in the line below -->
        <div class="carousel-item" style="background-image: url('images/slider3.jpg')">
        </div>
      </div>
      <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
      </a>
    </div>
  </header>

  <br>
  <br>


   <div class="container">
    <h1 class="mt-4 mb-3">Promo</h1>
    <!-- Image Header -->
    <img class="img-fluid rounded mb-4" src="images/revenda.jpg" alt="">
  </div>

  <!-- Page Content -->
  <div class="container">

    <!-- Portfolio Section -->
    <h2>Categorias</h2>
      <br />


    <div class="row">
      <div class="col-lg-4 col-sm-6 portfolio-item">
        <div class="card h-100 border-light text-center">
          <a href="produtos-todos.aspx?category=Pranchas"><img class="card-img-top" src="images/surfboards.jpg" alt=""></a>
          <div class="card-body">
            <h4 class="card-title">
              <a href="produtos-todos.aspx?category=Pranchas" class="card-text text-dark">Pranchas de Surf</a>
            </h4>
            <p class="card-text small text-dark">Pranchas para todos os gostos</p>
          </div>
        </div>
      </div>
      <div class="col-lg-4 col-sm-6 portfolio-item">
        <div class="card h-100 border-light text-center">
          <a href="produtos-todos.aspx?category=Fatos"><img class="card-img-top" src="images/wetsuits.jpg" alt=""></a>
          <div class="card-body">
            <h4 class="card-title">
              <a href="produtos-todos.aspx?category=Fatos" class="card-text text-dark">Fatos de Surf</a>
            </h4>
            <p class="card-text small text-dark">Fatos para aguentar o mar</p>
          </div>
        </div>
      </div>
      <div class="col-lg-4 col-sm-6 portfolio-item">
        <div class="card h-100 border-light text-center">
          <a href="produtos-todos.aspx?category=Roupa"><img class="card-img-top" src="images/tshirts.jpg" alt=""></a>
          <div class="card-body">
            <h4 class="card-title">
              <a href="produtos-todos.aspx?category=Roupa" class="card-text text-dark">Roupa de Surf</a>
            </h4>
            <p class="card-text small text-dark">Roupa para o teu estilo</p>
          </div>
        </div>
      </div>
    </div>
    <!-- /.row -->

    <hr>

  </div>
  <!-- /.container -->

 <!-- Footer -->
  <footer class="bg-light">
      <div class="container text-center card-link h5 mb-2">
          <i class="fab fa-instagram mr-4"></i>
          <i class="fab fa-facebook-f"></i>
          <i class="fab fa-github ml-4"></i>
      </div>
    <div class="container">
      <p class="m-0 mb-4 text-center text-dark">Copyright &copy; Surf Shop Lda. 2020</p>
    </div>
    <!-- /.container -->
  </footer>


   <script type="text/javascript">



   </script>



</asp:Content>
