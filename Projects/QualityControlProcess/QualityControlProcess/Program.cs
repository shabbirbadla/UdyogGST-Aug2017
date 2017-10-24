﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace QualityControlProcess
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static int Main(string[] args)
        {

            if (args.Length < 2)
                //{
                //    MessageBox.Show("Incorrect number of parameters passed.");
                //    return 1;
                //args = new string[] { "1", "M021112", "udyog3\\vudyogsdk", "sa", "sa@1985", "^12005", "ADMIN", @"D:\Usquare\Bmp\Icon_usquare.ico", "VUdyog SDK", "Vudyogsdk.exe", "1", "udpid6096DTM20110307112715" };
                //    args = new string[] { "5", "Q011415", "PRO_PANKAJ\\USQUARE", "sa", "sa1985", "^21133", "ADMIN", @"D:\VudyogSDK\Bmp\Icon_VudyogSDK.ico", "VUdyog SDK", "VudyogSDK.exe", "1", "udpid6096DTM20110307112715" };
                //args = new string[] { "4", "C031718", "AIPLDTM020\\SQLEXPRESS", "sa", "sa1985", "^13044", "ADMIN", @"D:\Installer12.0\GST\VudyogGST\Bmp\icon_VudyogGST.ico", "VudyogGST", "VudyogGST.exe", "6500", "udPID6500DTM20170502152705" };  //Commented by Priyanka B on 18/05/2017
                args = new string[] { "4", "Q011718", @"AIPLDTM001\SQLEXPRESS", "sa", "sa1985", "^13044", "ADMIN", @"D:\Vudyoggst\Bmp\icon_VudyogGST.ico", "VudyogGST", "VudyogGST.exe", "5852", "udPID5852DTM20161110115010" }; //Added by Priyanka B on 18/05/2017
            //}
            //else


            //MessageBox.Show(Application.ExecutablePath);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1(args));
            return 0;
        }
    }
}
