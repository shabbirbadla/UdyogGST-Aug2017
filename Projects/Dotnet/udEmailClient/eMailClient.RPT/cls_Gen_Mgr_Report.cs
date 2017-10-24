﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlTypes;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using CrystalDecisions.CrystalReports;
using CrystalDecisions.ReportSource;
using CrystalDecisions.Shared;
using System.IO;

using eMailClient.DAL;


namespace eMailClient.RPT
{
    public class cls_Gen_Mgr_Report : cls_Gen_Ent_Report
    {
        string connectionString;
        SqlConnection sqlconn;


        public cls_Gen_Mgr_Report(Int32 mCompanyID, String ConnectionString)
        {
            // connectionString = ConfigurationManager.ConnectionStrings[Convert.ToString(CompanyID).Trim()].ConnectionString;
            connectionString = ConnectionString;
            CompanyID = mCompanyID;
            DsReportSource = new DataSet();
        }

        //Added by Shrikant S. on 24/09/2015 for Bug-26664      //Start
        private bool Check_Product_DigiSign()
        {
            DataSet dsData = new DataSet();
            string sqlstr;
            sqlstr = " Select Top 1 Passroute=convert(varchar(max),Passroute),Passroute1=convert(varchar(max),Passroute1) from vudyog..Co_mast where Compid=" + CompanyID.ToString();
            dsData = cls_Sqlhelper.ExecuteDataset(connectionString, CommandType.Text, sqlstr);

            string encProds = Udyog.Library.Common.VU_UDFS.GetDecProductCode(dsData.Tables[0].Rows[0]["Passroute"].ToString().Trim() + dsData.Tables[0].Rows[0]["Passroute1"].ToString().Trim()).ToLower();
            if (encProds.Contains("uddigisign"))
                return true;
            return false;
        }
        //Added by Shrikant S. on 24/09/2015 for Bug-26664      //End

        public bool ExportCsvFile()
        {
            bool isSuccess = false;

            if (Sqlstring == null || Sqlstring == string.Empty)
                throw new Exception("SQL command string found empty..");

            SqlDataReader m_obj_dr = null;
            try
            {

                if (sqlconn == null)
                {
                    sqlconn = new SqlConnection(connectionString);
                    sqlconn.Open();
                }
                else
                {
                    if (sqlconn.State == ConnectionState.Closed)
                        sqlconn.Open();
                }

                if (Sqltype.Trim().ToUpper() == "SP")
                {
                    Sqlstring = Sqlstring.Substring(0, Sqlstring.IndexOf('@')).Trim();
                    m_obj_dr = cls_Sqlhelper.ExecuteReader(sqlconn, CommandType.StoredProcedure, Sqlstring, SqlParam);
                }
                else
                    if (Sqltype.Trim().ToUpper() == "Q")
                        m_obj_dr = cls_Sqlhelper.ExecuteReader(sqlconn, CommandType.Text, Sqlstring, SqlParam);

            }
            catch (SqlException sqEx)
            {
                throw sqEx;
            }
            catch (Exception Ex)
            {
                throw new Exception("Error found, while executing SQL command string /n" +
                                    "\nMessage : " + Ex.Message.Trim() +
                                    "\nSource : " + Ex.Source.Trim() +
                                    "\nTargetSite : " + Ex.TargetSite.ToString().Trim());
            }

            DataTable m_obj_dtSchema = m_obj_dr.GetSchemaTable();

            try
            {
                if (Directory.Exists(DskFileName) == false)
                    throw new Exception("Specified Directory path not found..");

                // Generate File name according current Date
                DskFileName = DskFileName.Trim() + DskFilePrefixName.Trim() + GetLogFileNameDateString(DateTime.Now) + ".csv";


                StreamWriter m_obj_sw = new StreamWriter(DskFileName, false, EncodingCSV);
                string strRow; // represents a full row

                // Writes the column headers if the user previously asked that.
                if (FirstRowColumnNames == true)
                {
                    m_obj_sw.WriteLine(columnNames(m_obj_dtSchema, Separator));
                }

                // Reads the rows one by one from the SqlDataReader
                // transfers them to a string with the given separator character and
                // writes it to the file.
                while (m_obj_dr.Read())
                {
                    strRow = "";
                    for (int i = 0; i < m_obj_dr.FieldCount; i++)
                    {


                        switch (m_obj_dr.GetFieldType(i).ToString().Trim().ToUpper())
                        {
                            case "SYSTEM.INT32":
                                strRow += m_obj_dr.GetInt32(i);
                                break;
                            case "SYSTEM.INT16":
                                strRow += m_obj_dr.GetInt16(i);
                                break;
                            case "SYSTEM.INT64":
                                strRow += m_obj_dr.GetInt64(i);
                                break;
                            case "SYSTEM.DECIMAL":
                                strRow += m_obj_dr.GetDecimal(i);
                                break;
                            case "SYSTEM.DATETIME":
                                strRow += m_obj_dr.GetDateTime(i);
                                break;
                            case "SYSTEM.STRING":
                                strRow += m_obj_dr.GetString(i);
                                break;
                            case "SYSTEM.BOOLEAN":
                                strRow += m_obj_dr.GetBoolean(i);
                                break;
                        }

                        if (i < m_obj_dr.FieldCount - 1)
                        {
                            strRow += Separator;
                        }
                    }
                    m_obj_sw.WriteLine(strRow);
                }

                m_obj_sw.Close();
                m_obj_dr.Close();
                isSuccess = true;

            }
            catch (Exception Ex)
            {
                throw new Exception("Error found, while writing CSV file.." +
                                    "\nMessage : " + Ex.Message.Trim() +
                                    "\nSource : " + Ex.Source.Trim() +
                                    "\nTargetSite : " + Ex.TargetSite.ToString().Trim());
            }
            finally
            {
                sqlconn.Close();
            }

            return isSuccess;
        }

