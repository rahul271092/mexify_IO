using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Mexify.Models;

namespace Mexify.Web
{
    public partial class ICO : System.Web.UI.Page
    {
        private Repeater rptFeatured,rptProjects;

        //   Repeater rptFeatured,rptProjects;

        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                LoadProjects();
            }
        }
        private void LoadProjects()
        {
            try
            {
                var service = new ICOService();

                var featured = service.GetFeaturedProjects();

                rptFeatured.DataSource = service.GetFeaturedProjects();
                rptFeatured.DataBind();
                rptProjects.DataSource = service.GetAllProjects();
                rptProjects.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load ICO projects", ex);
            }
        }

        protected string GetStatusSlug(object status)
        {
            if (status == null || status == DBNull.Value) return "upcoming";

            int s;
            if (!int.TryParse(status.ToString(), out s)) return "upcoming";

            switch (s)
            {
                case 0: return "upcoming";
                case 1: return "live";
                case 2: return "completed";
                default: return "upcoming";
            }
        }


        public string GetStatusClass(object status)
        {
            int s = Convert.ToInt32(status);
            if (s == 0) return "status-upcoming";
            if (s == 1) return "status-live";
            return "status-completed";
        }

        public string GetStatusLabel(object status)
        {
            int s = Convert.ToInt32(status);
            if (s == 0) return "🟡 Upcoming";
            if (s == 1) return "🔴 Live";
            return "⚪ Completed";
        }

     

        public string GetButtonLabel(object status)
        {
            int s = Convert.ToInt32(status);
            if (s == 0) return "<i class='fas fa-bell me-2'></i> Get Notified";
            if (s == 1) return "<i class='fas fa-bolt me-2'></i> Participate Now";
            return "<i class='fas fa-chart-line me-2'></i> View Performance";
        }
    }
}