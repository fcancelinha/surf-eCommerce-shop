using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace OnlineShop
{
    public partial class produtos_todos : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            (this.Master as master).updateHoverCart();
            SQLtesting.SelectParameters["ItemsPagina"].DefaultValue = ItemsPagina.ToString();
          
            if (!Page.IsPostBack)
            {
                pagina = 1;
                categoria = "Todos";
            }

            if (Session["cat"] != null)
            {
                categoria = Session["cat"].ToString();
                Session["cat"] = null;
            }

            lbl_categoriaPagina.Text = categoria;
            sqlEditarFiltros();
            pageButtonTemplate(getNumberOfItems());

            if (Request.QueryString["search"] != null)
            {
                searchProduct();
            }


        }

        //FILTRAGEM

        private const int ItemsPagina = 8;
        private static string campo = "Nome";
        private static string ordem = "ASC";
        private static string categoria = "Todos";
        private static int pagina = 1;


        protected void rpt_produto_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataRowView dr = (DataRowView)e.Item.DataItem;

                double precoRevenda = Convert.ToDouble(dr["preco"].ToString()) / 1.20;

                ((LinkButton)e.Item.FindControl("bt_adicionarCarrinho")).CommandArgument = dr["ID"].ToString();
                ((Label)e.Item.FindControl("lbl_preco")).Text = Utilizador.revenda ? precoRevenda.ToString("F") + " €" : dr["preco"].ToString() + " €";
            }

        }

        protected void rpt_produto_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName.Equals("bt_adicionarCarrinho"))
            {
                saveItemDB(e);
            }
        }

        void saveItemDB(RepeaterCommandEventArgs e)
        {
            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@ID", Convert.ToInt32(((LinkButton)e.Item.FindControl("bt_adicionarCarrinho")).CommandArgument));
            myCommand.Parameters.AddWithValue("@IDutilizador", Utilizador.userID);
            myCommand.Parameters.AddWithValue("@Cookie", Request.Cookies["noLogID"].Value);

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "adicionaItem";

            SqlParameter output = new SqlParameter();
            output.ParameterName = "@output";
            output.Direction = ParameterDirection.Output;
            output.SqlDbType = SqlDbType.VarChar;
            output.Size = 300;

            myCommand.Parameters.Add(output);

            try
            {
                myConn.Open();
                myCommand.ExecuteNonQuery();

                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "popupalert();", true);
                System.Diagnostics.Debug.WriteLine(myCommand.Parameters["@output"].Value.ToString());
            }
            catch (SqlException x)
            {
                System.Diagnostics.Debug.WriteLine(x.ToString());
            }
            finally
            {
                myConn.Close();
            }


            (this.Master as master).updateHoverCart();
        }


        private void searchProduct()
        {
            rpt_produto.DataSourceID = searchSqlSource.ID;
            rpt_produto.DataBind();
            pageButtonTemplate(rpt_produto.Items.Count - 1);
        }

        //CRIAÇÃO DOS BOTÕES

        private void pageButtonTemplate(int nrPages)
        {
            pagePanel.Controls.Clear();

            LinkButton pageBefore = new LinkButton();
            pageBefore.Click += new EventHandler(mudarBefore);
            pageBefore.CssClass = "btn btn-dark ml-2 mr-2";
            pageBefore.Text = "«";
            

            pagePanel.Controls.Add(pageBefore);

            for (int i = 1; i <= nrPages; i++)
            {
                LinkButton pageButton = new LinkButton();
                pageButton.Click += new EventHandler(mudarPagina);
                pageButton.CssClass = "btn btn-outline-dark border-white ml-2 mr-2";
                pageButton.Text = i.ToString();

                if (pagina == 1 && i == 1)
                    pageButton.CssClass = "btn btn-dark border-white ml-2 mr-2";

                pagePanel.Controls.Add(pageButton);
            }

            LinkButton pageAfter = new LinkButton();
            pageAfter.Click += new EventHandler(mudarAfter);
            pageAfter.CssClass = "btn btn-dark ml-2 mr-2";
            pageAfter.Text = "»";

            pagePanel.Controls.Add(pageAfter);
        }

        protected void mudarPagina(object sender, EventArgs e)
        {
            pagina = Convert.ToInt32(((LinkButton)sender).Text);
            activePage(((LinkButton)sender));
            sqlEditarFiltros();
        }


        private int getNumberOfItems()
        {
            int items = 0;

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();
            myCommand.Connection = myConn;

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "numberOfPages";
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@categoria", categoria);
            myConn.Open();
            myCommand.ExecuteNonQuery();
            SqlDataReader reader = myCommand.ExecuteReader();

            while (reader.Read())
            {
                items = Convert.ToInt32(reader["Num"]);
            }
 
            reader.Close();
            return (int)Math.Ceiling((double)items / (double)ItemsPagina);
        } 

        private void activePage(LinkButton button)
        {
            foreach(LinkButton control in pagePanel.Controls) { 

                if(control != button)
                    control.CssClass = "btn btn-outline-dark border-white ml-2 mr-2";
                if(control.Text == "»" || control.Text == "«" || button == control)
                    control.CssClass = "btn btn-dark ml-2 mr-2";
                if(control.Text == pagina.ToString())
                    control.CssClass = "btn btn-dark ml-2 mr-2";
            }
        }

        protected void mudarBefore(object sender, EventArgs e)
        {
            if(pagina > 1)
            {
                pagina--;
                activePage((LinkButton)sender);
                sqlEditarFiltros();
            }
                
        }

        protected void mudarAfter(object sender, EventArgs e)
        {   
            if(pagina < pagePanel.Controls.Count - 2)
            {
                pagina++;
                activePage((LinkButton)sender);
                sqlEditarFiltros();
            }
              
        }

     
        protected void link_filtragem(object sender, EventArgs e)
        {

            switch (((LinkButton)sender).ID)
            {
                case "link_az":
                    ddl_filtros.InnerText = "Filtro: A - Z";
                    campo = "Nome";
                    ordem = "ASC";
                        break;        
                case "link_za":
                    ddl_filtros.InnerText = "Filtro: Z - A";
                    campo = "Nome";
                    ordem = "DESC";
                        break;        
                case "link_precoAscendente":
                    ddl_filtros.InnerText = "Filtro: Preço Ascendente";
                    campo = "Preco";
                    ordem = "ASC";
                        break;        
                case "link_precoDescendente":
                    ddl_filtros.InnerText = "Filtro: Preço Descendente";
                    campo = "Preco";
                    ordem = "DESC";
                        break;
                case "link_categoriaPranchas":
                    lbl_categoriaPagina.Text = "Pranchas"; ;
                    categoria = "Pranchas";
                        break;
                case "link_categoriaFatos":
                    lbl_categoriaPagina.Text = "Fatos";
                    categoria = "Fatos";
                        break;
                case "link_categoriaRoupa":
                    lbl_categoriaPagina.Text = "Roupa";
                    categoria = "Roupa";
                        break;
            }

            pagina = 1;
            pageButtonTemplate(getNumberOfItems());
            sqlEditarFiltros();

        }

        private void sqlEditarFiltros()
        {
            SQLtesting.SelectParameters["Campo"].DefaultValue = campo;
            SQLtesting.SelectParameters["Ordem"].DefaultValue = ordem;
            SQLtesting.SelectParameters["Categoria"].DefaultValue = categoria;
            SQLtesting.SelectParameters["Pagina"].DefaultValue = pagina.ToString();
            SQLtesting.SelectParameters["ItemsPagina"].DefaultValue = ItemsPagina.ToString();

            rpt_produto.DataSourceID = SQLtesting.ID;
            rpt_produto.DataBind();
        }

        protected void link_resetFilter_Click(object sender, EventArgs e)
        {
            ddl_filtros.InnerText = "Ordenação por";
            categoria = "Todos";
            campo = "Nome";
            ordem = "ASC";
            pagina = 1;
            lbl_categoriaPagina.Text = categoria;

            sqlEditarFiltros();
            pageButtonTemplate(getNumberOfItems());

        }
    }

}
