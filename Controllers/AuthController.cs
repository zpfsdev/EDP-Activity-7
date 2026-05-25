using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

namespace GameStore.Controllers
{
    [Route("api/auth")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private Database db = new Database();

        [HttpPost("login")]
        public IActionResult Login([FromForm] string username, [FromForm] string password)
        {
            if (db.OpenConnection())
            {
                string query = "SELECT status, role FROM users WHERE username = @user AND password_hash = MD5(@pass)";
                using MySqlCommand cmd = new MySqlCommand(query, db.Connection);
                cmd.Parameters.AddWithValue("@user", username);
                cmd.Parameters.AddWithValue("@pass", password);

                using var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string status = reader.GetString("status");
                    string role = reader.GetString("role");
                    
                    db.CloseConnection();

                    if (status == "active")
                    {
                        // Set simple cookies for frontend RBAC logic
                        Response.Cookies.Append("username", username);
                        Response.Cookies.Append("role", role);
                        return Redirect("/dashboard.html");
                    }
                }
                db.CloseConnection();
            }
            return Redirect("/login.html?error=invalid");
        }

        [HttpPost("recover")]
        public IActionResult Recover([FromForm] string email)
        {
            if (db.OpenConnection())
            {
                // Set a temporary default password
                string query = "UPDATE users SET password_hash = MD5('defaultpass') WHERE email = @email";
                using MySqlCommand cmd = new MySqlCommand(query, db.Connection);
                cmd.Parameters.AddWithValue("@email", email);

                int rowsAffected = cmd.ExecuteNonQuery();
                db.CloseConnection();

                if (rowsAffected > 0)
                {
                    return Redirect("/login.html?recovered=true");
                }
            }
            return Redirect("/password-recovery.html?error=notfound");
        }
    }
}
