using Mexify.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Repositories
{
    public class CMSRepository :BaseRepository
    {

        /// <summary>
        /// Gets all active testimonials.
        /// </summary>
        public List<Testimonial> GetActiveTestimonials()
        {
            return ExecuteStoredProcedure(
                "usp_GetActiveTestimonials",
                MapTestimonial
            );
        }

        /// <summary>
        /// Gets all active FAQs.
        /// </summary>
        public List<FAQ> GetActiveFAQs()
        {
            return ExecuteStoredProcedure(
                "usp_GetActiveFAQs",
                MapFAQ
            );
        }

        /// <summary>
        /// Adds a newsletter subscriber.
        /// </summary>
        public void AddNewsletterSubscriber(string email)
        {
            ExecuteStoredProcedureNonQuery(
                "usp_AddNewsletterSubscriber",
                CreateParameter("@Email", email)
            );
        }

        /// <summary>
        /// Maps SqlDataReader to Testimonial object.
        /// </summary>
        private Testimonial MapTestimonial(SqlDataReader reader)
        {
            return new Testimonial
            {
                TestimonialId = reader.GetInt32(reader.GetOrdinal("TestimonialId")),
                Name = reader.GetString(reader.GetOrdinal("UserName")),
                Designation = reader.IsDBNull(reader.GetOrdinal("Designation")) ? null : reader.GetString(reader.GetOrdinal("Designation")),
                Company = reader.IsDBNull(reader.GetOrdinal("Company")) ? null : reader.GetString(reader.GetOrdinal("Company")),
                Message = reader.GetString(reader.GetOrdinal("Message")),
                PhotoUrl = reader.IsDBNull(reader.GetOrdinal("PhotoUrl")) ? null : reader.GetString(reader.GetOrdinal("PhotoUrl")),
                Rating = reader.GetInt32(reader.GetOrdinal("Rating")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive"))
            };
        }

        /// <summary>
        /// Maps SqlDataReader to FAQ object.
        /// </summary>
        private FAQ MapFAQ(SqlDataReader reader)
        {
            return new FAQ
            {
                FAQId = reader.GetInt32(reader.GetOrdinal("FAQId")),
                Question = reader.GetString(reader.GetOrdinal("Question")),
                Answer = reader.GetString(reader.GetOrdinal("Answer")),
                Category = reader.IsDBNull(reader.GetOrdinal("Category")) ? null : reader.GetString(reader.GetOrdinal("Category")),
                SortOrder = reader.GetInt32(reader.GetOrdinal("SortOrder")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive"))
            };
        }
    }
}