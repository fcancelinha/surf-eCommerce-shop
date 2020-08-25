using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace OnlineShop
{
    public partial class backoffice1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["aNome"] == null)
                Response.Redirect("backofficeLogin.aspx");

            lbl_adminNome.Text = Session["aNome"].ToString();
        }

        protected void link_logout_Click(object sender, EventArgs e)
        {

            Session["aNome"] = null;
            Session["adminTipo"] = null;

            Response.Redirect("backofficeLogin.aspx");

        }
    }
}