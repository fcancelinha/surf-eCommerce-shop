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
    public partial class backofficeEncomendas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            sqlCards();
        }


        private void sqlCards()
        {
            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "backofficeEstatistica";
            myCommand.Connection = myConn;

            SqlParameter utilizadores = new SqlParameter();
            utilizadores.ParameterName = "@utilizadores";
            utilizadores.Direction = ParameterDirection.Output;
            utilizadores.SqlDbType = SqlDbType.Int;
            utilizadores.Size = 300;

            SqlParameter produtos = new SqlParameter();
            produtos.ParameterName = "@produtos";
            produtos.Direction = ParameterDirection.Output;
            produtos.SqlDbType = SqlDbType.Int;
            produtos.Size = 300;

            SqlParameter encomendas = new SqlParameter();
            encomendas.ParameterName = "@encomendas";
            encomendas.Direction = ParameterDirection.Output;
            encomendas.SqlDbType = SqlDbType.Int;
            encomendas.Size = 300;

            myCommand.Parameters.Add(utilizadores);
            myCommand.Parameters.Add(produtos);
            myCommand.Parameters.Add(encomendas);

            try
            {
                myConn.Open();
                myCommand.ExecuteNonQuery();

                lbl_nrutilizadores.Text = myCommand.Parameters["@utilizadores"].Value.ToString();
                lbl_nrprodutos.Text  = myCommand.Parameters["@produtos"].Value.ToString();
                lbl_nrencomendas.Text = myCommand.Parameters["@encomendas"].Value.ToString();
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


        protected void rpt_encomendas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dr = (DataRowView)e.Item.DataItem;

                ((DropDownList)e.Item.FindControl("ddl_estado")).SelectedValue = dr["Estado"].ToString();
                ((LinkButton)e.Item.FindControl("bt_save")).CommandArgument = dr["PDF"].ToString();
                ((LinkButton)e.Item.FindControl("bt_delete")).CommandArgument = dr["PDF"].ToString();
            }
        }

        protected void rpt_encomendas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName.Equals("bt_save"))
            {
                actualizarEstado(e);
            }

            if (e.CommandName.Equals("bt_delete"))
            {
                deleteEncomenda(e);
            }

        }

        private void actualizarEstado(RepeaterCommandEventArgs e)
        {
            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "alterarEstadoEncomenda";

            myCommand.Connection = myConn;
            myCommand.Parameters.AddWithValue("@pdf", ((LinkButton)e.Item.FindControl("bt_save")).CommandArgument);
            myCommand.Parameters.AddWithValue("@IDestado", ((DropDownList)e.Item.FindControl("ddl_estado")).SelectedValue);

            try
            {
                myConn.Open();
                myCommand.ExecuteNonQuery();
                rpt_encomendas.DataBind();
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

        private void deleteEncomenda(RepeaterCommandEventArgs e)
        {
            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "apagarEncomenda";

            myCommand.Connection = myConn;
            myCommand.Parameters.AddWithValue("@pdf", ((LinkButton)e.Item.FindControl("bt_delete")).CommandArgument);

            try
            {
                myConn.Open();
                myCommand.ExecuteNonQuery();
                rpt_encomendas.DataBind();
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