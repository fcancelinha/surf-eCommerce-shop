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
    public partial class testLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var result = OAuthWeb.VerifyAuthorization();

            if (result.IsSuccessfully)
            {
                var user = result.UserInfo;
                auth_success(user);
                
            }

        }

        private void auth_success(UserInfo user)
        {

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();
            myCommand.Connection = myConn;

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "registoSocial";

            myCommand.Parameters.AddWithValue("@nome", user.FirstName ?? "N/A");
            myCommand.Parameters.AddWithValue("@email", user.Email);
            myCommand.Parameters.AddWithValue("@password", Utils.EncryptString(user.UserId));
            myCommand.Parameters.AddWithValue("@Cookie", Request.Cookies["noLogID"].Value);

            try
            {
                myConn.Open();
                SqlDataReader reader = myCommand.ExecuteReader();

                if (reader.Read())
                {
                    Utilizador.userID = Convert.ToInt32(reader["ID"]);
                    Utilizador.email = reader["email"].ToString();
                    Utilizador.morada = reader["morada"].ToString() == "" ? "N/A": reader["morada"].ToString();
                    Utilizador.nome = reader["nome"].ToString();
                    Utilizador.empresa = reader["empresa"].ToString() == "" ? "N/A" : reader["empresa"].ToString();
                    Utilizador.nif = reader["nif"].ToString() == "" ? "N/A" : reader["nif"].ToString();
                    Utilizador.logged = true;
                    Utilizador.revenda = Convert.ToInt32(reader["idUtilizador"]) == 3 ? true : false;
                    Utilizador.social = true;
                    Session["ID"] = Utilizador.userID;

                }
               
                reader.Close();
                Response.Redirect("frontpage.aspx");
            }
            catch (SqlException x)
            {
                System.Diagnostics.Debug.WriteLine(x.Message);
            }
            finally
            {
                myConn.Close();
            }



        }


    }
}