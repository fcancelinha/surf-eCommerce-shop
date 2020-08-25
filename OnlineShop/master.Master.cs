using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using Nemiro.OAuth;

namespace OnlineShop
{
    public partial class master : System.Web.UI.MasterPage
    {


        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterClientScriptBlock(UpdatePanel1, this.GetType(), UpdatePanel1.UniqueID, "switchToRecovery();", true);
            ScriptManager.RegisterClientScriptBlock(UpdatePanel1, this.GetType(), UpdatePanel1.UniqueID, "switchToLogin();", true);
            ScriptManager.RegisterClientScriptBlock(UpdatePanel1, this.GetType(), "script", "popupalert();", true);
            
            userDetails();
            generateCookie();
            initiateRegistry();
        }

        public void updateHoverCart()
        {
            
            rpt_hoverCarrinho.DataBind();
            total = 0;
            qtdtotal = 0;
        }

        private void initiateRegistry()
        {
            if (Authentication.registry == false)
            {
                Authentication.initiateAuth();
                Authentication.registry = true;
            }
        }

        private void userDetails()
        {
            link_contaUtilizador.Visible = Utilizador.logged;
            link_conta.Visible = !Utilizador.logged;
            link_registo.Visible = !Utilizador.logged;
            link_contaUtilizador.Text = Utilizador.email;
            Session["ID"] = Utilizador.userID;
        }

        private void generateCookie()
        {

            HttpCookie userCookie = Request.Cookies["noLogID"];
            Random random = new Random();

            if (userCookie == null)
            {
                userCookie = new HttpCookie("noLogID");
                userCookie.Value = random.Next(1000).ToString();
                Response.Cookies.Add(userCookie);
            }

        }

        protected void bt_login_Click(object sender, EventArgs e)
        {
            checkLogin(txt_utilizador.Text, Utils.EncryptString(txt_password.Text));
        }

        private void checkLogin(string email, string password)
        {

            if (txt_utilizador.Text.Length < 1 || txt_password.Text.Length < 1)
            {
                lbl_erros.Text = "Email ou password não preenchidos";
                return;
            }

            lbl_erros.Text = "";

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@email", email);
            myCommand.Parameters.AddWithValue("@password", password);
            myCommand.Parameters.AddWithValue("@Cookie", Request.Cookies["noLogID"].Value);

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "checkLogin";

            SqlParameter output = new SqlParameter();
            output.ParameterName = "@output";
            output.Direction = ParameterDirection.Output;
            output.SqlDbType = SqlDbType.VarChar;
            output.Size = 200;

            myCommand.Parameters.Add(output);

            try
            {
                myConn.Open();
                SqlDataReader reader = myCommand.ExecuteReader();

                if (reader.Read())
                {
                    Utilizador.userID = Convert.ToInt32(reader["ID"]);
                    Utilizador.email = reader["email"].ToString();
                    Utilizador.morada = reader["morada"].ToString();
                    Utilizador.nome = reader["nome"].ToString();
                    Utilizador.empresa = reader["empresa"].ToString();
                    Utilizador.nif = reader["nif"].ToString();
                    Utilizador.logged = true;
                    Utilizador.revenda = Convert.ToInt32(reader["idUtilizador"]) == 3 ? true : false;

                    userDetails();
                    Response.Redirect(Request.RawUrl.ToString());
                }
                else
                {
                    lbl_erros.Text = myCommand.Parameters["@output"].Value.ToString();
                }

                reader.Close();
            }
            catch (Exception x)
            {
                System.Diagnostics.Debug.WriteLine(x.Message);
            }
            finally
            {
                myConn.Close();
            }

        }

        protected void link_contaUtilizador_Click(object sender, EventArgs e)
        {
            Response.Redirect("loja-pagina-utilizador.aspx");
        }

