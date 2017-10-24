﻿namespace DadosReportParameterMaster
{
    partial class ParameterMast
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ParameterMast));
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            this.lblparaid = new System.Windows.Forms.Label();
            this.lblparacaption = new System.Windows.Forms.Label();
            this.lblparaoption = new System.Windows.Forms.Label();
            this.txtParamId = new System.Windows.Forms.TextBox();
            this.txtParamName = new System.Windows.Forms.TextBox();
            this.rtxtParamQuery = new System.Windows.Forms.RichTextBox();
            this.lblparaquery = new System.Windows.Forms.Label();
            this.btnGeneratePopupFields = new System.Windows.Forms.Button();
            this.lblpopupfielda = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.chkTo = new System.Windows.Forms.CheckBox();
            this.chkFrom = new System.Windows.Forms.CheckBox();
            this.label1 = new System.Windows.Forms.Label();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.btnFirst = new System.Windows.Forms.ToolStripButton();
            this.btnBack = new System.Windows.Forms.ToolStripButton();
            this.btnForward = new System.Windows.Forms.ToolStripButton();
            this.btnLast = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.btnNew = new System.Windows.Forms.ToolStripButton();
            this.btnSave = new System.Windows.Forms.ToolStripButton();
            this.btnEdit = new System.Windows.Forms.ToolStripButton();
            this.btnCancel = new System.Windows.Forms.ToolStripButton();
            this.btnDelete = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.btnCopy = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator6 = new System.Windows.Forms.ToolStripSeparator();
            this.btnLogout = new System.Windows.Forms.ToolStripButton();
            this.dgvPopupFields = new System.Windows.Forms.DataGridView();
            this.Col_Fieldname = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Col_FieldCaption = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Col_search = new System.Windows.Forms.DataGridViewCheckBoxColumn();
            this.Col_return = new System.Windows.Forms.DataGridViewCheckBoxColumn();
            this.ColType = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.cboParamType = new System.Windows.Forms.ComboBox();
            this.txtparatype = new System.Windows.Forms.TextBox();
            this.lblSearchDisplay = new System.Windows.Forms.TextBox();
            this.rtxtSearchFlds = new System.Windows.Forms.RichTextBox();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.panel1 = new System.Windows.Forms.Panel();
            this.txtParamCaption = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.newToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.editToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.cancelToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.deletToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.copyToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.groupBox1.SuspendLayout();
            this.toolStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPopupFields)).BeginInit();
            this.panel1.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // lblparaid
            // 
            this.lblparaid.AutoSize = true;
            this.lblparaid.Location = new System.Drawing.Point(14, 16);
            this.lblparaid.Name = "lblparaid";
            this.lblparaid.Size = new System.Drawing.Size(68, 14);
            this.lblparaid.TabIndex = 0;
            this.lblparaid.Text = "Parameter ID";
            // 
            // lblparacaption
            // 
            this.lblparacaption.AutoSize = true;
            this.lblparacaption.Location = new System.Drawing.Point(14, 42);
            this.lblparacaption.Name = "lblparacaption";
            this.lblparacaption.Size = new System.Drawing.Size(86, 14);
            this.lblparacaption.TabIndex = 1;
            this.lblparacaption.Text = "Parameter Name";
            // 
            // lblparaoption
            // 
            this.lblparaoption.AutoSize = true;
            this.lblparaoption.Location = new System.Drawing.Point(328, 71);
            this.lblparaoption.Name = "lblparaoption";
            this.lblparaoption.Size = new System.Drawing.Size(96, 14);
            this.lblparaoption.TabIndex = 2;
            this.lblparaoption.Text = "Parameter Option :";
            this.lblparaoption.Visible = false;
            // 
            // txtParamId
            // 
            this.txtParamId.Enabled = false;
            this.txtParamId.Location = new System.Drawing.Point(111, 14);
            this.txtParamId.Name = "txtParamId";
            this.txtParamId.Size = new System.Drawing.Size(98, 20);
            this.txtParamId.TabIndex = 3;
            // 
            // txtParamName
            // 
            this.txtParamName.Location = new System.Drawing.Point(111, 39);
            this.txtParamName.Name = "txtParamName";
            this.txtParamName.Size = new System.Drawing.Size(143, 20);
            this.txtParamName.TabIndex = 1;
            this.txtParamName.Validating += new System.ComponentModel.CancelEventHandler(this.txtParamName_Validating);
            // 
            // rtxtParamQuery
            // 
            this.rtxtParamQuery.Location = new System.Drawing.Point(111, 94);
            this.rtxtParamQuery.Name = "rtxtParamQuery";
            this.rtxtParamQuery.Size = new System.Drawing.Size(509, 88);
            this.rtxtParamQuery.TabIndex = 4;
            this.rtxtParamQuery.Text = "";
            // 
            // lblparaquery
            // 
            this.lblparaquery.AutoSize = true;
            this.lblparaquery.Location = new System.Drawing.Point(14, 94);
            this.lblparaquery.Name = "lblparaquery";
            this.lblparaquery.Size = new System.Drawing.Size(89, 14);
            this.lblparaquery.TabIndex = 9;
            this.lblparaquery.Text = "Parameter Query";
            // 
            // btnGeneratePopupFields
            // 
            this.btnGeneratePopupFields.Location = new System.Drawing.Point(441, 186);
            this.btnGeneratePopupFields.Name = "btnGeneratePopupFields";
            this.btnGeneratePopupFields.Size = new System.Drawing.Size(178, 27);
            this.btnGeneratePopupFields.TabIndex = 5;
            this.btnGeneratePopupFields.Text = "Generate Popup Fields";
            this.btnGeneratePopupFields.UseVisualStyleBackColor = true;
            this.btnGeneratePopupFields.Click += new System.EventHandler(this.btngenpopup_Click);
            // 
            // lblpopupfielda
            // 
            this.lblpopupfielda.AutoSize = true;
            this.lblpopupfielda.Location = new System.Drawing.Point(14, 262);
            this.lblpopupfielda.Name = "lblpopupfielda";
            this.lblpopupfielda.Size = new System.Drawing.Size(68, 14);
            this.lblpopupfielda.TabIndex = 11;
            this.lblpopupfielda.Text = "Popup Fields";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.chkTo);
            this.groupBox1.Controls.Add(this.chkFrom);
            this.groupBox1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.groupBox1.Location = new System.Drawing.Point(423, 59);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(134, 31);
            this.groupBox1.TabIndex = 2;
            this.groupBox1.TabStop = false;
            this.groupBox1.Visible = false;
            // 
            // chkTo
            // 
            this.chkTo.AutoSize = true;
            this.chkTo.Location = new System.Drawing.Point(85, 10);
            this.chkTo.Name = "chkTo";
            this.chkTo.Size = new System.Drawing.Size(37, 18);
            this.chkTo.TabIndex = 2;
            this.chkTo.Text = "To";
            this.chkTo.UseVisualStyleBackColor = true;
            // 
            // chkFrom
            // 
            this.chkFrom.AutoSize = true;
            this.chkFrom.Checked = true;
            this.chkFrom.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkFrom.Enabled = false;
            this.chkFrom.Location = new System.Drawing.Point(13, 10);
            this.chkFrom.Name = "chkFrom";
            this.chkFrom.Size = new System.Drawing.Size(50, 18);
            this.chkFrom.TabIndex = 9;
            this.chkFrom.Text = "From";
            this.chkFrom.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(14, 69);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(82, 14);
            this.label1.TabIndex = 14;
            this.label1.Text = "Parameter Type";
            // 
            // toolStrip1
            // 
            this.toolStrip1.BackColor = System.Drawing.SystemColors.ControlLight;
            this.toolStrip1.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.btnFirst,
            this.btnBack,
            this.btnForward,
            this.btnLast,
            this.toolStripSeparator1,
            this.btnNew,
            this.btnSave,
            this.btnEdit,
            this.btnCancel,
            this.btnDelete,
            this.toolStripSeparator3,
            this.btnCopy,
            this.toolStripSeparator6,
            this.btnLogout});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(633, 25);
            this.toolStrip1.TabIndex = 22;
            this.toolStrip1.Text = "toolStrip1";
