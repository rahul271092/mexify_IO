using System;
using System.Collections.Generic;
using Mexify.DataAccess.Repositories;
using Mexify.Models;
using Mexify.Utilities;

namespace Mexify.Business.Services
{
    public class TestimonialService
    {
        private readonly TestimonialRepository _repo = new TestimonialRepository();

        public List<Testimonial> GetActiveTestimonials()
        {
            try { return _repo.GetActiveTestimonials(); }
            catch (Exception ex) { Logger.Error("Failed to get testimonials", ex); return new List<Testimonial>(); }
        }
    }

    public class FAQService
    {
        private readonly FAQRepository _repo = new FAQRepository();

        public List<FAQ> GetActiveFAQs()
        {
            try { return _repo.GetActiveFAQs(); }
            catch (Exception ex) { Logger.Error("Failed to get FAQs", ex); return new List<FAQ>(); }
        }
    }
}