using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Mexify.Business.Services;
using Mexify.Models;
using Mexify.Utilities;
using Mexify.Web.Models;
using System.Data.SqlClient;
using System.Data;

namespace Mexify.Web.User
{
    public partial class MintNFT : System.Web.UI.Page
    {
        private NFTService _nftService;
        private WalletService _walletService;
        private int _userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Web/MetaMaskLogin.aspx");
                return;
            }

            _userId = Convert.ToInt32(Session["UserId"]);
            _nftService = new NFTService();
            _walletService = new WalletService();

            if (!IsPostBack)
            {
                CheckURLAction();

                GetActiveNFTCollection();
                LoadUserBalance();

            }
        }


        public void GetActiveNFTCollection()
        {
            try
            {
                string sql = "usp_GetActiveCollections";
                SqlCommand cmd = Web.Models.Connection.Sql(sql);
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                if(dt.Rows.Count>0)
                {
                    rptCollections.DataSource = dt;
                    rptCollections.DataBind();
                    ddlCollection.DataSource = dt;
                    ddlCollection.DataTextField = "CollectionName";
                    ddlCollection.DataValueField = "CollectionId";
                    ddlCollection.DataBind();
                    ddlCollection.Items.Insert(0, "Select NFT Collection");
                    pnlNoCollections.Visible = false;

                }
                else
                {
                    pnlNoCollections.Visible = true;
                }
            }
            catch(Exception ef)
            {
                Logger.Error("GET ACTIVE NFT COLLECTION", ef);

            }
            finally
            {
                Web.Models.Connection.CloseConnection();
            }

        }


        public List<NFTCollection> GetNFTCollection()
        {
            List<NFTCollection> collection = new List<NFTCollection>();
            try
            {
                string sql = "usp_GetActiveCollections";
                using (SqlCommand cmd = Web.Models.Connection.Sql(sql))
                {
                    cmd.Parameters.AddWithValue("@UserId", Session["UserId"].ToString());
                    SqlDataReader sdr = cmd.ExecuteReader();
                    if(sdr.HasRows)
                    {
                        while(sdr.Read())
                        {
                          NFTCollection obj=  new NFTCollection()
                            {
                                IsFeatured = Boolean.Parse(sdr["IsFeatured"].ToString()),
                                ImageUrl = sdr["ImageUrl"].ToString(),
                                CollectionName = sdr["CollectionName"].ToString(),
                                IsActive=Boolean.Parse( sdr["IsFeatured"].ToString()),
                                CreatorName=sdr["CreatorName"].ToString(),
                                TotalItems=Int32.Parse(sdr["TotalItems"].ToString()),
                                MintPrice= Decimal.Parse(sdr["MintPrice"].ToString()),
                                MaxItems=Int32.Parse(sdr["MaxItems"].ToString()),
                                CollectionId=Int32.Parse(sdr["collectionId"].ToString()),
                                Blockchain=sdr["Blockchain"] as string,

                            };

                            collection.Add(obj);
                        }
                    }
                    sdr.Close();

                    ddlCollection.DataSource = collection;
                    ddlCollection.DataBind();

                }
            }
            catch(Exception ef)
            {
                Logger.Error("GET NFT Collection Function Error:", ef);
            }
            finally
            {
                Web.Models.Connection.CloseConnection();
            }
            return collection;
        }

        private void CheckURLAction()
        {
            string action = Request.QueryString["action"];
            string collectionId = Request.QueryString["collectionId"];
            string ImageUrl = Request.QueryString["url"];
            if (action == "mint" && !string.IsNullOrEmpty(collectionId))
            {
                int id;
                if (int.TryParse(collectionId, out id))
                {
                    try
                    {

                        ddlCollection.SelectedValue = id.ToString();
                        ddlCollection_SelectedIndexChanged(null, EventArgs.Empty);
                        mintPreviewImage.ImageUrl = ImageUrl;
                    }
                    catch { }
                }
            }
        }

        private void LoadNFTData()
        {
            try
            {
                // Load collections dropdown
                var collections = _nftService.GetActiveCollections();
                ddlCollection.DataSource = collections;
                ddlCollection.DataTextField = "DisplayName";
                ddlCollection.DataValueField = "CollectionId";
                ddlCollection.DataBind();
                ddlCollection.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Collection --", "0"));

                // Load collections grid
                if (collections != null && collections.Count > 0)
                {
                    rptCollections.DataSource = collections;
                    rptCollections.DataBind();
                    pnlNoCollections.Visible = false;

                    // Stats
                    int totalItems = 0;
                    int totalHolders = 0;
                    decimal floorPrice = decimal.MaxValue;

                    foreach (var c in collections)
                    {
                        totalItems += c.TotalItems;
                        totalHolders += c.HoldersCount;
                        if (c.MintPrice > 0 && c.MintPrice < floorPrice)
                            floorPrice = c.MintPrice;
                    }

                    litTotalCollections.Text = collections.Count.ToString();
                    litTotalMinted.Text = totalItems.ToString();
                    litTotalHolders.Text = totalHolders.ToString();
                    litFloorPrice.Text = (floorPrice == decimal.MaxValue ? 0 : floorPrice).ToString("0.00");
                }
                else
                {
                    pnlNoCollections.Visible = true;
                }

                // Load user's NFTs
                var myNFTs = _nftService.GetUserNFTs(_userId);
                litMyNFTCount.Text = (myNFTs?.Count ?? 0).ToString();

                if (myNFTs != null && myNFTs.Count > 0)
                {
                    rptMyNFTs.DataSource = myNFTs;
                    rptMyNFTs.DataBind();
                    pnlNoNFTs.Visible = false;
                }
                else
                {
                    pnlNoNFTs.Visible = true;
                }

                // Load history
                var history = _nftService.GetMintHistory(_userId, 50);
                if (history != null && history.Count > 0)
                {
                    rptHistory.DataSource = history;
                    rptHistory.DataBind();
                    pnlNoHistory.Visible = false;
                }
                else
                {
                    pnlNoHistory.Visible = true;
                }

                // Load user balance
                LoadUserBalance();
            }
            catch (Exception ex)
            {
                Logger.Error("MintNFT page load failed for user " + _userId, ex);
            }
        }

        private void LoadUserBalance()
        {
            try
            {
                decimal pncBalance = 0;
                var wallets = _walletService.GetUserWallets(_userId);
                if (wallets != null)
                {
                    foreach (var w in wallets)
                    {
                        if (w.CurrencyCode == "USDT" || w.CurrencyId == 6)
                        {
                            pncBalance = w.Balance;
                            break;
                        }
                    }
                }
                litUserBalance.Text = pncBalance.ToString("0.00");
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load user balance", ex);
            }
        }

        protected void ddlCollection_SelectedIndexChanged(object sender, EventArgs e)
        {
            HideMessages();

            int collectionId;
            if (!int.TryParse(ddlCollection.SelectedValue, out collectionId) || collectionId == 0)
            {
                litMintPrice.Text = "0.00";
                litTotalPrice.Text = "0.00";
                hfMintPrice.Value = "0";
                return;
            }

            try
            {
                var collection = _nftService.GetCollectionById(collectionId);
                if (collection != null)
                {
                    litMintPrice.Text = collection.MintPrice.ToString("0.00");
                    hfMintPrice.Value = collection.MintPrice.ToString();
                    mintPreviewImage.ImageUrl = collection.ImageUrl.ToString();
                    litGasFee.Text = "0.50";
                    hfGasFee.Value = "0.5";
                    litTotalPrice.Text = (collection.MintPrice + 0.5m).ToString("0.00");
                    litQuantity.Text = "1";
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Failed to load collection details", ex);
            }
        }

        protected void btnMint_Click(object sender, EventArgs e)
        {
            HideMessages();

            try
            {
                int collectionId;
                if (!int.TryParse(ddlCollection.SelectedValue, out collectionId) || collectionId == 0)
                {
                    ShowMintError("Please select a collection.");
                    return;
                }

                string nftName = txtNFTName.Text.Trim();
                if (string.IsNullOrWhiteSpace(nftName))
                {
                    ShowMintError("Please enter a name for your NFT.");
                    return;
                }

                int quantity;
                if (!int.TryParse(txtQuantity.Text, out quantity) || quantity < 1 || quantity > 10)
                {
                    ShowMintError("Quantity must be between 1 and 10.");
                    return;
                }

                string recipientAddress = txtRecipientAddress.Text.Trim();
                string description = txtNFTDescription.Text.Trim();

                var result = _nftService.MintNFT(new MintNFTRequest
                {
                    UserId = Int32.Parse(Session["UserID"].ToString()),
                    CollectionId = collectionId,
                    NFTName = nftName,
                    Description = description,
                    Quantity = quantity,
                    RecipientAddress = string.IsNullOrEmpty(recipientAddress) ? null : recipientAddress
                });

                if (result.Success)
                {
                    ShowMintSuccess($"Successfully minted {quantity} NFT(s)! Token ID: #{result.TokenId}. Transaction hash: {GetTxHashShort(result.TxHash)}");

                    // Reset form
                    txtNFTName.Text = "";
                    txtNFTDescription.Text = "";
                    txtQuantity.Text = "1";
                    txtRecipientAddress.Text = "";

                    // Reload data
                    LoadNFTData();
                }
                else
                {
                    ShowMintError(result.ErrorMessage ?? "Failed to mint NFT. Please try again.");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("Mint NFT failed for user " + _userId, ex);
                ShowMintError("An error occurred: " + ex.Message);
            }
        }

        // =========================================
        // ✅ HELPER METHODS FOR REPEATERS
        // =========================================

        public string GetCollectionImage(object imageUrl, object name)
        {
            if (imageUrl != null && !string.IsNullOrEmpty(imageUrl.ToString()))
            {
                return $"<img src='{imageUrl}' alt='{name}' />";
            }
            return "<i class='fas fa-image'></i>";
        }

        public string GetNFTImage(object imageUrl, object name)
        {
            if (imageUrl != null && !string.IsNullOrEmpty(imageUrl.ToString()))
            {
                return $"<img src='{imageUrl}' alt='{name}' />";
            }
            return "<i class='fas fa-image'></i>";
        }

        public string GetStatusClass(object status)
        {
            int s = 0;
            if (status != null && status != DBNull.Value) int.TryParse(status.ToString(), out s);
            switch (s)
            {
                case 1: return "status-completed";
                case 0: return "status-pending";
                case 2: return "status-failed";
                default: return "status-pending";
            }
        }

        public string GetTxHashShort(object txHash)
        {
            if (txHash == null || string.IsNullOrEmpty(txHash.ToString())) return "—";
            string hash = txHash.ToString();
            return hash.Length > 10 ? hash.Substring(0, 10) + "..." : hash;
        }

        // ✅ Public properties for JavaScript
        public string MintPrice => hfMintPrice.Value ?? "0";
        public string GasFee => hfGasFee.Value ?? "0.5";

        // ✅ Message helpers
        private void ShowMintError(string message)
        {
            pnlMintError.Visible = true;
            litMintError.Text = message;
        }

        private void ShowMintSuccess(string message)
        {
            pnlMintSuccess.Visible = true;
            litMintSuccess.Text = message;
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litError.Text = message;
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            litSuccess.Text = message;
        }

        private void HideMessages()
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
            pnlMintError.Visible = false;
            pnlMintSuccess.Visible = false;
        }
    }
}