        protected void bt_recuperarPassword_Click(object sender, EventArgs e)
        {

            if (text_recuperaEmail.Text.Length < 0)
            {
                lbl_erros.Text = "Necessita de preencher o Email";
                return;
            }
              
            Random random = new Random();
            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "recuperacaoPassword";
            myCommand.Connection = myConn;

            string pass = Utils.EncryptString(random.Next(100000).ToString());
            string corpo = "Poderá autenticar-se na surf shop com a password abaixo enviada.<br> Caso não tenha solicitado contacte um admnistrador <br>";

            myCommand.Parameters.AddWithValue("@email", text_recuperaEmail.Text);
            myCommand.Parameters.AddWithValue("@password", Utils.EncryptString(pass)); //Nova random 
       
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

                if (myCommand.Parameters["@output"].Value.ToString() == "")
                {
                    Utils.email(text_recuperaEmail.Text, corpo + pass, "Recuperação de Password");
                }
                else
                {
                    lbl_erros.Text = myCommand.Parameters["@output"].Value.ToString();
                }
            }
            catch (SqlException m)
            {
                System.Diagnostics.Debug.WriteLine(m.Message);
            }
            finally
            {
                myConn.Close();
            }

        }

        protected void txt_search_TextChanged(object sender, EventArgs e)
        {
            Response.Redirect("produtos-todos.aspx?search=" + txt_search.Text);
        }

        protected void link_registo_Click(object sender, EventArgs e)
        {
            Response.Redirect("loja-pagina-registo-utilizador.aspx");
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("qualquer coisa do botao");
            Response.Redirect("produtos-todos.aspx?search=" + txt_search.Text);
        }


        //AUTENTICAÇÕES

        protected void socialLogin(object sender, EventArgs e)
        {
            string provider = ((LinkButton)sender).Attributes["data-provider"];
            string returnUrl = new Uri(Request.Url, "testLogin.aspx").AbsoluteUri;
            OAuthWeb.RedirectToAuthorization(provider, returnUrl);
        }

        protected void link_TSHIRT_Click(object sender, EventArgs e)
        {
            Session["cat"] = "Roupa";
            Response.Redirect("produtos-todos.aspx");
        }

        protected void link_FATOS_Click(object sender, EventArgs e)
        {
            Session["cat"] = "Fatos";
            Response.Redirect("produtos-todos.aspx");
        }

        protected void link_PRANCHAS_Click(object sender, EventArgs e)
        {
            Session["cat"] = "Pranchas";
            Response.Redirect("produtos-todos.aspx");
        }

        //HOVER REPEATER

        double total;
        int qtdtotal;

        protected void rpt_hoverCarrinho_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dr = (DataRowView)e.Item.DataItem;

                double precoRevenda = Utilizador.revenda ? Convert.ToDouble(dr["Total"]) / 1.20 : Convert.ToDouble(dr["Total"]);

                qtdtotal += Convert.ToInt32(dr["Qtd"]);
                total += precoRevenda;

            }

            hoverCartTotal.Value = total.ToString("F") + " €";
            lbl_cartnum.Text = qtdtotal.ToString();

        }

        protected void rpt_hoverCarrinho_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName.Equals("btn_eliminaHoverItem"))
            {
                    SqlConnection myConn = new SqlConnection(hoverCartSqlSource.ConnectionString);
                    SqlCommand myCommand = new SqlCommand();

                    myCommand.Parameters.AddWithValue("@ID", Convert.ToInt32(e.CommandArgument.ToString()));
                    myCommand.Parameters.AddWithValue("@IDutilizador", Utilizador.userID);
                    myCommand.Parameters.AddWithValue("@Cookie", Request.Cookies["noLogID"].Value);

                    myCommand.CommandType = CommandType.StoredProcedure;
                    myCommand.CommandText = "deleteCheckoutItem";
                    myCommand.Connection = myConn;

                try
                {
                   myConn.Open();
                   myCommand.ExecuteNonQuery();
                }
                catch (SqlException x)
                {
                   System.Diagnostics.Debug.WriteLine(x.Message);
                }
                finally
                {
                    myConn.Close();
                }

                rpt_hoverCarrinho.DataBind();


            }

        }

     
    }
}


