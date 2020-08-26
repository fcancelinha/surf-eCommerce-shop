using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using Nemiro.OAuth;
using Nemiro.OAuth.Clients;

namespace OnlineShop
{
    public class Authentication
    {
        //Registar os vários serviços usados para autenticação
        public static void initiateAuth()
        {

             OAuthManager.RegisterClient(

                        "google",
                        "***********",
                        "***********"
                );

            OAuthManager.RegisterClient(

                        "facebook",
                        "***********",
                        "***********"
                );
            
        }

        public static bool registry { get; set; } = false;

    }
}
