using Mexify.DataAccess.Context;
using Mexify.DataAccess.Repositories;
using Mexify.Utilities;
using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Business.Services
{
    public class CMSService
    {

        //public List<Testimonial> GetActiveTestimonials()
        //{
        //    try
        //    {
        //        using (var context = new MexifyDbContext())
        //        {
        //            return context.Testimonials
        //                .Where(t => t.IsActive)
        //                .OrderByDescending(t => t.Rating)
        //                .ToList();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Utilities.Logger.Error("Failed to load testimonials", ex);
        //        return new List<Testimonial>();
        //    }
        //}

        //public List<FAQ> GetActiveFAQs()
        //{
        //    try
        //    {
        //        using (var context = new MexifyDbContext())
        //        {
        //            return context.FAQs
        //                .Where(f => f.IsActive)
        //                .OrderBy(f => f.SortOrder)
        //                .ToList();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Mexify.Utilities.Logger.Error("Failed to load FAQs", ex);
        //        return new List<FAQ>();
        //    }
        //}

        //public void AddNewsletterSubscriber(string email)
        //{
        //    // TODO: Implement newsletter subscription logic
        //    Mexify.Utilities.Logger.Info($"Newsletter subscription: {email}");
        //}


        private readonly CMSRepository _repository;

        public CMSService()
        {
            _repository = new CMSRepository();
        }

        /// <summary>
        /// Gets all active testimonials.
        /// </summary>
        public List<Testimonial> GetActiveTestimonials()
        {
            try
            {
                return _repository.GetActiveTestimonials();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load testimonials", ex);
                return new List<Testimonial>();
            }
        }

        /// <summary>
        /// Gets all active FAQs.
        /// </summary>
        public List<FAQ> GetActiveFAQs()
        {
            try
            {
                return _repository.GetActiveFAQs();
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load FAQs", ex);
                return new List<FAQ>();
            }
        }

        /// <summary>
        /// Adds a newsletter subscriber.
        /// </summary>
        public void AddNewsletterSubscriber(string email)
        {
            try
            {
                _repository.AddNewsletterSubscriber(email);
                Logger.Info($"Newsletter subscription added: {email}");
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to add newsletter subscriber: {email}", ex);
                throw;
            }
        }



        public List<FAQ> GetFAQsByPage(string page)
        {
            try
            {
                return _repository.ExecuteStoredProcedure<FAQ>(
                    "usp_GetFAQsByPage",
                    reader => new FAQ
                    {
                        FAQId = _repository.GetSafeInt(reader, "FAQId"),
                        Question = _repository.GetSafeString(reader, "Question"),
                        Answer = _repository.GetSafeString(reader, "Answer"),
                        Category = _repository.GetSafeString(reader, "Category"),
                        SortOrder = _repository.GetSafeInt(reader, "SortOrder"),
                        IsActive = _repository.GetSafeBool(reader, "IsActive")
                    },
                    _repository.CreateParameter("@Page", page),
                    _repository.CreateParameter("@Category", DBNull.Value)
                );
            }
            catch (Exception ex)
            {
                Logger.Error($"Failed to load FAQs for page {page}", ex);
                return new List<FAQ>();
            }
        }

    }
}