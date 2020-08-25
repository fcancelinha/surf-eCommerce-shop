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
                        "471126422232-va6ngpf754qqf1m3qi48tb0ogqi1gadn.apps.googleusercontent.com",
                        "2nY8CWl2E10QTrDcaITg8x10"
                );

            OAuthManager.RegisterClient(

                        "facebook",
                        "303591377373779",
                        "a1c351552ae7b285bd410c72b5db0524"
                );

            OAuthManager.RegisterClient(

                        "github",
                        "10d3bb7da759c244e45c",
                        "e59d4c4df61e645f3123d3ab67e6ebc45e386454"
               );
        }

        public static bool registry { get; set; } = false;

    }
}