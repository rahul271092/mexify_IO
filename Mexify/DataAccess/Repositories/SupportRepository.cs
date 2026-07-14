using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Mexify.Web.Models;
using Mexify.Utilities;
using Mexify.Models;

namespace Mexify.DataAccess.Repositories
{
    public class SupportRepository : BaseRepository
    {
        public List<SupportCategory> GetActiveCategories()
        {
            var categories = new List<SupportCategory>();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("SELECT CategoryId, CategoryName, CategorySlug, IconClass, Description FROM SupportCategories WHERE IsActive = 1 ORDER BY SortOrder", conn))
                {
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            categories.Add(new SupportCategory
                            {
                                CategoryId = GetSafeInt(reader, "CategoryId"),
                                CategoryName = GetSafeString(reader, "CategoryName") ?? "",
                                CategorySlug = GetSafeString(reader, "CategorySlug") ?? "",
                                IconClass = GetSafeString(reader, "IconClass") ?? "fas fa-question-circle",
                                Description = GetSafeString(reader, "Description")
                            });
                        }
                    }
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get support categories", ex); }
            return categories;
        }

        public CreateTicketResult CreateTicket(int userId, int categoryId, string subject, string message, int priority = 2)
        {
            var result = new CreateTicketResult();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_CreateSupportTicket", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@Subject", subject);
                    cmd.Parameters.AddWithValue("@Message", message);
                    cmd.Parameters.AddWithValue("@Priority", priority);

                    var outId = new SqlParameter("@TicketId", SqlDbType.BigInt) { Direction = ParameterDirection.Output };
                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMsg = new SqlParameter("@Message2", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                    cmd.Parameters.AddRange(new[] { outId, outSuccess, outMsg });

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    result.Success = outSuccess.Value != DBNull.Value && Convert.ToBoolean(outSuccess.Value);
                    result.Message = outMsg.Value?.ToString() ?? "";
                    result.TicketId = outId.Value != DBNull.Value ? Convert.ToInt64(outId.Value) : 0;
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.Message = "Error: " + ex.Message;
                Logger.Error("Failed to create ticket", ex);
            }
            return result;
        }

        public List<SupportTicket> GetUserTickets(int userId, int statusFilter = -1)
        {
            var tickets = new List<SupportTicket>();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetUserTickets", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@StatusFilter", statusFilter);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            tickets.Add(new SupportTicket
                            {
                                TicketId = GetSafeLong(reader, "TicketId"),
                                TicketNumber = GetSafeString(reader, "TicketNumber") ?? "",
                                Subject = GetSafeString(reader, "Subject") ?? "",
                                Priority = GetSafeInt(reader, "Priority"),
                                PriorityName = GetSafeString(reader, "PriorityName") ?? "",
                                PriorityColor = GetSafeString(reader, "PriorityColor") ?? "muted",
                                Status = GetSafeInt(reader, "Status"),
                                StatusName = GetSafeString(reader, "StatusName") ?? "",
                                StatusColor = GetSafeString(reader, "StatusColor") ?? "muted",
                                CategoryName = GetSafeString(reader, "CategoryName") ?? "",
                                CategoryIcon = GetSafeString(reader, "CategoryIcon") ?? "",
                                MessageCount = GetSafeInt(reader, "MessageCount"),
                                LastMessage = GetSafeString(reader, "LastMessage"),
                                HasNewReply = GetSafeInt(reader, "HasNewReply") == 1,
                                CreatedDate = GetSafeDateTime(reader, "CreatedDate"),
                                LastActivityDate = GetSafeDateTime(reader, "LastActivityDate"),
                                TimeAgo = GetSafeString(reader, "TimeAgo") ?? ""
                            });
                        }
                    }
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get user tickets", ex); }
            return tickets;
        }

        public Tuple<SupportTicket, List<TicketMessage>> GetTicketDetails(long ticketId, int userId)
        {
            SupportTicket ticket = null;
            var messages = new List<TicketMessage>();

            try
            {
                // ... your existing code ...
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to get ticket details", ex);
            }

            return Tuple.Create(ticket, messages);
        }

        public bool AddTicketReply(long ticketId, int userId, string message, out string responseMsg)
        {
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_AddTicketReply", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TicketId", ticketId);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Message", message);

                    var outSuccess = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                    var outMsg = new SqlParameter("@Message2", SqlDbType.NVarChar, 500) { Direction = ParameterDirection.Output };
                    cmd.Parameters.AddRange(new[] { outSuccess, outMsg });

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    responseMsg = outMsg.Value?.ToString() ?? "";
                    return outSuccess.Value != DBNull.Value && Convert.ToBoolean(outSuccess.Value);
                }
            }
            catch (Exception ex)
            {
                responseMsg = "Error: " + ex.Message;
                Logger.Error("Failed to add reply", ex);
                return false;
            }
        }

        public List<FAQItem> GetFAQ(string search = null)
        {
            var faqs = new List<FAQItem>();
            try
            {
                using (var conn = ConnectionManager.GetConnection())
                using (var cmd = new SqlCommand("usp_GetFAQ", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Search", string.IsNullOrWhiteSpace(search) ? (object)DBNull.Value : search);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            faqs.Add(new FAQItem
                            {
                                FAQId = GetSafeInt(reader, "FAQId"),
                                CategoryId = GetSafeInt(reader, "CategoryId"),
                                Question = GetSafeString(reader, "Question") ?? "",
                                Answer = GetSafeString(reader, "Answer") ?? "",
                                ViewCount = GetSafeInt(reader, "ViewCount"),
                                CategoryName = GetSafeString(reader, "CategoryName") ?? "",
                                CategoryIcon = GetSafeString(reader, "CategoryIcon") ?? ""
                            });
                        }
                    }
                }
            }
            catch (Exception ex) { Logger.Error("Failed to get FAQ", ex); }
            return faqs;
        }
    }
}