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
    public partial class loja_pagina_utilizador : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Utilizador.userID == 1)
              Response.Redirect("frontpage.aspx");
            
            if(!Page.IsPostBack)
                utilizadorDetalhes();
        }

        private void utilizadorDetalhes()
        {
            txt_nome.Text = Utilizador.nome;
            txt_email.Text = Utilizador.email;
            txt_morada.Text = Utilizador.morada;
            txt_empresa.Text = Utilizador.empresa;
            txt_nif.Text = Utilizador.nif;
            lb_passwordAntiga.ReadOnly = Utilizador.social;
            lb_passwordNova.ReadOnly = Utilizador.social;
            lb_passwordNovaRepetida.ReadOnly = Utilizador.social;
            link_alterarPassword.Visible = Utilizador.social;

        }

        protected void link_alterarPassword_Click(object sender, EventArgs e)
        {

            lbl_erro.Text = "";

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "alterarPasswordUtilizador";
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@ID", Utilizador.userID);
            myCommand.Parameters.AddWithValue("@passwordAntiga", Utils.EncryptString(lb_passwordAntiga.Text));
            myCommand.Parameters.AddWithValue("@passwordNova", Utils.EncryptString(lb_passwordNovaRepetida.Text));

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
                    lbl_erro.Text = "*Password Alterada com sucesso";
                }
                else
                {
                    lbl_erro.Text = "* " + myCommand.Parameters["@output"].Value.ToString();
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

        protected void link_logout_Click(object sender, EventArgs e)
        {
            Utilizador.logged = false;
            Utilizador.userID = 1;
            Utilizador.revenda = false;
            Utilizador.social = false;
            Session["ID"] = Utilizador.userID;

            txt_nome.Text = "";
            txt_email.Text = "";
            txt_empresa.Text = "";
            txt_nif.Text = "";
            txt_morada.Text = "";

            Response.Redirect("frontpage.aspx");
        }


        protected void link_alterarDetalhes_Click(object sender, EventArgs e)
        {

            System.Diagnostics.Debug.WriteLine("ENTREI NA ALTERAÇÃO");
            System.Diagnostics.Debug.WriteLine(Utilizador.userID);

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "alterarDetalhesCliente";
            myCommand.Connection = myConn;

            myCommand.Parameters.AddWithValue("@ID", Utilizador.userID);
            myCommand.Parameters.AddWithValue("@nome", txt_nome.Text);
            myCommand.Parameters.AddWithValue("@email", txt_email.Text);
            myCommand.Parameters.AddWithValue("@empresa", txt_empresa.Text);
            myCommand.Parameters.AddWithValue("@nif", txt_nif.Text);
            myCommand.Parameters.AddWithValue("@morada", txt_morada.Text);

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
                Utilizador.nome = txt_nome.Text;
                Utilizador.email = txt_email.Text;
                Utilizador.morada = txt_morada.Text;
                Utilizador.empresa = txt_empresa.Text;
                Utilizador.nif = txt_nif.Text;
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

        protected void rptEncomendas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName.Equals("link_pdf"))
            {
                string pdf = ((LinkButton)e.Item.FindControl("link_pdf")).CommandArgument;

                Response.Redirect("https://localhost:44310/" + pdf.Replace("\\", "/"));
            }
        }

        protected void rptEncomendas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dr = (DataRowView)e.Item.DataItem;

                ((LinkButton)e.Item.FindControl("link_pdf")).CommandArgument = dr["PDF"].ToString();
            }
        }
    }

}
 