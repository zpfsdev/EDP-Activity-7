using MySql.Data.MySqlClient;
using System.Data;

namespace GameStore
{
    public class Database
    {
        public MySqlConnection Connection { get; private set; }
        private string connectionString = "Server=localhost;Database=gamestore;Uid=root;Pwd=;";

        public Database()
        {
            Connection = new MySqlConnection(connectionString);
        }

        public bool OpenConnection()
        {
            try
            {
                if (Connection.State == ConnectionState.Closed)
                    Connection.Open();
                return true;
            }
            catch
            {
                return false;
            }
        }

        public void CloseConnection()
        {
            if (Connection.State == ConnectionState.Open)
                Connection.Close();
        }
    }
}
