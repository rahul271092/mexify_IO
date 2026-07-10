using System;
using System.Collections.Generic;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class TestimonialRepository : BaseRepository
    {
        public List<Testimonial> GetActiveTestimonials()
        {
            return ExecuteStoredProcedure<Testimonial>(
                "usp_GetActiveTestimonials",
                reader => new Testimonial
                {
                    TestimonialId = GetSafeInt(reader, "TestimonialId"),
                    Name = GetSafeString(reader, "Name") ?? "Anonymous",
                    Designation = GetSafeString(reader, "Designation") ?? "Investor",
                    PhotoUrl = GetSafeString(reader, "PhotoUrl") ?? "https://ui-avatars.com/api/?name=User",
                    Message = GetSafeString(reader, "Message") ?? "",
                    Rating = GetSafeInt(reader, "Rating")
                }
            );
        }
    }

    public class FAQRepository : BaseRepository
    {
        public List<FAQ> GetActiveFAQs()
        {
            return ExecuteStoredProcedure<FAQ>(
                "usp_GetActiveFAQs",
                reader => new FAQ
                {
                    FAQId = GetSafeInt(reader, "FAQId"),
                    Question = GetSafeString(reader, "Question") ?? "",
                    Answer = GetSafeString(reader, "Answer") ?? ""
                }
            );
        }
    }
}