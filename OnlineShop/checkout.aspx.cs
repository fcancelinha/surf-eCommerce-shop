using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineShop
{
    public partial class checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["ID"] = Utilizador.userID;


            //Pré-preenchimento
            if (Utilizador.logged)
            {
                txt_detalheMorada.Text = Utilizador.morada;
                txt_detalheNIF.Text = Utilizador.nif;
                txt_detalheNome.Text = Utilizador.nome;
                txt_empresa.Text = Utilizador.empresa;
            }
        }

        double total;
        double subtotal;
        int qtdtotal;


        protected void rpt_checkout_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dr = (DataRowView) e.Item.DataItem;

                double precoRevenda = Utilizador.revenda ? Convert.ToDouble(dr["Total"]) / 1.20 : Convert.ToDouble(dr["Total"]);

                qtdtotal += Convert.ToInt32(dr["Qtd"]);
                subtotal += precoRevenda;
                total += precoRevenda;

                ((Label)e.Item.FindControl("lb_total")).Text = precoRevenda.ToString("F") + " €";
                ((LinkButton)e.Item.FindControl("bt_eliminaItem")).CommandArgument = dr["ID"].ToString();
            }

            lbl_total.InnerText = total.ToString("F") + " €";
            lbl_subtotal.InnerText = (subtotal / 1.23).ToString("F") + " € (Sem IVA)"; 
            lbl_qtdTotal.InnerText = qtdtotal.ToString();
            lbl_desconto.Text = Utilizador.revenda ? "(Revenda) 20" : "0";
        }

        protected void rpt_checkout_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            SqlConnection myConn = new SqlConnection(checkoutSQLsource.ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            if (e.CommandName.Equals("bt_eliminaItem"))
            {
                myCommand.Parameters.AddWithValue("@ID", Convert.ToInt32(((LinkButton)e.Item.FindControl("bt_eliminaItem")).CommandArgument));
                myCommand.Parameters.AddWithValue("@IDutilizador", Utilizador.userID);
                myCommand.Parameters.AddWithValue("@Cookie", Request.Cookies["noLogID"].Value);

                myCommand.CommandType = CommandType.StoredProcedure;
                myCommand.CommandText = "deleteCheckoutItem";
                myCommand.Connection = myConn;

                try
                {
                    myConn.Open();
                    myCommand.ExecuteNonQuery();

                    lbl_total.InnerText = "";
                    lbl_subtotal.InnerText = "";
                    lbl_qtdTotal.InnerText = "";
                }
                catch (SqlException x)
                {
                    System.Diagnostics.Debug.WriteLine(x.Message);
                }

                rpt_checkout.DataBind();
            }

            if (e.CommandName.Equals("link_diminuirQtd"))
            {
                string query = $"delete top(1) from carrinho where carrinho.IDproduto = {Convert.ToInt32(((LinkButton)e.Item.FindControl("link_diminuirQtd")).CommandArgument)} AND carrinho.IDutilizador = {Utilizador.userID}  AND carrinho.Cookie = {Request.Cookies["noLogID"].Value}";

                SqlCommand diminuir = new SqlCommand(query, myConn);

                myConn.Open();
                diminuir.ExecuteReader();
                myConn.Close();
                rpt_checkout.DataBind();
            }

            if (e.CommandName.Equals("link_AumentarQtd"))
            {
                string query = $"insert into carrinho values({Convert.ToInt32(((LinkButton)e.Item.FindControl("link_AumentarQtd")).CommandArgument)}, {Utilizador.userID}, {Request.Cookies["noLogID"].Value})";

                SqlCommand adicionar = new SqlCommand(query, myConn);

                myConn.Open();
                adicionar.ExecuteReader();
                myConn.Close();
                rpt_checkout.DataBind();
            }

        }

        private void pdfCarrinho()
        {
            //PDF 
            string produto = "";
            string qtd = "";
            string preco = "";
            string total = "";

            Random aleatorio = new Random();

            string localhost = WebConfigurationManager.AppSettings["localhost"];
            string pdfpath = AppDomain.CurrentDomain.BaseDirectory + WebConfigurationManager.AppSettings["pdfpath"];
            string pdfTemplate = pdfpath + "encomenda.pdf";
            string nomePDF = Utils.EncryptString(aleatorio.Next(1, 10000).ToString()) + ".pdf";
            string newFile = pdfpath + nomePDF;

            PdfReader pdfreader = new PdfReader(pdfTemplate);
            PdfStamper pdfstamper = new PdfStamper(pdfreader, new FileStream(newFile, FileMode.Create));
            AcroFields pdfformfields = pdfstamper.AcroFields;

            pdfformfields.SetField("data", DateTime.Now.ToShortDateString());
            pdfformfields.SetField("subtotal", lbl_subtotal.InnerText.Substring(0, 10));
            pdfformfields.SetField("total", lbl_total.InnerText);


            foreach(RepeaterItem rpitem in rpt_checkout.Items)
            {
                if (rpitem.ItemType == ListItemType.Item || rpitem.ItemType == ListItemType.AlternatingItem)
                {
                    double x = Utilizador.revenda ? Convert.ToDouble(((Label)rpitem.FindControl("pdf_precounitario")).Text) / 1.20 : Convert.ToDouble(((Label)rpitem.FindControl("pdf_precounitario")).Text);
                    double y = Utilizador.revenda ? Convert.ToDouble(((Label)rpitem.FindControl("pdf_precototal")).Text) / 1.20 : Convert.ToDouble(((Label)rpitem.FindControl("pdf_precototal")).Text);

                    produto += ((Label)rpitem.FindControl("pdf_titulo")).Text + System.Environment.NewLine + ((Label)rpitem.FindControl("pdf_resumo")).Text + System.Environment.NewLine;
                    qtd += System.Environment.NewLine + ((Label)rpitem.FindControl("pdf_quantidade")).Text + System.Environment.NewLine;
                    preco += System.Environment.NewLine + x.ToString("F") + " €" + System.Environment.NewLine;
                    total += System.Environment.NewLine + y.ToString("F") + " €" + System.Environment.NewLine;
                }
            }

            pdfformfields.SetField("produtp", produto);
            pdfformfields.SetField("qtd", qtd);
            pdfformfields.SetField("precounitario", preco);
            pdfformfields.SetField("totalproduto", total);

            pdfstamper.Close();
            Response.Redirect(localhost + "PDF/" + nomePDF);
        }



        // PDF DA COMPRA

        private string pdf()
        {
            //PDF 
            string produto = "";
            string qtd = "";
            string total = "";
            string preco = "";

            Random aleatorio = new Random();

            string localhost = WebConfigurationManager.AppSettings["localhost"];
            string pdfpath = AppDomain.CurrentDomain.BaseDirectory + WebConfigurationManager.AppSettings["pdfpath"];
            string pdfTemplate = pdfpath + "factura.pdf";
            string nomePDF = Utils.EncryptString(aleatorio.Next(1, 10000).ToString()) + ".pdf";
            string newFile = pdfpath + nomePDF;

            PdfReader pdfreader = new PdfReader(pdfTemplate);
            PdfStamper pdfstamper = new PdfStamper(pdfreader, new FileStream(newFile, FileMode.Create));
            AcroFields pdfformfields = pdfstamper.AcroFields;

            pdfformfields.SetField("cliente", txt_detalheNome.Text);
            pdfformfields.SetField("morada", txt_detalheMorada.Text);
            pdfformfields.SetField("data", DateTime.Now.ToShortDateString());
            pdfformfields.SetField("nif", Utilizador.nif);
            pdfformfields.SetField("subtotal", lbl_subtotal.InnerText.Substring(0, 10));
            pdfformfields.SetField("total", lbl_total.InnerText);
            pdfformfields.SetField("empresa", txt_empresa.Text);


            foreach (RepeaterItem rpitem in rpt_checkout.Items)
            {
                if (rpitem.ItemType == ListItemType.Item || rpitem.ItemType == ListItemType.AlternatingItem)
                {
                    double x = Utilizador.revenda ? Convert.ToDouble(((Label)rpitem.FindControl("pdf_precounitario")).Text) / 1.20 : Convert.ToDouble(((Label)rpitem.FindControl("pdf_precounitario")).Text);
                    double y = Utilizador.revenda ? Convert.ToDouble(((Label)rpitem.FindControl("pdf_precototal")).Text) / 1.20 : Convert.ToDouble(((Label)rpitem.FindControl("pdf_precototal")).Text);

                    produto += ((Label)rpitem.FindControl("pdf_titulo")).Text + System.Environment.NewLine + ((Label)rpitem.FindControl("pdf_resumo")).Text + System.Environment.NewLine;
                    qtd += System.Environment.NewLine + ((Label)rpitem.FindControl("pdf_quantidade")).Text + System.Environment.NewLine;
                    preco += System.Environment.NewLine + x.ToString("F") + " €" + System.Environment.NewLine;
                    total += System.Environment.NewLine + y.ToString("F") + " €" + System.Environment.NewLine;
                }
            }

            pdfformfields.SetField("produtp", produto);
            pdfformfields.SetField("qtd", qtd);
            pdfformfields.SetField("precounitario", preco);
            pdfformfields.SetField("totalproduto", total);

            pdfstamper.Close();

            //************************************** EMAIL 

            MailMessage m = new MailMessage();
            SmtpClient sc = new SmtpClient();

            m.From = new MailAddress(WebConfigurationManager.AppSettings["username"]);
            m.To.Add(Utilizador.email);
            m.Subject = "Factura Encomenda Surf Shop";
            m.IsBodyHtml = true;
            m.Body = "Encontra-se em anexo a factura referente à sua compra na Surf Shop. <br> Obrigado";

            //System.Net.Mail.Attachment Attachment;

            m.Attachments.Add(new System.Net.Mail.Attachment(AppDomain.CurrentDomain.BaseDirectory + "\\PDF\\" + nomePDF)); //attachment

            sc.Host = WebConfigurationManager.AppSettings["host"];
            sc.Port = int.Parse(WebConfigurationManager.AppSettings["port"]);
            sc.EnableSsl = true;
            sc.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;

            sc.Credentials = new System.Net.NetworkCredential(WebConfigurationManager.AppSettings["username"], WebConfigurationManager.AppSettings["password"]);
            sc.EnableSsl = true;
            sc.Send(m);
            sc.Dispose();

            return "PDF\\" + nomePDF;
        }


        private void operacoesEncomenda(string PDF)
        {
            SqlConnection myConn = new SqlConnection(checkoutSQLsource.ConnectionString);
            SqlCommand myCommand = new SqlCommand();

            myCommand.Parameters.AddWithValue("IDcliente", Utilizador.userID);
            myCommand.Parameters.AddWithValue("PDF", PDF);

            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.CommandText = "realizarEncomenda";
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

            lbl_qtdTotal.InnerText = "";
            lbl_subtotal.InnerText = "";
            lbl_total.InnerText = "";
            rpt_checkout.DataBind();
        }


        protected void link_compra_Click(object sender, EventArgs e)
        {
            lbl_erros.InnerText = "";

            if(Utilizador.logged == false)
            {
                lbl_erros.InnerText = "Efectue o login ou registe-se para finalizar a encomenda";
                return;
            }

            if (rpt_checkout.Items.Count < 1)
            {
                lbl_erros.InnerText = "Adicione items ao carrinho para efectuar a compra";
                return;
            }

            if (txt_detalheNIF.Text == "")
            {
                lbl_erros.InnerText = "Deve preencher o campo NIF e introduzir um nif válido";
                return;
            }

            if (ck_termos.Checked == false)
            {
                lbl_erros.InnerText = "Necessita de concordar com os termos de venda";
                return;
            }

            operacoesEncomenda(pdf());
        }

        protected void link_pdfEncomenda_Click(object sender, EventArgs e)
        {
            
            if(rpt_checkout.Items.Count > 0)
            {
                pdfCarrinho();
            }
               
        }
    }
}