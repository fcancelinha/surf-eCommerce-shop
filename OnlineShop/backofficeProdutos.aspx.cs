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
    public partial class backofficeProdutos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void link_inserir_Click(object sender, EventArgs e)
        {
            Stream imgstream = fl_produtoImagem.PostedFile.InputStream;
            int imgLen = fl_produtoImagem.PostedFile.ContentLength;
            byte[] imgBinaryData = new byte[imgLen];
            imgstream.Read(imgBinaryData, 0, imgLen);

            //insert into produto values(@imagem, @titulo, @resumo, @descricao, @detalhe1, @detalhe2, @preco, @idCategoria)

            SqlConnection myConn = new SqlConnection(produtosSQLSource.ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "inserir_produto";

            myCommand.Connection = myConn;
            myCommand.Parameters.AddWithValue("@imagem", imgBinaryData);
            myCommand.Parameters.AddWithValue("@titulo", tb_titulo.Text);
            myCommand.Parameters.AddWithValue("@resumo", tb_resumo.Text);
            myCommand.Parameters.AddWithValue("@descricao", tb_descricao.Text);
            myCommand.Parameters.AddWithValue("@detalhe1", tb_detalhe1.Text);
            myCommand.Parameters.AddWithValue("@detalhe2", tb_detalhe2.Text);
            myCommand.Parameters.AddWithValue("@preco", Convert.ToDecimal(tb_preco.Text));
            myCommand.Parameters.AddWithValue("@idCategoria", ddl_categoria.SelectedValue);


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
                rpt_backofficeProduto.DataBind();
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

        protected void rpt_backofficeProduto_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dr = (DataRowView)e.Item.DataItem;
                ((LinkButton)e.Item.FindControl("link_delete")).CommandArgument = dr["ID"].ToString();
            }
        }

        protected void rpt_backofficeProduto_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

            if (e.CommandName.Equals("link_delete"))
            {
                deleteItem(e);
            }

        }

        private void fillModal(int ID)
        {
            string query = "select * from produto inner join categoria on produto.IDcategoria = categoria.ID where produto.ID = " + ID;

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand(query, myConn);

            myConn.Open();
            var reader = myCommand.ExecuteReader();

            if(reader.Read())
            {
                System.Diagnostics.Debug.WriteLine("reader");
                tb_updateTitulo.Value = reader.GetString(2);
                tb_updateResumo.Value = reader["resumo"].ToString();
                tb_updateDescricao.Value = reader["descricao"].ToString();
                tb_updateDetalhe1.Value = reader["detalhe1"].ToString();
                tb_updateDetalhe2.Value = reader["detalhe2"].ToString();
                tb_updatePreco.Value = reader["preco"].ToString();
                ddl_updateCategoria.SelectedValue = reader["IDcategoria"].ToString();
            }
        
            reader.Close();
            myConn.Close();
            rpt_backofficeProduto.DataBind();
        }

      

        // UPDATE E DELETE 

        private void deleteItem(RepeaterCommandEventArgs e)
        {
            string query = "delete from produto where produto.id = " + e.CommandArgument.ToString();

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ONLINESHOP"].ConnectionString);
            SqlCommand myCommand = new SqlCommand(query, myConn);

            myConn.Open();
            myCommand.ExecuteNonQuery();
            myConn.Close();

            rpt_backofficeProduto.DataBind();
        }

        static int updatedID;

        protected void lb_openModalUpdate_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            fillModal(Convert.ToInt32(lb.CommandArgument.ToString()));
            updatedID = Convert.ToInt32(lb.CommandArgument.ToString());
            ScriptManager.RegisterStartupScript(this, GetType(), "Pop", "$('#modal-update-product').modal()", true);
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
        }

        protected void link_updateProduct_Click(object sender, EventArgs e)
        {
            updateItem();
        }

        private void updateItem()
        {
            Stream imgstream = fl_updateUpload.PostedFile.InputStream;
            int imgLen = fl_updateUpload.PostedFile.ContentLength;
            byte[] imgBinaryData = new byte[imgLen];
            imgstream.Read(imgBinaryData, 0, imgLen);

            SqlConnection myConn = new SqlConnection(produtosSQLSource.ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "updateProd";

            myCommand.Connection = myConn;
            myCommand.Parameters.AddWithValue("@ID", updatedID);
            myCommand.Parameters.AddWithValue("@imagem", imgBinaryData);
            myCommand.Parameters.AddWithValue("@titulo", tb_updateTitulo.Value);
            myCommand.Parameters.AddWithValue("@resumo", tb_updateResumo.Value);
            myCommand.Parameters.AddWithValue("@descricao", tb_updateDescricao.Value);
            myCommand.Parameters.AddWithValue("@detalhe1", tb_updateDetalhe1.Value);
            myCommand.Parameters.AddWithValue("@detalhe2", tb_updateDetalhe2.Value);
            myCommand.Parameters.AddWithValue("@preco", Convert.ToDecimal(tb_updatePreco.Value));
            myCommand.Parameters.AddWithValue("@idCategoria", ddl_updateCategoria.SelectedValue);

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
                rpt_backofficeProduto.DataBind();
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

       
    }
}