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
    public partial class backofficeLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void bt_login_Click(object sender, EventArgs e)
        {
            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "checkLoginAdmins";
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@username", txt_username.Value);
            myCommand.Parameters.AddWithValue("@password", txt_password.Value);

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


                if(myCommand.Parameters["@output"].Value.ToString() == "")
                {
                    SqlDataReader dr = myCommand.ExecuteReader();

                    if (dr.Read())
                    {
                        Session["aNome"] = dr["adminNome"].ToString();
                        Session["adminTipo"] = dr["IDadmin"].ToString();
                    }
                    dr.Close();
                    Response.Redirect("backofficeEncomendas.aspx");
                }
                else
                {
                    lbl_erros.InnerText = myCommand.Parameters["@output"].Value.ToString();
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
    }
}