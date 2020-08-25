using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineShop
{
    public class Utilizador
    {
        public static bool logged { get; set; } = false;
        public static bool revenda { get; set; } = false;

        // DETALHES DE COMPRA
        public static int userID { get; set; } = 1;
        public static string nome { get; set; }
        public static string morada { get; set; }
        public static string email { get; set; }
        public static string empresa { get; set; }
        public static string nif { get; set; }

        //SOCIAL
        public static bool social { get; set; } = false;

    }
}