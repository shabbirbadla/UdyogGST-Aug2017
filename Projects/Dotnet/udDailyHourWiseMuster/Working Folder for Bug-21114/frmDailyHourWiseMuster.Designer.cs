﻿namespace udDailyHourWiseMuster
{
    partial class frmDailyHourWiseMuster
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmDailyHourWiseMuster));
            this.lcProcessingMonth = new System.Windows.Forms.Label();
            this.txtProcMonth = new System.Windows.Forms.TextBox();
            this.btnMonth = new System.Windows.Forms.Button();
            this.lcProcessingYear = new System.Windows.Forms.Label();
            this.txtProcYear = new System.Windows.Forms.TextBox();
            this.btnProcYear = new System.Windows.Forms.Button();
            this.sbAttendanceFormat = new System.Windows.Forms.Button();
            this.teAttendanceFormat = new System.Windows.Forms.TextBox();
            this.lcAttendanceFormat = new System.Windows.Forms.Label();
            this.BtnMuster = new System.Windows.Forms.Button();
            this.txtMuster = new System.Windows.Forms.TextBox();
            this.lcMusterType = new System.Windows.Forms.Label();
            this.dgrApprov = new System.Windows.Forms.DataGridView();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.btnFirst = new System.Windows.Forms.ToolStripButton();
            this.btnBack = new System.Windows.Forms.ToolStripButton();
            this.btnForward = new System.Windows.Forms.ToolStripButton();
            this.btnLast = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.btnEmail = new System.Windows.Forms.ToolStripButton();
            this.btnLocate = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.btnNew = new System.Windows.Forms.ToolStripButton();
            this.btnSave = new System.Windows.Forms.ToolStripButton();
            this.btnEdit = new System.Windows.Forms.ToolStripButton();
            this.btnCancel = new System.Windows.Forms.ToolStripButton();
            this.btnDelete = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.btnPreview = new System.Windows.Forms.ToolStripButton();
            this.btnPrint = new System.Windows.Forms.ToolStripButton();
            this.btnExportPdf = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator4 = new System.Windows.Forms.ToolStripSeparator();
            this.btnLogout = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator6 = new System.Windows.Forms.ToolStripSeparator();
            this.btnHelp = new System.Windows.Forms.ToolStripButton();
            this.btnCalculator = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator7 = new System.Windows.Forms.ToolStripSeparator();
            this.btnExit = new System.Windows.Forms.ToolStripButton();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.newToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.editToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.cancelToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.deleteToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.closeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.previewToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.printToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.emailToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            ((System.ComponentModel.ISupportInitialize)(this.dgrApprov)).BeginInit();
            this.toolStrip1.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // lcProcessingMonth
            // 
            this.lcProcessingMonth.Location = new System.Drawing.Point(12, 44);
            this.lcProcessingMonth.Name = "lcProcessingMonth";
            this.lcProcessingMonth.Size = new System.Drawing.Size(95, 13);
            this.lcProcessingMonth.TabIndex = 0;
            this.lcProcessingMonth.Text = "Processing Month";
            // 
            // txtProcMonth
            // 
            this.txtProcMonth.Location = new System.Drawing.Point(113, 41);
            this.txtProcMonth.Name = "txtProcMonth";
            this.txtProcMonth.ReadOnly = true;
            this.txtProcMonth.Size = new System.Drawing.Size(100, 20);
            this.txtProcMonth.TabIndex = 1;
            this.txtProcMonth.TabIndexChanged += new System.EventHandler(this.teProcessingMonth_TabIndexChanged);
            // 
            // btnMonth
            // 
            this.btnMonth.Location = new System.Drawing.Point(215, 41);
            this.btnMonth.Name = "btnMonth";
            this.btnMonth.Size = new System.Drawing.Size(25, 20);
            this.btnMonth.TabIndex = 6;
            this.btnMonth.Click += new System.EventHandler(this.btnMonth_Click);
            // 
            // lcProcessingYear
            // 
            this.lcProcessingYear.Location = new System.Drawing.Point(259, 44);
            this.lcProcessingYear.Name = "lcProcessingYear";
            this.lcProcessingYear.Size = new System.Drawing.Size(93, 17);
            this.lcProcessingYear.TabIndex = 3;
            this.lcProcessingYear.Text = "Processing Year";
            // 
            // txtProcYear
            // 
            this.txtProcYear.Location = new System.Drawing.Point(365, 44);
            this.txtProcYear.Name = "txtProcYear";
            this.txtProcYear.ReadOnly = true;
            this.txtProcYear.Size = new System.Drawing.Size(100, 20);
            this.txtProcYear.TabIndex = 2;
            // 
            // btnProcYear
            // 
            this.btnProcYear.Location = new System.Drawing.Point(468, 44);
            this.btnProcYear.Name = "btnProcYear";
            this.btnProcYear.Size = new System.Drawing.Size(25, 20);
            this.btnProcYear.TabIndex = 7;
            this.btnProcYear.Click += new System.EventHandler(this.sbProcessingYear_Click);
            // 
            // sbAttendanceFormat
            // 
            this.sbAttendanceFormat.Location = new System.Drawing.Point(468, 68);
            this.sbAttendanceFormat.Name = "sbAttendanceFormat";
            this.sbAttendanceFormat.Size = new System.Drawing.Size(25, 20);
            this.sbAttendanceFormat.TabIndex = 9;
            this.sbAttendanceFormat.Visible = false;
            // 
            // teAttendanceFormat
            // 
            this.teAttendanceFormat.Location = new System.Drawing.Point(365, 68);
            this.teAttendanceFormat.Name = "teAttendanceFormat";
            this.teAttendanceFormat.Size = new System.Drawing.Size(100, 20);
            this.teAttendanceFormat.TabIndex = 4;
            this.teAttendanceFormat.Visible = false;
            // 
            // lcAttendanceFormat
            // 
            this.lcAttendanceFormat.Location = new System.Drawing.Point(259, 72);
            this.lcAttendanceFormat.Name = "lcAttendanceFormat";
            this.lcAttendanceFormat.Size = new System.Drawing.Size(93, 13);
            this.lcAttendanceFormat.TabIndex = 9;
            this.lcAttendanceFormat.Text = "Attendance Format";
            this.lcAttendanceFormat.Visible = false;
            // 
            // BtnMuster
            // 
            this.BtnMuster.Location = new System.Drawing.Point(215, 68);
            this.BtnMuster.Name = "BtnMuster";
            this.BtnMuster.Size = new System.Drawing.Size(25, 20);
            this.BtnMuster.TabIndex = 8;
            this.BtnMuster.Visible = false;
            // 
            // txtMuster
            // 
            this.txtMuster.Location = new System.Drawing.Point(113, 68);
            this.txtMuster.Name = "txtMuster";
            this.txtMuster.ReadOnly = true;
            this.txtMuster.Size = new System.Drawing.Size(100, 20);
            this.txtMuster.TabIndex = 3;
            // 
            // lcMusterType
            // 
            this.lcMusterType.Location = new System.Drawing.Point(12, 72);
            this.lcMusterType.Name = "lcMusterType";
            this.lcMusterType.Size = new System.Drawing.Size(60, 13);
            this.lcMusterType.TabIndex = 6;
            this.lcMusterType.Text = "Muster Type";
            // 
            // dgrApprov
            // 
            this.dgrApprov.AllowUserToAddRows = false;
            this.dgrApprov.AllowUserToDeleteRows = false;
            this.dgrApprov.AllowUserToResizeRows = false;
            this.dgrApprov.BackgroundColor = System.Drawing.Color.White;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.ActiveBorder;
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgrApprov.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1;
            this.dgrApprov.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.Color.LightBlue;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgrApprov.DefaultCellStyle = dataGridViewCellStyle2;
            this.dgrApprov.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dgrApprov.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter;
            this.dgrApprov.Location = new System.Drawing.Point(0, 104);
            this.dgrApprov.Name = "dgrApprov";
            this.dgrApprov.RowHeadersVisible = false;
            this.dgrApprov.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgrApprov.Size = new System.Drawing.Size(505, 374);
            this.dgrApprov.TabIndex = 13;
            this.dgrApprov.CellValidated += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgrApprov_CellValidated);
            this.dgrApprov.CellContentDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgrApprov_CellContentDoubleClick);
            this.dgrApprov.KeyDown += new System.Windows.Forms.KeyEventHandler(this.dgrApprov_KeyDown);
            this.dgrApprov.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellContentClick);
            // 
            // toolStrip1
            // 
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.btnFirst,
            this.btnBack,
            this.btnForward,
            this.btnLast,
            this.toolStripSeparator1,
            this.btnEmail,
            this.btnLocate,
            this.toolStripSeparator2,
            this.btnNew,
            this.btnSave,
            this.btnEdit,
            this.btnCancel,
            this.btnDelete,
            this.toolStripSeparator3,
            this.btnPreview,
            this.btnPrint,
            this.btnExportPdf,
            this.toolStripSeparator4,
            this.btnLogout,
            this.toolStripSeparator6,
            this.btnHelp,
            this.btnCalculator,
            this.toolStripSeparator7,
            this.btnExit});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(505, 25);
            this.toolStrip1.TabIndex = 84;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // btnFirst
            // 
            this.btnFirst.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnFirst.Image = ((System.Drawing.Image)(resources.GetObject("btnFirst.Image")));
            this.btnFirst.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnFirst.Name = "btnFirst";
            this.btnFirst.Size = new System.Drawing.Size(23, 22);
            this.btnFirst.Text = "toolStripButton1";
            this.btnFirst.ToolTipText = "First";
            // 
            // btnBack
            // 
            this.btnBack.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnBack.Image = ((System.Drawing.Image)(resources.GetObject("btnBack.Image")));
            this.btnBack.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnBack.Name = "btnBack";
            this.btnBack.Size = new System.Drawing.Size(23, 22);
            this.btnBack.Text = "toolStripButton2";
            this.btnBack.ToolTipText = "Back";
            // 
            // btnForward
            // 
            this.btnForward.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnForward.Image = ((System.Drawing.Image)(resources.GetObject("btnForward.Image")));
            this.btnForward.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnForward.Name = "btnForward";
            this.btnForward.Size = new System.Drawing.Size(23, 22);
            this.btnForward.Text = "toolStripButton3";
            this.btnForward.ToolTipText = "Forward";
            // 
            // btnLast
            // 
            this.btnLast.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnLast.Image = ((System.Drawing.Image)(resources.GetObject("btnLast.Image")));
            this.btnLast.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnLast.Name = "btnLast";
            this.btnLast.Size = new System.Drawing.Size(23, 22);
            this.btnLast.Text = "toolStripButton4";
            this.btnLast.ToolTipText = "Last";
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // btnEmail
            // 
            this.btnEmail.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnEmail.Image = ((System.Drawing.Image)(resources.GetObject("btnEmail.Image")));
            this.btnEmail.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnEmail.Name = "btnEmail";
            this.btnEmail.Size = new System.Drawing.Size(23, 22);
            this.btnEmail.Text = "toolStripButton5";
            this.btnEmail.ToolTipText = "Email(Ctrl+F)";
            this.btnEmail.Click += new System.EventHandler(this.btnEmail_Click);
            // 
            // btnLocate
            // 
            this.btnLocate.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnLocate.Image = ((System.Drawing.Image)(resources.GetObject("btnLocate.Image")));
            this.btnLocate.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnLocate.Name = "btnLocate";
            this.btnLocate.Size = new System.Drawing.Size(23, 22);
            this.btnLocate.Text = "toolStripButton6";
            this.btnLocate.ToolTipText = "Locate";
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(6, 25);
            // 
            // btnNew
            // 
            this.btnNew.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnNew.Image = ((System.Drawing.Image)(resources.GetObject("btnNew.Image")));
            this.btnNew.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnNew.Name = "btnNew";
            this.btnNew.Size = new System.Drawing.Size(23, 22);
            this.btnNew.Text = "toolStripButton7";
            this.btnNew.ToolTipText = "New(Ctrl+N)";
            // 
            // btnSave
            // 
            this.btnSave.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnSave.Enabled = false;
            this.btnSave.Image = ((System.Drawing.Image)(resources.GetObject("btnSave.Image")));
            this.btnSave.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(23, 22);
            this.btnSave.Text = "toolStripButton1";
            this.btnSave.ToolTipText = "Save(Ctrl+S)";
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // btnEdit
            // 
            this.btnEdit.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnEdit.Image = ((System.Drawing.Image)(resources.GetObject("btnEdit.Image")));
            this.btnEdit.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnEdit.Name = "btnEdit";
            this.btnEdit.Size = new System.Drawing.Size(23, 22);
            this.btnEdit.Text = "toolStripButton8";
            this.btnEdit.ToolTipText = "Edit(Ctrl+E)";
            this.btnEdit.Click += new System.EventHandler(this.btnEdit_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnCancel.Image = ((System.Drawing.Image)(resources.GetObject("btnCancel.Image")));
            this.btnCancel.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(23, 22);
            this.btnCancel.Text = "toolStripButton9";
            this.btnCancel.ToolTipText = "Cancel(Ctrl+Z)";
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnDelete
            // 
            this.btnDelete.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnDelete.Image = ((System.Drawing.Image)(resources.GetObject("btnDelete.Image")));
            this.btnDelete.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(23, 22);
            this.btnDelete.Text = "toolStripButton10";
            this.btnDelete.ToolTipText = "Delete(Ctrl+Z)";
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(6, 25);
            // 
            // btnPreview
            // 
            this.btnPreview.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnPreview.Image = ((System.Drawing.Image)(resources.GetObject("btnPreview.Image")));
            this.btnPreview.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnPreview.Name = "btnPreview";
            this.btnPreview.Size = new System.Drawing.Size(23, 22);
            this.btnPreview.Text = "toolStripButton11";
            this.btnPreview.ToolTipText = "Preview(Ctrl+O)";
            this.btnPreview.Click += new System.EventHandler(this.btnPreview_Click);
            // 
            // btnPrint
            // 
            this.btnPrint.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnPrint.Image = ((System.Drawing.Image)(resources.GetObject("btnPrint.Image")));
            this.btnPrint.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnPrint.Name = "btnPrint";
            this.btnPrint.Size = new System.Drawing.Size(23, 22);
            this.btnPrint.Text = "Print(Ctrl+P)";
            this.btnPrint.Click += new System.EventHandler(this.btnPrint_Click);
            // 
            // btnExportPdf
            // 
            this.btnExportPdf.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnExportPdf.Enabled = false;
            this.btnExportPdf.Image = ((System.Drawing.Image)(resources.GetObject("btnExportPdf.Image")));
            this.btnExportPdf.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnExportPdf.Name = "btnExportPdf";
            this.btnExportPdf.Size = new System.Drawing.Size(23, 22);
            this.btnExportPdf.Text = "PDF";
            this.btnExportPdf.ToolTipText = "Export To PDF";
            // 
            // toolStripSeparator4
            // 
            this.toolStripSeparator4.Name = "toolStripSeparator4";
            this.toolStripSeparator4.Size = new System.Drawing.Size(6, 25);
            // 
            // btnLogout
            // 
            this.btnLogout.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnLogout.Image = ((System.Drawing.Image)(resources.GetObject("btnLogout.Image")));
            this.btnLogout.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnLogout.Name = "btnLogout";
            this.btnLogout.Size = new System.Drawing.Size(23, 22);
            this.btnLogout.Text = "toolStripButton14";
            this.btnLogout.ToolTipText = "Exit(Ctrl+F4)";
            this.btnLogout.Click += new System.EventHandler(this.btnLogout_Click);
            // 
            // toolStripSeparator6
            // 
            this.toolStripSeparator6.Name = "toolStripSeparator6";
            this.toolStripSeparator6.Size = new System.Drawing.Size(6, 25);
            // 
            // btnHelp
            // 
            this.btnHelp.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnHelp.Image = ((System.Drawing.Image)(resources.GetObject("btnHelp.Image")));
            this.btnHelp.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnHelp.Name = "btnHelp";
            this.btnHelp.Size = new System.Drawing.Size(23, 22);
            this.btnHelp.Text = "toolStripButton16";
            this.btnHelp.ToolTipText = "Help";
            // 
            // btnCalculator
            // 
            this.btnCalculator.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnCalculator.Image = ((System.Drawing.Image)(resources.GetObject("btnCalculator.Image")));
            this.btnCalculator.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnCalculator.Name = "btnCalculator";
            this.btnCalculator.Size = new System.Drawing.Size(23, 22);
            this.btnCalculator.Text = "toolStripButton17";
            this.btnCalculator.ToolTipText = "Calculator";
            this.btnCalculator.Click += new System.EventHandler(this.btnCalculator_Click);
            // 
            // toolStripSeparator7
            // 
            this.toolStripSeparator7.Name = "toolStripSeparator7";
            this.toolStripSeparator7.Size = new System.Drawing.Size(6, 25);
            // 
            // btnExit
            // 
            this.btnExit.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnExit.Image = ((System.Drawing.Image)(resources.GetObject("btnExit.Image")));
            this.btnExit.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnExit.Name = "btnExit";
            this.btnExit.Size = new System.Drawing.Size(23, 22);
            this.btnExit.Text = "toolStripButton15";
            this.btnExit.ToolTipText = "Exit";
            // 
            // groupBox1
            // 
            this.groupBox1.Location = new System.Drawing.Point(7, 28);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(490, 69);
            this.groupBox1.TabIndex = 85;
            this.groupBox1.TabStop = false;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.newToolStripMenuItem,
            this.editToolStripMenuItem,
            this.saveToolStripMenuItem1,
            this.cancelToolStripMenuItem,
            this.deleteToolStripMenuItem,
            this.closeToolStripMenuItem,
            this.previewToolStripMenuItem,
            this.printToolStripMenuItem,
            this.emailToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 25);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(505, 24);
            this.menuStrip1.TabIndex = 86;
            this.menuStrip1.Text = "menuStrip1";
            this.menuStrip1.Visible = false;
            // 
            // newToolStripMenuItem
            // 
            this.newToolStripMenuItem.Name = "newToolStripMenuItem";
            this.newToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.N)));
            this.newToolStripMenuItem.Size = new System.Drawing.Size(43, 20);
            this.newToolStripMenuItem.Text = "New";
            this.newToolStripMenuItem.Click += new System.EventHandler(this.newToolStripMenuItem_Click);
            // 
            // editToolStripMenuItem
            // 
            this.editToolStripMenuItem.Name = "editToolStripMenuItem";
            this.editToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.E)));
            this.editToolStripMenuItem.Size = new System.Drawing.Size(39, 20);
            this.editToolStripMenuItem.Text = "Edit";
            this.editToolStripMenuItem.Click += new System.EventHandler(this.editToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem1
            // 
            this.saveToolStripMenuItem1.Name = "saveToolStripMenuItem1";
            this.saveToolStripMenuItem1.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
            this.saveToolStripMenuItem1.Size = new System.Drawing.Size(43, 20);
            this.saveToolStripMenuItem1.Text = "Save";
            this.saveToolStripMenuItem1.Click += new System.EventHandler(this.saveToolStripMenuItem1_Click);
            // 
            // cancelToolStripMenuItem
            // 
            this.cancelToolStripMenuItem.Name = "cancelToolStripMenuItem";
            this.cancelToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Z)));
            this.cancelToolStripMenuItem.Size = new System.Drawing.Size(55, 20);
            this.cancelToolStripMenuItem.Text = "Cancel";
            this.cancelToolStripMenuItem.Click += new System.EventHandler(this.cancelToolStripMenuItem_Click);
            // 
            // deleteToolStripMenuItem
            // 
            this.deleteToolStripMenuItem.Name = "deleteToolStripMenuItem";
            this.deleteToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.D)));
            this.deleteToolStripMenuItem.Size = new System.Drawing.Size(52, 20);
            this.deleteToolStripMenuItem.Text = "Delete";
            this.deleteToolStripMenuItem.Click += new System.EventHandler(this.deleteToolStripMenuItem_Click);
            // 
            // closeToolStripMenuItem
            // 
            this.closeToolStripMenuItem.Name = "closeToolStripMenuItem";
            this.closeToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.F4)));
            this.closeToolStripMenuItem.Size = new System.Drawing.Size(48, 20);
            this.closeToolStripMenuItem.Text = "Close";
            this.closeToolStripMenuItem.Click += new System.EventHandler(this.closeToolStripMenuItem_Click);
            // 
            // previewToolStripMenuItem
            // 
            this.previewToolStripMenuItem.Name = "previewToolStripMenuItem";
            this.previewToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
            this.previewToolStripMenuItem.Size = new System.Drawing.Size(60, 20);
            this.previewToolStripMenuItem.Text = "Preview";
            this.previewToolStripMenuItem.Click += new System.EventHandler(this.previewToolStripMenuItem_Click);
            // 
            // printToolStripMenuItem
            // 
            this.printToolStripMenuItem.Name = "printToolStripMenuItem";
            this.printToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.P)));
            this.printToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.printToolStripMenuItem.Text = "Print";
            this.printToolStripMenuItem.Click += new System.EventHandler(this.printToolStripMenuItem_Click);
            // 
            // emailToolStripMenuItem
            // 
            this.emailToolStripMenuItem.Name = "emailToolStripMenuItem";
            this.emailToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.F)));
            this.emailToolStripMenuItem.Size = new System.Drawing.Size(48, 20);
            this.emailToolStripMenuItem.Text = "Email";
            this.emailToolStripMenuItem.Click += new System.EventHandler(this.emailToolStripMenuItem_Click);
            // 
            // frmDailyHourWiseMuster
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(505, 478);
            this.Controls.Add(this.menuStrip1);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.sbAttendanceFormat);
            this.Controls.Add(this.teAttendanceFormat);
            this.Controls.Add(this.lcAttendanceFormat);
            this.Controls.Add(this.BtnMuster);
            this.Controls.Add(this.txtMuster);
            this.Controls.Add(this.lcMusterType);
            this.Controls.Add(this.btnProcYear);
            this.Controls.Add(this.txtProcYear);
            this.Controls.Add(this.lcProcessingYear);
            this.Controls.Add(this.btnMonth);
            this.Controls.Add(this.txtProcMonth);
            this.Controls.Add(this.lcProcessingMonth);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.dgrApprov);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.Name = "frmDailyHourWiseMuster";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Daily Hourwise Muster";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.frmDailyHourWiseMuster_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.frmDailyHourWiseMuster_FormClosed);
            this.Resize += new System.EventHandler(this.frmAttendanceIntegration_Resize);
            ((System.ComponentModel.ISupportInitialize)(this.dgrApprov)).EndInit();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lcProcessingMonth;
        private System.Windows.Forms.TextBox txtProcMonth;
        private System.Windows.Forms.Button btnMonth;
        private System.Windows.Forms.Label lcProcessingYear;
        private System.Windows.Forms.TextBox txtProcYear;
        private System.Windows.Forms.Button btnProcYear;
        private System.Windows.Forms.Button sbAttendanceFormat;
        private System.Windows.Forms.TextBox teAttendanceFormat;
        private System.Windows.Forms.Label lcAttendanceFormat;
        private System.Windows.Forms.Button BtnMuster;
        private System.Windows.Forms.TextBox txtMuster;
        private System.Windows.Forms.Label lcMusterType;
        private System.Windows.Forms.DataGridView dgrApprov;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton btnFirst;
        private System.Windows.Forms.ToolStripButton btnBack;
        private System.Windows.Forms.ToolStripButton btnForward;
        private System.Windows.Forms.ToolStripButton btnLast;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripButton btnEmail;
        private System.Windows.Forms.ToolStripButton btnLocate;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripButton btnNew;
        private System.Windows.Forms.ToolStripButton btnSave;
        private System.Windows.Forms.ToolStripButton btnEdit;
        private System.Windows.Forms.ToolStripButton btnCancel;
        private System.Windows.Forms.ToolStripButton btnDelete;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.ToolStripButton btnPreview;
        private System.Windows.Forms.ToolStripButton btnPrint;
        private System.Windows.Forms.ToolStripButton btnExportPdf;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator4;
        private System.Windows.Forms.ToolStripButton btnLogout;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator6;
        private System.Windows.Forms.ToolStripButton btnHelp;
        private System.Windows.Forms.ToolStripButton btnCalculator;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator7;
        private System.Windows.Forms.ToolStripButton btnExit;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem newToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem editToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem cancelToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem deleteToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem closeToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem previewToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem printToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem emailToolStripMenuItem;
    }
}

