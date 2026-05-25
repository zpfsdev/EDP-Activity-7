using System;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace GameStore.Controllers
{
    [Route("api/dashboard")]
    [ApiController]
    public class DashboardController : ControllerBase
    {
        private Database db = new Database();

        [HttpGet("metrics")]
        public IActionResult GetMetrics()
        {
            int totalGames = 0;
            int activeUsers = 0;
            decimal systemRevenue = 0.0m;

            if (db.OpenConnection())
            {
                using var cmd1 = new MySqlCommand("SELECT COUNT(*) FROM games", db.Connection);
                totalGames = Convert.ToInt32(cmd1.ExecuteScalar());

                using var cmd2 = new MySqlCommand("SELECT COUNT(*) FROM users WHERE status = 'active'", db.Connection);
                activeUsers = Convert.ToInt32(cmd2.ExecuteScalar());

                using var cmd3 = new MySqlCommand("SELECT COALESCE(SUM(amount), 0) FROM purchases", db.Connection);
                systemRevenue = Convert.ToDecimal(cmd3.ExecuteScalar());

                db.CloseConnection();
            }
            return Ok(new { totalGames, activeUsers, systemRevenue });
        }

        [HttpGet("activity")]
        public IActionResult GetActivity()
        {
            var activities = new List<object>();
            if (db.OpenConnection())
            {
                using var cmd = new MySqlCommand("SELECT log_id, action, table_name, timestamp FROM activity_log ORDER BY timestamp DESC LIMIT 20", db.Connection);
                using var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    activities.Add(new
                    {
                        log_id = reader.GetInt32("log_id"),
                        action = reader.GetString("action"),
                        table_name = reader.GetString("table_name"),
                        timestamp = reader.GetDateTime("timestamp").ToString("yyyy-MM-dd HH:mm:ss")
                    });
                }
                db.CloseConnection();
            }
            return Ok(activities);
        }
    }
}
