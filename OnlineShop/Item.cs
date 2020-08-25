using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineShop
{
    public class Item
    {
        public string titulo { get; set; }
        public int qtd { get; set; }
        public double preco { get; set; }
        public double total { get; set; }
        public string descricao { get; set; }
        public static List<Item> listaitems { get; set; }

    }
}