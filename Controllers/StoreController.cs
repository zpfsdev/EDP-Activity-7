using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using System.Data;
using System;
using System.Collections.Generic;

namespace GameStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StoreController : ControllerBase
    {
        private Database db = new Database();

        // Calls the Stored Procedure: RegisterUserAndPurchase
        [HttpPost("purchase")]
        public IActionResult RegisterAndPurchase([FromForm] string username, [FromForm] string email, [FromForm] int age, [FromForm] string country, [FromForm] int gameId, [FromForm] decimal amount, [FromForm] string paymentMethod)
        {
            try
            {
                if (!db.OpenConnection())
                    return BadRequest(new { success = false, message = "Database connection failed." });

                using (var cmd = new MySqlCommand("RegisterUserAndPurchase", db.Connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@newUsername", username);
                    cmd.Parameters.AddWithValue("@newEmail", email);
                    cmd.Parameters.AddWithValue("@regDate", DateTime.Now.Date);
                    cmd.Parameters.AddWithValue("@regCountry", country);
                    cmd.Parameters.AddWithValue("@regAge", age);
                    cmd.Parameters.AddWithValue("@purchasedGameId", gameId);
                    cmd.Parameters.AddWithValue("@paidAmount", amount);
                    cmd.Parameters.AddWithValue("@payMethod", paymentMethod);
                    
                    cmd.ExecuteNonQuery();
                }
                
                db.CloseConnection();
                return Ok(new { success = true, message = "User registered and purchase successful!" });
            }
            catch (Exception ex)
            {
                db.CloseConnection();
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        // Calls the Function: GetAverageRatingByTitle
        [HttpGet("rating")]
        public IActionResult GetGameRating([FromQuery] string title)
        {
            try
            {
                decimal rating = 0;
                if (!db.OpenConnection())
                    return BadRequest(new { success = false, message = "Database connection failed." });

                using (var cmd = new MySqlCommand("SELECT GetAverageRatingByTitle(@title)", db.Connection))
                {
                    cmd.Parameters.AddWithValue("@title", title);
                    var result = cmd.ExecuteScalar();
                    if (result != DBNull.Value && result != null)
                    {
                        rating = Convert.ToDecimal(result);
                    }
                }
                
                db.CloseConnection();
                
                if (rating > 0)
                {
                    return Ok(new { success = true, title = title, rating = rating });
                }
                else
                {
                    return Ok(new { success = false, message = "Game not found or has no ratings." });
                }
            }
            catch (Exception ex)
            {
                db.CloseConnection();
                return BadRequest(new { success = false, message = ex.Message });
            }
        }
        
        // Helper to fetch games for the dropdown
        [HttpGet("games")]
        public IActionResult GetGames()
        {
            try
            {
                var games = new List<object>();
                if (!db.OpenConnection())
                    return BadRequest(new { success = false, message = "Database connection failed." });

                using (var cmd = new MySqlCommand("SELECT gameId, title, price FROM games", db.Connection))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        games.Add(new {
                            id = reader.GetInt32("gameId"),
                            title = reader.GetString("title"),
                            price = reader.GetDecimal("price")
                        });
                    }
                }
                
                db.CloseConnection();
                return Ok(games);
            }
            catch (Exception ex)
            {
                db.CloseConnection();
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        // Helper to fetch companies for the dropdown
        [HttpGet("companies")]
        public IActionResult GetCompanies()
        {
            try
            {
                var companies = new List<object>();
                if (!db.OpenConnection())
                    return BadRequest(new { success = false, message = "Database connection failed." });

                using (var cmd = new MySqlCommand("SELECT companyId, name FROM companies", db.Connection))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        companies.Add(new {
                            id = reader.GetInt32("companyId"),
                            name = reader.GetString("name")
                        });
                    }
                }
                
                db.CloseConnection();
                return Ok(companies);
            }
            catch (Exception ex)
            {
                db.CloseConnection();
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        // Transaction: Add Game
        [HttpPost("game")]
        public IActionResult AddGame([FromForm] string title, [FromForm] int companyId, [FromForm] string genre, [FromForm] int releaseYear, [FromForm] decimal price)
        {
            try
            {
                if (!db.OpenConnection())
                    return BadRequest(new { success = false, message = "Database connection failed." });

                using (var cmd = new MySqlCommand("INSERT INTO games (title, companyId, genre, releaseYear, price) VALUES (@title, @companyId, @genre, @releaseYear, @price)", db.Connection))
                {
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@companyId", companyId);
                    cmd.Parameters.AddWithValue("@genre", genre);
                    cmd.Parameters.AddWithValue("@releaseYear", releaseYear);
                    cmd.Parameters.AddWithValue("@price", price);
                    
                    cmd.ExecuteNonQuery();
                }
                
                db.CloseConnection();
                return Ok(new { success = true, message = "Game added to inventory successfully!" });
            }
            catch (Exception ex)
            {
                db.CloseConnection();
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        // Transaction: Add Review
        [HttpPost("review")]
        public IActionResult AddReview([FromForm] string username, [FromForm] int gameId, [FromForm] int rating, [FromForm] string reviewText)
        {
            try
            {
                if (!db.OpenConnection())
                    return BadRequest(new { success = false, message = "Database connection failed." });

                int userId = 0;
                using (var cmd = new MySqlCommand("SELECT user_id FROM users WHERE username = @username LIMIT 1", db.Connection))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    var result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        userId = Convert.ToInt32(result);
                    }
                }

                if (userId == 0)
                {
                    db.CloseConnection();
                    return BadRequest(new { success = false, message = "User not found. Please register first." });
                }

                using (var cmd = new MySqlCommand("INSERT INTO reviews (userId, gameId, rating, reviewText, reviewDate) VALUES (@userId, @gameId, @rating, @reviewText, @reviewDate)", db.Connection))
                {
                    cmd.Parameters.AddWithValue("@userId", userId);
                    cmd.Parameters.AddWithValue("@gameId", gameId);
                    cmd.Parameters.AddWithValue("@rating", rating);
                    cmd.Parameters.AddWithValue("@reviewText", reviewText);
                    cmd.Parameters.AddWithValue("@reviewDate", DateTime.Now.Date);
                    
                    cmd.ExecuteNonQuery();
                }
                
                db.CloseConnection();
                return Ok(new { success = true, message = "Review submitted successfully!" });
            }
            catch (Exception ex)
            {
                db.CloseConnection();
                return BadRequest(new { success = false, message = ex.Message });
            }
        }
    }
}