        public bool ExportCrystalReport()
        {
            //CrystalDecisions.Windows.Forms.CrystalReportViewer crviewer = new CrystalDecisions.Windows.Forms.CrystalReportViewer();

            bool isSuccess = false;
            DiskFileDestinationOptions DiskOpts = new DiskFileDestinationOptions();
            DiskOpts = ExportOptions.CreateDiskFileDestinationOptions();

            ExportOptions ExpOptions = new ExportOptions();

            if (Directory.Exists(DskFileName) == false)
                throw new Exception("Specified Output Directory path not found..");

            if (File.Exists(ReportPath) == false)
                throw new Exception("Specified Crystal Report file not found..");

            string outextension = string.Empty;

            // Define Export Format Type
            switch (ReportExportType.Trim().ToUpper())
            {
                case "PDF":
                    ExpOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
                    outextension = ".PDF";
                    break;
                case "EXCEL":
                    ExpOptions.ExportFormatType = ExportFormatType.Excel;
                    outextension = ".XLS";
                    break;
                case "WORD":
                    ExpOptions.ExportFormatType = ExportFormatType.WordForWindows;
                    outextension = ".DOC";
                    break;
            }

            // Generate File name according current Date
            DskFileName = DskFileName.Trim() + DskFilePrefixName.Trim() + GetLogFileNameDateString(DateTime.Now) + outextension.Trim();

            DiskOpts.DiskFileName = DskFileName;

            ExpOptions.ExportDestinationType = ExportDestinationType.DiskFile;
            ExpOptions.ExportDestinationOptions = DiskOpts;

            CrystalDecisions.CrystalReports.Engine.ReportDocument RepHandle = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
            RepHandle.Load(ReportPath);


            if (Sqlstring == string.Empty)
            {
                ConnectionInfo objConnectionInfo = new ConnectionInfo();
                TableLogOnInfo objLogonInfo = new TableLogOnInfo();

                if (SqlUsrName == null || SqlUsrName == string.Empty)
                    throw new Exception("User name found empty...");

                if (SqlPasswd == null || SqlPasswd == string.Empty)
                    throw new Exception("Password found empty...");

                if (SqlSrvName == null || SqlSrvName == string.Empty)
                    throw new Exception("SQL Servername found empty...");

                objConnectionInfo.UserID = SqlUsrName;
                objConnectionInfo.Password = SqlPasswd;
                objConnectionInfo.ServerName = SqlSrvName;

                objLogonInfo.ConnectionInfo = objConnectionInfo;
                foreach (CrystalDecisions.CrystalReports.Engine.Table objTable in RepHandle.Database.Tables)
                {
                    objTable.ApplyLogOnInfo(objLogonInfo);

                }

            }
            else
            {
                try
                {
                    if (Sqlstring == null || Sqlstring == string.Empty)
                        throw new Exception("SQL command found empty..");

                    if (sqlconn == null)
                    {
                        sqlconn = new SqlConnection(connectionString);
                        sqlconn.Open();
                    }
                    else
                    {
                        if (sqlconn.State == ConnectionState.Closed)
                            sqlconn.Open();
                    }


                    if (Sqltype.Trim().ToUpper() == "SP")
                    {
                        //Sqlstring = Sqlstring.Substring(0, Sqlstring.IndexOf('@')).Trim();    // Commented by Sachin N. S. on 20/01/2014 for Bug-20211
                        DsReportSource = cls_Sqlhelper.ExecuteDataset(sqlconn, CommandType.StoredProcedure, Sqlstring, SqlParam);
                    }
                    else
                        if (Sqltype.Trim().ToUpper() == "Q")
                            DsReportSource = cls_Sqlhelper.ExecuteDataset(sqlconn, CommandType.Text, Sqlstring, SqlParam);

                    for (int i = 0; i < RepHandle.Database.Tables.Count; i++)
                    {
                        RepHandle.Database.Tables[i].SetDataSource(DsReportSource.Tables[i]);
                    }
                }
                catch (SqlException sqEx) { throw sqEx; }
                catch (CrystalReportsException CrRepEx)
                {
                    throw new Exception("Error found, while setting Datasource of Crystal document" +
                                        "\nMessage : " + CrRepEx.Message.Trim() +
                                        "\nSource : " + CrRepEx.Source.Trim() +
                                        "\nTargetSite : " + CrRepEx.TargetSite.ToString().Trim());
                }
                catch (Exception Ex)
                {

                    throw new Exception("Error found, while executing report query .." +
                                        "\nMessage : " + Ex.Message.Trim() +
                                        "\nSource : " + Ex.Source.Trim() +
                                        "\nTargetSite : " + Ex.TargetSite.ToString().Trim());
                }
                finally { sqlconn.Close(); }



            }

            // Parameters Definitions.
            try
            {
                ParameterValues ParamValue;
                CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinitions parameterFieldDefinitions = RepHandle.DataDefinition.ParameterFields;
                ParameterDiscreteValue disCreteValue = new ParameterDiscreteValue();

                string param = "";
                string dataTableName = "";
                string colName = "";
                DataSet mParamDs = new DataSet();
                for (int i = 0; i < parameterFieldDefinitions.Count; i++)
                {
                    if (parameterFieldDefinitions[i].ParameterFieldUsage.ToString().ToUpper() == "NOTINUSE")
                        continue;

                    param = parameterFieldDefinitions[i].ParameterFieldName;
                    if (param.Trim().IndexOf('+') >= 0)
                    {
                        string[] paramArr = param.Split('+');
                        string discValue = "";
                        string paramS = "";
                        foreach (string paramA in paramArr)
                        {
                            if (paramA.Trim().IndexOf('.') < 0)
                                continue;

                            paramS = "";

                            if (paramA.Trim().ToUpper().IndexOf("ALLT(") >= 0)
                                paramS = paramA.Trim().Substring(5, (paramA.Trim().Length - 5) - 1);

                            if (paramA.Trim().ToUpper().IndexOf("ALLTRIM(") >= 0)
                                paramS = paramA.Trim().Substring(8, (paramA.Trim().Length - 8) - 1);

                            if (paramS.Trim() != "")
                                dataTableName = paramS.Trim().Substring(0, paramS.Trim().IndexOf('.'));
                            else
                            {
                                int paramAL = (paramA.Trim().IndexOf('.') == -1 || paramA.Trim().Length < paramA.Trim().IndexOf('.')
                                               ? paramA.Trim().Length :
                                                 paramA.Trim().IndexOf('.'));

                                dataTableName = paramA.Trim().Substring(0, paramAL);
                            }

                            if (dataTableName.Trim().ToUpper() == "COADDITIONAL")
                                dataTableName = "MANUFACT";


                            if (dataTableName.Trim().ToUpper() == "COMPANY" || dataTableName.Trim().ToUpper() == "MANUFACT")
                            {
                                if (mParamDs.Tables.Contains("COMPANY") == false || mParamDs.Tables.Contains("MANUFACT") == false)
                                {
                                    mParamDs = cls_Sqlhelper.ExecuteDataset(sqlconn, CommandType.Text, "select * from vudyog..co_mast where compid ="
                                                                       + Convert.ToString(CompanyID).Trim() +
                                                                       " " +
                                                                       " select * from manufact ", SqlParam);
                                    mParamDs.Tables[0].TableName = "COMPANY";
                                    mParamDs.Tables[1].TableName = "MANUFACT";
                                }

                            }

                            try
                            {
                                if (paramA.Trim().ToUpper().IndexOf("ALLTRIM(") >= 0 ||
                                    paramA.Trim().ToUpper().IndexOf("ALLT(") >= 0)
                                    colName = paramA.Trim().Substring(paramA.Trim().IndexOf('.') + 1, (paramA.Length - paramA.Trim().IndexOf('.')) - 2);
                                else
                                    colName = paramA.Trim().Substring(paramA.Trim().IndexOf('.') + 1, (paramA.Length - paramA.Trim().IndexOf('.')) - 1);

                                if (mParamDs.Tables[dataTableName].Columns.Contains(colName) == true)
                                    discValue += "'" + mParamDs.Tables[dataTableName].Rows[0][colName] + "'";
                            }
                            catch
                            {

                            }
                        }
                        ParamValue = parameterFieldDefinitions[i].CurrentValues;
                        disCreteValue.Value = discValue.Trim();
                        ParamValue.Add(disCreteValue);
                        parameterFieldDefinitions[i].ApplyCurrentValues(ParamValue);


                    }
                    else
                    {
                        if (param.Trim().IndexOf('.') >= 0)
                        {
                            dataTableName = param.Trim().Substring(0, param.Trim().IndexOf('.'));

                            if (dataTableName.Trim().ToUpper() == "COADDITIONAL")
                                dataTableName = "MANUFACT";

                            if (dataTableName.Trim().ToUpper() == "COMPANY" || dataTableName.Trim().ToUpper() == "MANUFACT")
                            {
                                if (mParamDs.Tables.Contains("COMPANY") == false || mParamDs.Tables.Contains("MANUFACT") == false)
                                {
                                    mParamDs = cls_Sqlhelper.ExecuteDataset(sqlconn, CommandType.Text, "select * from vudyog..co_mast where compid ="
                                                                       + Convert.ToString(CompanyID).Trim() +
                                                                       " " +
                                                                       " select * from manufact ", SqlParam);
                                    mParamDs.Tables[0].TableName = "COMPANY";
                                    mParamDs.Tables[1].TableName = "MANUFACT";
                                }

                            }

                            try
                            {
                                colName = param.Trim().Substring(param.Trim().IndexOf('.') + 1, (param.Length - param.Trim().IndexOf('.')) - 1);
                                ParamValue = parameterFieldDefinitions[i].CurrentValues;
                                if (mParamDs.Tables[dataTableName].Columns.Contains(colName) == true)
                                {
                                    switch (mParamDs.Tables[dataTableName].Rows[0][colName].GetType().ToString().Trim().ToUpper())
                                    {
                                        case "SYSTEM.STRING":
                                            //disCreteValue.Value = "'" + MainDataSet.Tables[dataTableName].Rows[0][colName] + "'";
                                            disCreteValue.Value = Convert.ToString(mParamDs.Tables[dataTableName].Rows[0][colName]).Trim();
                                            break;
                                        case "SYSTEM.DATETIME":
                                            disCreteValue.Value = ToDateTime(mParamDs.Tables[dataTableName].Rows[0][colName]);
                                            break;
                                        case "SYSTEM.BOOLEAN":
                                            disCreteValue.Value = ToBoolean(mParamDs.Tables[dataTableName].Rows[0][colName]);
                                            break;
                                        case "SYSTEM.DECIMAL":
                                        case "SYSTEM.NUMERIC":
                                        case "SYSTEM.INT32":
                                        case "SYSTEM.INT16":
                                        case "SYSTEM.INT64":
                                            disCreteValue.Value = ToDecimal(mParamDs.Tables[dataTableName].Rows[0][colName]);
                                            break;
                                        case "SYSTEM.DBNULL":
                                            disCreteValue.Value = "";
                                            break;
                                    }
                                }
                                else
                                    disCreteValue.Value = "";

                                ParamValue.Add(disCreteValue);
                                parameterFieldDefinitions[i].ApplyCurrentValues(ParamValue);

                            }
                            catch
                            {

                            }
                        }
                        else
                        {
                            if (param.Trim().ToUpper() == "MUSERNAME")
                            {
                                ParamValue = parameterFieldDefinitions[i].CurrentValues;
                                disCreteValue.Value = UserID.Trim();
                                ParamValue.Add(disCreteValue);
                                parameterFieldDefinitions[i].ApplyCurrentValues(ParamValue);
                            }

                        }
                    }
                }
                mParamDs.Dispose();
            }
            catch (CrystalReportsException CrRepEx)
            {
                throw new Exception("Error found, while applying parameters value in the report" +
                                    "\nMessage : " + CrRepEx.Message.Trim() +
                                    "\nSource : " + CrRepEx.Source.Trim() +
                                    "\nTargetSite : " + CrRepEx.TargetSite.ToString().Trim());
            }
            catch (Exception Ex)
            {
                throw new Exception("Error found, while applying parameter value in the report " +
                                    "\nMessage : " + Ex.Message.Trim() +
                                    "\nSource : " + Ex.Source.Trim() +
                                    "\nTargetSite : " + Ex.TargetSite.ToString().Trim());
            }


            try
            {
                RepHandle.Export(ExpOptions);

                if (!Check_Product_DigiSign())                      // Added by Shrikant S. on 24/09/2015 for Bug-26664 
                    Isdigsign = false;                              // Added by Shrikant S. on 24/09/2015 for Bug-26664 

                //Pankaj Start
                if (Isdigsign == true)
                {
                    //throw new Exception("This is testing1");
                    string OutPdfPath = string.Empty, InPdfPath = string.Empty, Pass = string.Empty;
                    DateTime date = DateTime.Now;
                    Stream Path = null;
                    SqlDataReader m_obj_dr = null;
                    if (sqlconn == null)
                    {
                        sqlconn = new SqlConnection(connectionString);
                        sqlconn.Open();
                    }
                    else
                    {
                        if (sqlconn.State == ConnectionState.Closed)
                            sqlconn.Open();
                    }
                    //throw new Exception("This is testing2");
                    //Sqlstring = "select FileData,Passw from DigitalSign where dept='" + Dept + "' and cate='" + Cate + "' and invsr='" + Inv_sr + "' and validity like '%" + Entry_ty + "%' and ('" + Inv_dt.ToString("yyyy/MM/dd") + "'>=convert(smalldatetime,sdate) and '" + Inv_dt.ToString("yyyy-MM-dd") + "'<=convert(varchar(10),edate,103))";         //Commented by Shrikant S. on 10/09/2015 for Bug-26664
                    Sqlstring = "set dateformat mdy select * from DigitalSign where dept='" + Dept + "' and cate='" + Cate + "' and invsr='" + Inv_sr + "' and validity like '%" + Entry_ty + "%' and ('" + Inv_dt.ToString("yyyy/MM/dd") + "'>=convert(smalldatetime,sdate) and '" + Inv_dt.ToString("yyyy-MM-dd") + "'<=convert(smalldatetime,edate))";         //Added by Shrikant S. on 10/09/2015 for Bug-26664

                    //m_obj_dr = cls_Sqlhelper.ExecuteReader(sqlconn, CommandType.Text, Sqlstring);     //Commented by Shrikant S. on 11/09/2015 for Bug-26664

                    DataTable ldtSign = cls_Sqlhelper.ExecuteDataset(sqlconn, CommandType.Text, Sqlstring).Tables[0];               //Added by Shrikant S. on 11/09/2015 for Bug-26664

                    //if (m_obj_dr.HasRows == true && m_obj_dr != null)         //Commented by Shrikant S. on 11/09/2015 for Bug-26664
                    //throw new Exception("This is testing3");
                    //throw new Exception(Sqlstring);
                    if (ldtSign.Rows.Count > 1)
                    {
                        PDFSigner pdfsign = new PDFSigner();
                        string certName = pdfsign.GetCertificateName();
                        if (certName == string.Empty)
                            return false;

                        ldtSign.Rows.Clear();

                        Sqlstring = "set dateformat mdy select * from DigitalSign where dept='" + Dept + "' and cate='" + Cate + "' and invsr='" + Inv_sr + "' and validity like '%" + Entry_ty + "%' and ('" + Inv_dt.ToString("yyyy/MM/dd") + "'>=convert(smalldatetime,sdate) and '" + Inv_dt.ToString("yyyy-MM-dd") + "'<=convert(smalldatetime,edate)) and SignBy='" + certName + "'";          //Added by Shrikant S. on 10/09/2015 for Bug-26664
                        ldtSign = cls_Sqlhelper.ExecuteDataset(sqlconn, CommandType.Text, Sqlstring).Tables[0];
                        pdfsign = null;
                    }

                    if (ldtSign.Rows.Count == 1)           ////Added by Shrikant S. on 11/09/2015 for Bug-26664
                    {
                        InPdfPath = DskFileName;
                        //OutPdfPath = InPdfPath.ToString().Replace(".PDF", "_digital.pdf");        //Commented by Shrikant S. on 10/09/2015 for Bug-26664
                        //Added by Shrikant S. on 10/09/2015 for Bug-26664  //Start

                        Int32 left = Convert.ToInt32(ldtSign.Rows[0]["signLeft"]);
                        Int32 bottom = Convert.ToInt32(ldtSign.Rows[0]["signBottom"]);
                        Int32 width = left + Convert.ToInt32(ldtSign.Rows[0]["signWidth"]);
                        Int32 height = bottom + Convert.ToInt32(ldtSign.Rows[0]["signHeight"]);


                        string reason = (Convert.ToString(ldtSign.Rows[0]["Reason"]).Length > 0 && Convert.ToBoolean(ldtSign.Rows[0]["ShowReason"]) ? Convert.ToString(ldtSign.Rows[0]["Reason"]) : string.Empty);
                        string location = (Convert.ToString(ldtSign.Rows[0]["Location"]).Length > 0 && Convert.ToBoolean(ldtSign.Rows[0]["ShowLocation"]) ? Convert.ToString(ldtSign.Rows[0]["Location"]) : string.Empty);
                        string SignBy = Convert.ToString(ldtSign.Rows[0]["SignBy"]);

                        iTextSharp.text.Rectangle rect = new iTextSharp.text.Rectangle(left, bottom, width, height);
                        InPdfPath = InPdfPath.ToLower();
                        OutPdfPath = InPdfPath.ToString().Replace(".pdf", "_digital.pdf");


                        if (Convert.ToString(ldtSign.Rows[0]["FileType"]).Trim() == "USBTO")
                        {
                            PDFSigner pdfs = new PDFSigner();

                            string msg = pdfs.processCertificate(InPdfPath, OutPdfPath, SignBy, rect, reason, location);

                            if (msg != string.Empty)
                            {
                                isSuccess = false;
                                throw new Exception(msg);
                            }
                        }
                        else
                        {
                            //Added by Shrikant S. on 10/09/2015 for Bug-26664  //End

                            //sqlQuery = "select FileData,Passw from FileInformation where dept='" + dept + "' and cate='" + cate + "' and inv_sr='" + inv_sr + "' and ('" + date + "' between convert(date,sdate) and convert(date,edate))";
                            //tDs = oDataAccess.GetDataSet(sqlQuery, null, 25);

                            //while (m_obj_dr.Read())               //Commented by Shrikant S. on 10/09/2015 for Bug-26664
                            //{
                            Path = new MemoryStream((byte[])ldtSign.Rows[0]["FileData"]);
                            Pass = CryptorEngine.Decrypt(ldtSign.Rows[0]["Passw"].ToString(), true);
                            //}             //Commented by Shrikant S. on 10/09/2015 for Bug-26664
                            //m_obj_dr.Close();       //Commented by Shrikant S. on 10/09/2015 for Bug-26664

                            //Path = new MemoryStream((byte[])tDs.Tables[0].Rows[0]["FileData"]);
                            //Pass = CryptorEngine.Decrypt(tDs.Tables[0].Rows[0]["Passw"].ToString(), true);


                            //debug("Signing document ... ");
                            //PDFSigner pdfs = new PDFSigner(inputBox.Text, outputBox.Text, myCert, MyMD);
                            PDFSigner pdfs = new PDFSigner();
                            pdfs.processCert(Path, Pass);
                            pdfs.Sign(InPdfPath, OutPdfPath, "", true, rect, reason, location);

                        }
                        File.Delete(InPdfPath);
                        FileInfo info = new FileInfo(OutPdfPath);
                        info.MoveTo(InPdfPath);
                        //Pankaj End
                    }
                    else
                    {
                        if (m_obj_dr != null)
                            m_obj_dr.Close();
                        ldtSign = null;          //Added by Shrikant S. on 10/09/2015 for Bug-26664  
                    }
                }
                isSuccess = true;
            }
            catch (CrystalReportsException CrRepEx)
            {
                throw new Exception("Error found, while exporting report " +
                                    "\nMessage : " + CrRepEx.Message.Trim() +
                                    "\nSource : " + CrRepEx.Source.Trim() +
                                    "\nTargetSite : " + CrRepEx.TargetSite.ToString().Trim());
            }
            catch (Exception Ex)
            {
                throw new Exception("Error found, while exporting report " +
                                    "\nMessage : " + Ex.Message.Trim() +
                                    "\nSource : " + Ex.Source.Trim() +
                                    "\nTargetSite : " + Ex.TargetSite.ToString().Trim());
            }
            finally
            {
                RepHandle.Close();
                RepHandle.Dispose();
            }


            return isSuccess;
        }

