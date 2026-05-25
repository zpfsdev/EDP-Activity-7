using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace GameStore.Controllers
{
    [Route("api/users")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private Database db = new Database();

        // Account List / Search
        [HttpGet("search")]
        public IActionResult SearchUsers([FromQuery] string q = "")
        {
            var users = new List<object>();

            if (db.OpenConnection())
            {
                string query = "SELECT user_id, username, email, role, status FROM users WHERE username LIKE @q OR email LIKE @q";
                using MySqlCommand cmd = new MySqlCommand(query, db.Connection);
                cmd.Parameters.AddWithValue("@q", "%" + q + "%");

                using MySqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    users.Add(new
                    {
                        user_id = reader.GetInt32("user_id"),
                        username = reader.GetString("username"),
                        email = reader.GetString("email"),
                        role = reader.GetString("role"),
                        status = reader.GetString("status")
                    });
                }
                db.CloseConnection();
            }
            return Ok(users);
        }

        // Add Account
        [HttpPost("add")]
        public IActionResult AddUser([FromForm] string username, [FromForm] string email, [FromForm] string role)
        {
            if (db.OpenConnection())
            {
                string query = "INSERT INTO users (username, email, password_hash, role, status) VALUES (@user, @email, MD5('defaultpass'), @role, 'active')";
                using MySqlCommand cmd = new MySqlCommand(query, db.Connection);
                cmd.Parameters.AddWithValue("@user", username);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@role", role);
                cmd.ExecuteNonQuery();
                db.CloseConnection();
            }
            return Redirect("/user-management.html");
        }

        // Update Account Profile
        [HttpPost("update")]
        public IActionResult UpdateUser([FromForm] int user_id, [FromForm] string username, [FromForm] string email)
        {
            if (db.OpenConnection())
            {
                string query = "UPDATE users SET username = @user, email = @email WHERE user_id = @id";
                using MySqlCommand cmd = new MySqlCommand(query, db.Connection);
                cmd.Parameters.AddWithValue("@user", username);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@id", user_id);
                cmd.ExecuteNonQuery();
                db.CloseConnection();
            }
            return Redirect("/user-management.html");
        }

        // Active / Inactive Account
        [HttpPost("status")]
        public IActionResult UpdateStatus([FromForm] int user_id, [FromForm] string status)
        {
            if (db.OpenConnection())
            {
                string query = "UPDATE users SET status = @status WHERE user_id = @id";
                using MySqlCommand cmd = new MySqlCommand(query, db.Connection);
                cmd.Parameters.AddWithValue("@status", status);
                cmd.Parameters.AddWithValue("@id", user_id);
                cmd.ExecuteNonQuery();
                db.CloseConnection();
            }
            return Redirect("/user-management.html");
        }
    }
}
