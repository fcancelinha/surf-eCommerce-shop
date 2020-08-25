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
    public partial class loja_pagina_registo_utilizador : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void bt_registar_Click(object sender, EventArgs e)
        {
            //Devido ao required das html textbox a interferirem com o search
            if (txt_registaNome.Value == "" || txt_registaEmail.Value == "" || txt_registaMorada.Value == "" || txt_registaPassword1.Value == "" || txt_registaPassword2.Value == "")
            {
                lbl_erros.InnerText = "Existem campos por preencher";
                return;
            }

            if (ck_revenda.Checked && txt_registaEmpresa.Text == "" && txt_registaNIF.Text == "")
            {
                lbl_erros.InnerText = "Se quiser tornar-se revendedor, tem de preencher empresa e nif";
                return;
            }

            if (!txt_registaPassword1.Value.Equals(txt_registaPassword2.Value))
            {
                lbl_erros.InnerText = "As passwords devem ser iguais";
                return;
            }

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "registoUtilizador";

            myCommand.Connection = myConn;
            myCommand.Parameters.AddWithValue("@nome", txt_registaNome.Value);
            myCommand.Parameters.AddWithValue("@email", txt_registaEmail.Value);
            myCommand.Parameters.AddWithValue("@password", Utils.EncryptString(txt_registaPassword2.Value));
            myCommand.Parameters.AddWithValue("@empresa", txt_registaEmpresa.Text);
            myCommand.Parameters.AddWithValue("@nif", txt_registaNIF.Text);
            myCommand.Parameters.AddWithValue("@morada", txt_registaMorada.Value);
            myCommand.Parameters.AddWithValue("@pedido", ck_revenda.Checked);

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
                    string corpo = "Clique no link abaixo para activar a sua conta, caso não tenha se registado entre em contacto com a surf shop. <br>";
                    Utils.email(txt_registaEmail.Value, corpo + "https://localhost:44310/ativacao.aspx?em=" + Utils.EncryptString(txt_registaEmail.Value), "Email de Activação de Conta");
                    lbl_erros.InnerText = "Registo efectuado com sucesso, irá receber um email para activar a sua conta";
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
 