        #region Other Private Methods

        private string columnNames(DataTable dtSchemaTable, string delimiter)
        {
            string strOut = "";
            if (delimiter.ToLower() == "tab")
            {
                delimiter = "\t";
            }

            for (int i = 0; i < dtSchemaTable.Rows.Count; i++)
            {
                strOut += dtSchemaTable.Rows[i][0].ToString();
                if (i < dtSchemaTable.Rows.Count - 1)
                {
                    strOut += delimiter;
                }

            }
            return strOut;
        }

        private DateTime ToDateTime(object objDate)
        {
            DateTime Date = Convert.ToDateTime("01/01/1900");
            switch (objDate.GetType().ToString().Trim().ToUpper())
            {
                case "SYSTEM.DATETIME":
                    Date = ((DateTime)objDate);
                    break;
                case "SYSTEM.STRING":
                    string dateTime = (String)objDate;
                    if (dateTime == "")
                        dateTime = "01/01/1900";
                    Date = Convert.ToDateTime(dateTime);
                    break;
            }

            if (Date.Year < 1900)
            {
                Date = Convert.ToDateTime("01/01/1900");
            }

            if (Date != null && (Date.Year > 1900))
            {
                string _retdate = "";
                string[] datearray = new string[3];
                string _date = Convert.ToString(Date).Trim();
                datearray = _date.Split('/');
                _retdate = datearray[0];
                _retdate += "/" + datearray[1];
                if (datearray[2].Length > 4)
                {
                    _retdate += "/" + datearray[2].Substring(0, 4);
                }
                else
                {
                    _retdate += "/" + datearray[2];
                }

                Date = Convert.ToDateTime(_retdate);
            }
            return Date;
        }

        private decimal ToDecimal(object val, int decimalSize)
        {
            if (!DBNull.Value.Equals(val))
            {
                val = Convert.ToDecimal(val);
            }
            else
            {
                val = Convert.ToDecimal(0);
            }

            string DecimalStr = "";
            string Format = "{00:0." + DecimalStr.PadLeft(decimalSize, '0') + "}";

            return ToDecimal(string.Format(Format, val));
        }

        private decimal ToDecimal(object val)
        {
            if (!DBNull.Value.Equals(val))
            {
                val = Convert.ToDecimal(val);
            }
            else
            {
                val = Convert.ToDecimal(0);
            }
            return (Decimal)val;
        }

        public bool ToBoolean(object boolVal)
        {
            if (!DBNull.Value.Equals(boolVal))
            {
                boolVal = Convert.ToBoolean(boolVal);
            }
            else
            {
                boolVal = false;
            }
            return (Boolean)boolVal;
        }

        private static string GetLogFileNameDateString(DateTime currentDateTime)
        {
            return currentDateTime.ToString("yyyy_MM_dd");
        }

        #endregion
    }
}
