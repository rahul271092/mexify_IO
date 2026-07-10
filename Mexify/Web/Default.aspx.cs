using System;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Web
{
    public partial class Default : System.Web.UI.Page
    {
        private InvestmentService _investmentService;
        private TestimonialService _testimonialService;
        private FAQService _faqService;

        protected void Page_Load(object sender, EventArgs e)
        {
            _investmentService = new InvestmentService();
            _testimonialService = new TestimonialService();
            _faqService = new FAQService();

            if (!IsPostBack)
            {
                LoadHomePageData();
            }
        }

        private void LoadHomePageData()
        {
            try
            {
                // 1. Load Investment Plans
                var plans = _investmentService.GetActivePlans();
                if (plans != null && plans.Count > 0)
                {
                    rptPlans.DataSource = plans;
                    rptPlans.DataBind();
                }

                // 2. Load Testimonials
                var testimonials = _testimonialService.GetActiveTestimonials();
                if (testimonials != null && testimonials.Count > 0)
                {
                    rptTestimonials.DataSource = testimonials;
                    rptTestimonials.DataBind();
                }

                // 3. Load FAQs
                var faqs = _faqService.GetActiveFAQs();
                if (faqs != null && faqs.Count > 0)
                {
                    rptFAQs.DataSource = faqs;
                    rptFAQs.DataBind();
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load homepage data", ex);
            }
        }

        /// <summary>
        /// Helper method to render star ratings HTML for testimonials
        /// </summary>
        protected string RenderStars(object rating)
        {
            int stars = 0;
            if (rating != null && rating != DBNull.Value)
            {
                int.TryParse(rating.ToString(), out stars);
            }

            string html = "";
            for (int i = 1; i <= 5; i++)
            {
                html += i <= stars ? "<i class='fas fa-star'></i> " : "<i class='far fa-star'></i> ";
            }
            return html;
        }
    }
}