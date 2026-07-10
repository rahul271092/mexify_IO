using Mexify.Business.Services;
using Mexify.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Mexify.Web
{
    public partial class about : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                InitializePage();
            }
        }


        private void InitializePage()
        {
            try
            {
                LoadTeamMembers();
                LoadTimeline();
                LoadCertificates();
            }
            catch (Exception ex)
            {
                Logger.Error("About Page Initialization Failed", ex);
            }
        }

        private void LoadTeamMembers()
        {
            try
            {
                var aboutService = new AboutService();
                rptTeam.DataSource = aboutService.GetActiveTeamMembers();
                rptTeam.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load team members", ex);
            }
        }

        private void LoadTimeline()
        {
            try
            {
                var aboutService = new AboutService();
                rptTimeline.DataSource = aboutService.GetActiveTimeline();
                rptTimeline.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load timeline", ex);
            }
        }

        private void LoadCertificates()
        {
            try
            {
                var aboutService = new AboutService();
                rptCertificates.DataSource = aboutService.GetActiveCertificates();
                rptCertificates.DataBind();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load certificates", ex);
            }
        }
    }
}