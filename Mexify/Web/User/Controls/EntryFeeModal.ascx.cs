using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web.User.Controls
{
    public partial class EntryFeeModal : System.Web.UI.UserControl
    {
        public string PlatformWalletAddress { get; set; } = "0xYOUR_PLATFORM_WALLET_ADDRESS";
        public string UserWalletAddress { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["WalletAddress"] != null)
            {
                UserWalletAddress = Session["WalletAddress"].ToString();
            }
        }
    }
}