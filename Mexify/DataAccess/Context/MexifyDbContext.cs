using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Mexify.DataAccess.Context
{
    public class MexifyDbContext
    {
        public MexifyDbContext() 
        {
      //      this.Configuration.LazyLoadingEnabled = false;
       //     this.Configuration.ProxyCreationEnabled = false;
        }

        //public DbSet<InvestmentPlan> InvestmentPlans { get; set; }
        //public DbSet<Testimonial> Testimonials { get; set; }
        //public DbSet<FAQ> FAQs { get; set; }

        //protected override void OnModelCreating(DbModelBuilder modelBuilder)
        //{
        //    modelBuilder.Conventions.Remove<System.Data.Entity.ModelConfiguration.Conventions.PluralizingTableNameConvention>();

        //    // Match SQL DECIMAL(24,8) for all decimal properties
        //    modelBuilder.Properties()
        //        .Where(p => p.PropertyType == typeof(decimal))
        //        .Configure(c => c.HasPrecision(24, 8));

        //    // Map Testimonial to Testimonials table
        //    modelBuilder.Entity<Testimonial>().ToTable("Testimonials");
        //    modelBuilder.Entity<FAQ>().ToTable("FAQs");
        //    modelBuilder.Entity<InvestmentPlan>().ToTable("InvestmentPlans");

        //    base.OnModelCreating(modelBuilder);
        //}
    }
}