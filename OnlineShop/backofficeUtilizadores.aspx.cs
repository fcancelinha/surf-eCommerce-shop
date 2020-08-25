using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace OnlineShop
{
    public partial class backofficeUtilizadores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void rpt_utilizador_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName.Equals("link_editar"))
            {
                sqlactualiza(e);

            }

            if (e.CommandName.Equals("link_eliminar"))
            {
                sqlelimina(e);
            }
        }


        private void sqlactualiza(RepeaterCommandEventArgs e)
        {
            SqlConnection myConn = new SqlConnection(utilizadorSqlSource.ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "actUtilBack";

            myCommand.Connection = myConn;
            myCommand.Parameters.AddWithValue("@ID", Convert.ToInt32(e.CommandArgument.ToString()));
            myCommand.Parameters.AddWithValue("@nome", ((TextBox)e.Item.FindControl("txt_nome")).Text);
            myCommand.Parameters.AddWithValue("@email", ((TextBox)e.Item.FindControl("txt_email")).Text);
            myCommand.Parameters.AddWithValue("@empresa", ((TextBox)e.Item.FindControl("txt_empresa")).Text);
            myCommand.Parameters.AddWithValue("@nif", ((TextBox)e.Item.FindControl("txt_nif")).Text);
            myCommand.Parameters.AddWithValue("@activo", ((CheckBox)e.Item.FindControl("ck_activo")).Checked);
            myCommand.Parameters.AddWithValue("@idUtilizador", ((DropDownList)e.Item.FindControl("ddl_updateCategoria")).SelectedValue);

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
                rpt_utilizador.DataBind();
                System.Diagnostics.Debug.WriteLine(myCommand.Parameters["@output"].Value);
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


        private void sqlelimina(RepeaterCommandEventArgs e)
        {
            string query = "delete from utilizador where utilizador.ID = " + e.CommandArgument.ToString();

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand(query, myConn);

            myConn.Open();
            myCommand.ExecuteNonQuery();
            myConn.Close();

            rpt_utilizador.DataBind();
        }


        protected void rpt_utilizador_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dr = (DataRowView)e.Item.DataItem;

                ((DropDownList)e.Item.FindControl("ddl_updateCategoria")).SelectedValue = dr["ID1"].ToString();
                ((Label)e.Item.FindControl("lbl_nif")).Text = dr["nif"].ToString() == "" ? "N/A" : dr["nif"].ToString();
                ((Label)e.Item.FindControl("lbl_pendeteRevenda")).Text = Convert.ToBoolean(dr["pedidoRevenda"]) ? "Sim" : "Não";
                ((Label)e.Item.FindControl("lbl_empresa")).Text = dr["empresa"].ToString() == "" ? "N/A" : dr["empresa"].ToString();
                
                
                ((TextBox)e.Item.FindControl("txt_empresa")).Text = dr["empresa"].ToString() == "" ? "N/A" : dr["empresa"].ToString();
                ((TextBox)e.Item.FindControl("txt_email")).Text = dr["email"].ToString();
                ((TextBox)e.Item.FindControl("txt_nome")).Text = dr["nome"].ToString();
                ((TextBox)e.Item.FindControl("txt_nif")).Text = dr["nif"].ToString() == "" ? "N/A" : dr["nif"].ToString();
            }
        }

      


        protected void link_inserirUtilizador_Click(object sender, EventArgs e)
        {
            Random random = new Random();
            SqlConnection myConn = new SqlConnection(utilizadorSqlSource.ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "inserirUtilizador";
            myCommand.Connection = myConn;

            string pass = Utils.EncryptString(random.Next(100000).ToString());
            string corpo = "Uma conta na Surf Shop foi criada para si, utilize a password abaixo para se autenticar. <br>";

            myCommand.Parameters.AddWithValue("@nome", tb_nomeCompleto.Text );
            myCommand.Parameters.AddWithValue("@password", Utils.EncryptString(pass)); //Nova random 
            myCommand.Parameters.AddWithValue("@email", tb_email.Text);
            myCommand.Parameters.AddWithValue("@empresa", tb_empresa.Text);
            myCommand.Parameters.AddWithValue("@nif", tb_nif.Text);
            myCommand.Parameters.AddWithValue("@morada", tb_morada.Text);
            myCommand.Parameters.AddWithValue("@activo", 1);
            myCommand.Parameters.AddWithValue("@idUtilizador", ddl_tipoUtilizador.SelectedValue);
            myCommand.Parameters.AddWithValue("@pedidoRevenda", ddl_tipoUtilizador.SelectedValue.ToString() == "3" ? 1 : 0);

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
                    Utils.email(tb_email.Text, corpo + pass, "Criação de Conta directa");
                    rpt_utilizador.DataBind();
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