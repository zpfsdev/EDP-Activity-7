using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;
using OfficeOpenXml;
using OfficeOpenXml.Drawing.Chart;

namespace GameStore.Controllers
{
    [Route("api/reports")]
    [ApiController]
    public class ReportController : ControllerBase
    {
        private Database db = new Database();

        public ReportController()
        {
            ExcelPackage.License.SetNonCommercialPersonal("GameStore");
        }

        [HttpGet("data")]
        public IActionResult GetData([FromQuery] string reportType)
        {
            if (reportType != "companysalesreport" && reportType != "mostpopulargames" && reportType != "topratedgames")
                return BadRequest(new { success = false, message = "Invalid report type." });

            try
            {
                if (!db.OpenConnection()) return BadRequest(new { success = false, message = "Database connection failed." });

                var columns = new List<string>();
                var rows = new List<Dictionary<string, object>>();

                string query = $"SELECT * FROM {reportType} LIMIT 100";
                using var cmd = new MySqlCommand(query, db.Connection);
                using var reader = cmd.ExecuteReader();

                for (int i = 0; i < reader.FieldCount; i++)
                {
                    columns.Add(reader.GetName(i));
                }

                while (reader.Read())
                {
                    var row = new Dictionary<string, object>();
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        row[columns[i]] = reader.GetValue(i);
                    }
                    rows.Add(row);
                }
                
                db.CloseConnection();
                return Ok(new { success = true, columns, data = rows });
            }
            catch (Exception ex)
            {
                db.CloseConnection();
                return BadRequest(new { success = false, message = ex.Message });
            }
        }

        [HttpPost("generate")]
        public IActionResult GenerateReport([FromForm] string reportType, [FromForm] string exportFormat)
        {
            if (reportType != "companysalesreport" && reportType != "mostpopulargames" && reportType != "topratedgames")
                return BadRequest("Invalid report type.");

            if (exportFormat == "excel")
            {
                return GenerateExcelReport(reportType);
            }

            return BadRequest("Only Excel export is supported currently.");
        }

        private IActionResult GenerateExcelReport(string reportType)
        {
            try
            {
                using var package = new ExcelPackage();
                
                // Sheet 1: Data
                var wsData = package.Workbook.Worksheets.Add("Data Report");
                
                // Header (Company Name and Logo)
                wsData.Cells["A1:D1"].Merge = true;
                wsData.Cells["A1"].Value = "GameStore Information System";
                wsData.Cells["A1"].Style.Font.Size = 20;
                wsData.Cells["A1"].Style.Font.Bold = true;
                
                // Add Logo
                string logoPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", "logo.png");
                if (System.IO.File.Exists(logoPath))
                {
                    var logo = wsData.Drawings.AddPicture("Logo", new FileInfo(logoPath));
                    logo.SetPosition(0, 0, 5, 0);
                    logo.SetSize(120, 120);
                }

                wsData.Cells["A3:D3"].Merge = true;
                wsData.Cells["A3"].Value = $"Report: {reportType.ToUpper()}";
                wsData.Cells["A3"].Style.Font.Size = 14;

                // Load Data
                if (!db.OpenConnection()) return BadRequest("Database connection failed.");
                string query = $"SELECT * FROM {reportType} LIMIT 100";
                using var cmd = new MySqlCommand(query, db.Connection);
                using var reader = cmd.ExecuteReader();

                int col = 1;
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    wsData.Cells[5, col].Value = reader.GetName(i);
                    wsData.Cells[5, col].Style.Font.Bold = true;
                    col++;
                }

                int row = 6;
                while (reader.Read())
                {
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        wsData.Cells[row, i + 1].Value = reader.GetValue(i);
                    }
                    row++;
                }
                db.CloseConnection();

                // Signature Placeholder
                row += 3;
                wsData.Cells[row, 1].Value = "Prepared by:";
                wsData.Cells[row + 1, 1].Value = "_________________________";
                wsData.Cells[row + 2, 1].Value = "Signature / Admin User";

                wsData.Cells.AutoFitColumns();

                // Sheet 2: Chart
                var wsChart = package.Workbook.Worksheets.Add("Visual Graph");
                var chart = wsChart.Drawings.AddChart("DataChart", eChartType.ColumnClustered);
                chart.Title.Text = $"{reportType} Overview";
                chart.SetPosition(1, 0, 1, 0);
                chart.SetSize(800, 600);

                if (row - 4 >= 6) // Check if data exists
                {
                    var serie = chart.Series.Add(wsData.Cells[6, 2, row - 4, 2], wsData.Cells[6, 1, row - 4, 1]);
                    serie.HeaderAddress = wsData.Cells[5, 2];
                }

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;
                
                string excelName = $"{reportType}-{DateTime.Now.ToString("yyyyMMddHHmmss")}.xlsx";
                return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", excelName);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error generating Excel report: {ex.Message}");
            }
        }
    }
}
