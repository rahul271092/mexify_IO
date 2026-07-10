using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.Web.Models
{
    public class BlogPost
    {
        public long BlogId { get; set; }
        public string Title { get; set; }
        public string Slug { get; set; }
        public string Content { get; set; }
        public string Excerpt { get; set; }
        public string FeaturedImage { get; set; }
        public string Tags { get; set; }
        public int AuthorId { get; set; }
        public string AuthorName { get; set; }
        public string AuthorPhoto { get; set; }
        public string AuthorBio { get; set; }
        public string AuthorFullBio { get; set; }
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string CategorySlug { get; set; }
        public int ViewCount { get; set; }
        public int ReadTime { get; set; }
        public bool IsPublished { get; set; }
        public bool IsFeatured { get; set; }
        public DateTime CreatedDate { get; set; }
    }


    public class BlogCategory
    {
        public int CategoryId { get; set; }
        public string Name { get; set; }
        public string Slug { get; set; }
        public int PostCount { get; set; }
    }

    public class BlogComment
    {
        public long CommentId { get; set; }
        public long BlogId { get; set; }
        public int? UserId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Comment { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}