﻿using System;
using System.Collections.Generic;
using System.Linq;

using System.Windows.Forms;

namespace ExportDataToFile
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static int Main (string[] args)
        { //if (args.Length < 8)
          
            if (args.Length <= 0)
            {
               //args = new string[] { "1", "T011718", @"AIPLDTM024\SQLExpress", "sa", "sa1985", "^21380", "ADMIN", @"D:\VudyogGSTSDK\Bmp\Icon_VudyogGST.ico", "VudyogGST", "VudyogGST.EXE", "5852", "udPID5852DTM20161110115010" };
                //args = new string[] { "1", "G021617", @"AIPLLTM001", "sa", "sa1985", "^21380", "ADMIN", @"D:\VudyogGST\Bmp\Icon_VudyogGST.ico", "VudyogGST", "VudyogGST.EXE", "5852", "udPID5852DTM20161110115010" };
                // args = new string[] { "75", "B041617", @"AIPLLTM001\AIPLLTM001", "sa", "sa1985", "^21380", "ADMIN", @"D:\VudyogSDK\Bmp\Icon_VudyogSDK.ico", "VudyogSDK", "VudyogSDK.EXE", "5852", "udPID5852DTM20161110115010" };
                MessageBox.Show("The arguments sent are not valid", "System Administrator", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                return 0;
            }
           
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1(args));
            return 1;
        }
    }
}
