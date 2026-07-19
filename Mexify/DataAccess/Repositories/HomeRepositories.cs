using System;
using System.Collections.Generic;
using Mexify.Models;
using Mexify.DataAccess;

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
                    UserName = GetSafeString(reader, "UserName") ?? "",
                    UserTitle = GetSafeString(reader, "UserTitle") ?? "",
                    UserImage = GetSafeString(reader, "UserImage") ?? "",
                    Company = GetSafeString(reader, "Company") ?? "",
                    Rating = GetSafeInt(reader, "Rating"),
                    Message = GetSafeString(reader, "Message") ?? "",
                    IsActive = GetSafeBool(reader, "IsActive"),
                    CreatedDate = GetSafeDateTime(reader, "CreatedDate"), // ✅ Reads the column
                    SortOrder = GetSafeInt(reader, "SortOrder")

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