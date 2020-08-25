using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineShop
{
    public partial class produtos_detalhe : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["prod"] == null)
                Response.Redirect("produtos-todos.aspx");
            else
            {
                sqlDetalhe();
            }
                

            System.Diagnostics.Debug.WriteLine(Request.QueryString["prod"]);
        }

        private void sqlDetalhe()
        {
           
            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@ID", Convert.ToInt32(Request.QueryString["prod"]));
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "produtoDetalhe";

            try
            {

                myConn.Open();
                SqlDataReader reader = myCommand.ExecuteReader();

                if(reader.Read())
                {

                    double preco = Utilizador.revenda ? Convert.ToDouble(reader["preco"]) / 1.20 : Convert.ToDouble(reader["preco"]);

                    control_tituloProduto.InnerText = reader["titulo"].ToString();
                    control_image.ImageUrl = "data:image;base64," + Convert.ToBase64String((byte[])reader["imagem"]);
                    control_resumoProduto.Text = reader["corpo"].ToString();
                    control_categoriaProduto.InnerText = reader["descricao"].ToString();
                    control_detalhe1.InnerText = reader["detalhe1"].ToString();
                    control_detalhe2.InnerText = reader["detalhe2"].ToString();
                    control_precoProduto.InnerText = "Preço - " + preco.ToString() + "€";
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

        protected void link_adicionarItem_Click(object sender, EventArgs e)
        {

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@ID", Convert.ToInt32(Request.QueryString["prod"]));
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



        }
    }
}