//            this.toolStrip1.ItemClicked += new System.Windows.Forms.ToolStripItemClickedEventHandler(this.toolStrip1_ItemClicked);
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
            this.btnFirst.Click += new System.EventHandler(this.btnFirst_Click);
            // 
            // btnBack
            // 
            this.btnBack.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnBack.Image = ((System.Drawing.Image)(resources.GetObject("btnBack.Image")));
            this.btnBack.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnBack.Name = "btnBack";
            this.btnBack.Size = new System.Drawing.Size(23, 22);
            this.btnBack.Text = "toolStripButton2";
            this.btnBack.ToolTipText = "Previous";
            this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
            // 
            // btnForward
            // 
            this.btnForward.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnForward.Image = ((System.Drawing.Image)(resources.GetObject("btnForward.Image")));
            this.btnForward.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnForward.Name = "btnForward";
            this.btnForward.Size = new System.Drawing.Size(23, 22);
            this.btnForward.Text = "toolStripButton3";
            this.btnForward.ToolTipText = "Next";
            this.btnForward.Click += new System.EventHandler(this.btnForward_Click);
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
            this.btnLast.Click += new System.EventHandler(this.btnLast_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // btnNew
            // 
            this.btnNew.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnNew.Image = ((System.Drawing.Image)(resources.GetObject("btnNew.Image")));
            this.btnNew.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnNew.Name = "btnNew";
            this.btnNew.Size = new System.Drawing.Size(23, 22);
            this.btnNew.Text = "toolStripButton7";
            this.btnNew.ToolTipText = "New (Ctrl+N)";
            this.btnNew.Click += new System.EventHandler(this.btnNew_Click);
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
            this.btnSave.ToolTipText = "Save (Ctrl+S)";
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
            this.btnEdit.ToolTipText = "Edit (Ctrl+E)";
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
            this.btnCancel.ToolTipText = "Cancel (Ctrl+C)";
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
            this.btnDelete.ToolTipText = "Delete (Ctrl+D)";
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(6, 25);
            // 
            // btnCopy
            // 
            this.btnCopy.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnCopy.Image = ((System.Drawing.Image)(resources.GetObject("btnCopy.Image")));
            this.btnCopy.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnCopy.Name = "btnCopy";
            this.btnCopy.Size = new System.Drawing.Size(23, 22);
            this.btnCopy.Text = "toolStripButton1";
            this.btnCopy.ToolTipText = "Copy";
            this.btnCopy.Click += new System.EventHandler(this.btnCopy_Click);
            // 
            // toolStripSeparator6
            // 
            this.toolStripSeparator6.Name = "toolStripSeparator6";
            this.toolStripSeparator6.Size = new System.Drawing.Size(6, 25);
            // 
            // btnLogout
            // 
            this.btnLogout.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnLogout.Image = ((System.Drawing.Image)(resources.GetObject("btnLogout.Image")));
            this.btnLogout.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnLogout.Name = "btnLogout";
            this.btnLogout.Size = new System.Drawing.Size(23, 22);
            this.btnLogout.Text = "toolStripButton14";
            this.btnLogout.ToolTipText = "Close";
            this.btnLogout.Click += new System.EventHandler(this.btnLogout_Click);
            // 
            // dgvPopupFields
            // 
            this.dgvPopupFields.AllowUserToAddRows = false;
            this.dgvPopupFields.AllowUserToDeleteRows = false;
            this.dgvPopupFields.AllowUserToResizeColumns = false;
            this.dgvPopupFields.AllowUserToResizeRows = false;
            dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle2.Font = new System.Drawing.Font("Arial", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvPopupFields.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
            this.dgvPopupFields.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            this.dgvPopupFields.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Col_Fieldname,
            this.Col_FieldCaption,
            this.Col_search,
            this.Col_return,
            this.ColType});
            this.dgvPopupFields.Cursor = System.Windows.Forms.Cursors.Default;
            this.dgvPopupFields.Location = new System.Drawing.Point(111, 217);
            this.dgvPopupFields.Name = "dgvPopupFields";
            this.dgvPopupFields.RowHeadersVisible = false;
            this.dgvPopupFields.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.dgvPopupFields.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;
            this.dgvPopupFields.Size = new System.Drawing.Size(507, 181);
            this.dgvPopupFields.TabIndex = 6;
            this.dgvPopupFields.CellValidating += new System.Windows.Forms.DataGridViewCellValidatingEventHandler(this.dgvPopupFields_CellValidating);
            this.dgvPopupFields.CellEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellEnter);
            // 
            // Col_Fieldname
            // 
            this.Col_Fieldname.HeaderText = "Field Name";
            this.Col_Fieldname.Name = "Col_Fieldname";
            this.Col_Fieldname.ReadOnly = true;
            this.Col_Fieldname.Width = 120;
            // 
            // Col_FieldCaption
            // 
            this.Col_FieldCaption.HeaderText = "Field Caption";
            this.Col_FieldCaption.Name = "Col_FieldCaption";
            this.Col_FieldCaption.Width = 230;
            // 
            // Col_search
            // 
            this.Col_search.FalseValue = "false";
            this.Col_search.HeaderText = "Search";
            this.Col_search.Name = "Col_search";
            this.Col_search.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Col_search.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Col_search.TrueValue = "true";
            this.Col_search.Width = 75;
            // 
            // Col_return
            // 
            this.Col_return.FalseValue = "false";
            this.Col_return.HeaderText = "Return";
            this.Col_return.Name = "Col_return";
            this.Col_return.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Col_return.TrueValue = "true";
            this.Col_return.Width = 75;
            // 
            // ColType
            // 
            this.ColType.HeaderText = "ColType";
            this.ColType.Name = "ColType";
            this.ColType.Visible = false;
            // 
            // cboParamType
            // 
            this.cboParamType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboParamType.FormattingEnabled = true;
            this.cboParamType.Items.AddRange(new object[] {
            "VarChar",
            "Numeric",
            "DateTime"});
            this.cboParamType.Location = new System.Drawing.Point(111, 65);
            this.cboParamType.Name = "cboParamType";
            this.cboParamType.Size = new System.Drawing.Size(93, 22);
            this.cboParamType.TabIndex = 3;
            this.cboParamType.SelectedIndexChanged += new System.EventHandler(this.cboparatype_SelectedIndexChanged);
            // 
            // txtparatype
            // 
            this.txtparatype.Location = new System.Drawing.Point(117, 135);
            this.txtparatype.Name = "txtparatype";
            this.txtparatype.ReadOnly = true;
            this.txtparatype.Size = new System.Drawing.Size(96, 20);
            this.txtparatype.TabIndex = 25;
            // 
            // lblSearchDisplay
            // 
            this.lblSearchDisplay.BackColor = System.Drawing.SystemColors.Control;
            this.lblSearchDisplay.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.lblSearchDisplay.Enabled = false;
            this.lblSearchDisplay.Location = new System.Drawing.Point(111, 401);
            this.lblSearchDisplay.Name = "lblSearchDisplay";
            this.lblSearchDisplay.ReadOnly = true;
            this.lblSearchDisplay.Size = new System.Drawing.Size(508, 20);
            this.lblSearchDisplay.TabIndex = 26;
            this.lblSearchDisplay.Text = " FieldSearch #FieldReturn##FieldCaption";
            this.lblSearchDisplay.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // rtxtSearchFlds
            // 
            this.rtxtSearchFlds.BackColor = System.Drawing.Color.White;
            this.rtxtSearchFlds.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.rtxtSearchFlds.Enabled = false;
            this.rtxtSearchFlds.Location = new System.Drawing.Point(111, 424);
            this.rtxtSearchFlds.Name = "rtxtSearchFlds";
            this.rtxtSearchFlds.Size = new System.Drawing.Size(508, 54);
            this.rtxtSearchFlds.TabIndex = 27;
            this.rtxtSearchFlds.Text = "";
            // 
            // timer1
            // 
            this.timer1.Interval = 500;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.txtParamCaption);
            this.panel1.Controls.Add(this.txtParamName);
            this.panel1.Controls.Add(this.rtxtSearchFlds);
            this.panel1.Controls.Add(this.lblparaid);
            this.panel1.Controls.Add(this.btnGeneratePopupFields);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Controls.Add(this.lblSearchDisplay);
            this.panel1.Controls.Add(this.lblparacaption);
            this.panel1.Controls.Add(this.lblparaoption);
            this.panel1.Controls.Add(this.cboParamType);
            this.panel1.Controls.Add(this.dgvPopupFields);
            this.panel1.Controls.Add(this.lblpopupfielda);
            this.panel1.Controls.Add(this.txtParamId);
            this.panel1.Controls.Add(this.groupBox1);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.rtxtParamQuery);
            this.panel1.Controls.Add(this.lblparaquery);
            this.panel1.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.panel1.Location = new System.Drawing.Point(3, 28);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(627, 485);
            this.panel1.TabIndex = 28;
            // 
            // txtParamCaption
            // 
            this.txtParamCaption.Location = new System.Drawing.Point(422, 36);
            this.txtParamCaption.Name = "txtParamCaption";
            this.txtParamCaption.Size = new System.Drawing.Size(180, 20);
            this.txtParamCaption.TabIndex = 2;
            this.txtParamCaption.Validating += new System.ComponentModel.CancelEventHandler(this.txtParamCaption_Validating);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(325, 39);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(95, 14);
            this.label2.TabIndex = 1;
            this.label2.Text = "Parameter Caption";
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.newToolStripMenuItem,
            this.saveToolStripMenuItem,
            this.editToolStripMenuItem,
            this.cancelToolStripMenuItem,
            this.deletToolStripMenuItem,
            this.copyToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Padding = new System.Windows.Forms.Padding(5, 2, 0, 2);
            this.menuStrip1.Size = new System.Drawing.Size(633, 24);
            this.menuStrip1.TabIndex = 29;
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
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
            this.saveToolStripMenuItem.Size = new System.Drawing.Size(43, 20);
            this.saveToolStripMenuItem.Text = "Save";
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // editToolStripMenuItem
            // 
            this.editToolStripMenuItem.Name = "editToolStripMenuItem";
            this.editToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.E)));
            this.editToolStripMenuItem.Size = new System.Drawing.Size(39, 20);
            this.editToolStripMenuItem.Text = "Edit";
            this.editToolStripMenuItem.Click += new System.EventHandler(this.editToolStripMenuItem_Click);
            // 
            // cancelToolStripMenuItem
            // 
            this.cancelToolStripMenuItem.Name = "cancelToolStripMenuItem";
            this.cancelToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Z)));
            this.cancelToolStripMenuItem.Size = new System.Drawing.Size(55, 20);
            this.cancelToolStripMenuItem.Text = "Cancel";
            this.cancelToolStripMenuItem.Click += new System.EventHandler(this.cancelToolStripMenuItem_Click);
            // 
            // deletToolStripMenuItem
            // 
            this.deletToolStripMenuItem.Name = "deletToolStripMenuItem";
            this.deletToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.D)));
            this.deletToolStripMenuItem.Size = new System.Drawing.Size(52, 20);
            this.deletToolStripMenuItem.Text = "Delete";
            this.deletToolStripMenuItem.Click += new System.EventHandler(this.deletToolStripMenuItem_Click);
            // 
            // copyToolStripMenuItem
            // 
            this.copyToolStripMenuItem.Name = "copyToolStripMenuItem";
            this.copyToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.C)));
            this.copyToolStripMenuItem.Size = new System.Drawing.Size(47, 20);
            this.copyToolStripMenuItem.Text = "Copy";
            this.copyToolStripMenuItem.Click += new System.EventHandler(this.copyToolStripMenuItem_Click);
            // 
            // ParameterMast
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 14F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(633, 515);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.txtparatype);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.menuStrip1);
            this.Font = new System.Drawing.Font("Arial", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Fixed3D;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.KeyPreview = true;
            this.MainMenuStrip = this.menuStrip1;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "ParameterMast";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Dynamic Report Parameter Master";
            this.Load += new System.EventHandler(this.frmparamaster_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.ParameterMast_FormClosed);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ParameterMast_FormClosing);
            
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.ParameterMast_KeyDown);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPopupFields)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblparaid;
        private System.Windows.Forms.Label lblparacaption;
        private System.Windows.Forms.Label lblparaoption;
        private System.Windows.Forms.TextBox txtParamId;
        private System.Windows.Forms.TextBox txtParamName;
        private System.Windows.Forms.RichTextBox rtxtParamQuery;
        private System.Windows.Forms.Label lblparaquery;
        private System.Windows.Forms.Button btnGeneratePopupFields;
        private System.Windows.Forms.Label lblpopupfielda;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.CheckBox chkTo;
        private System.Windows.Forms.CheckBox chkFrom;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton btnFirst;
        private System.Windows.Forms.ToolStripButton btnBack;
        private System.Windows.Forms.ToolStripButton btnForward;
        private System.Windows.Forms.ToolStripButton btnLast;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripButton btnNew;
        private System.Windows.Forms.ToolStripButton btnSave;
        private System.Windows.Forms.ToolStripButton btnEdit;
        private System.Windows.Forms.ToolStripButton btnCancel;
        private System.Windows.Forms.ToolStripButton btnDelete;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.ToolStripButton btnLogout;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator6;
        private System.Windows.Forms.DataGridView dgvPopupFields;
        private System.Windows.Forms.ComboBox cboParamType;
        private System.Windows.Forms.TextBox txtparatype;
        private System.Windows.Forms.TextBox lblSearchDisplay;
        private System.Windows.Forms.RichTextBox rtxtSearchFlds;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem newToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem editToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem cancelToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem deletToolStripMenuItem;
        private System.Windows.Forms.TextBox txtParamCaption;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ToolStripButton btnCopy;
        private System.Windows.Forms.DataGridViewTextBoxColumn Col_Fieldname;
        private System.Windows.Forms.DataGridViewTextBoxColumn Col_FieldCaption;
        private System.Windows.Forms.DataGridViewCheckBoxColumn Col_search;
        private System.Windows.Forms.DataGridViewCheckBoxColumn Col_return;
        private System.Windows.Forms.ToolStripMenuItem copyToolStripMenuItem;
        private System.Windows.Forms.DataGridViewTextBoxColumn ColType;
    }
}

