namespace LightweightPGO
{
    partial class Form1
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.checkBoxManuelQuery = new System.Windows.Forms.CheckBox();
            this.panel2 = new System.Windows.Forms.Panel();
            this.labelGranularity = new System.Windows.Forms.Label();
            this.labelValue = new System.Windows.Forms.Label();
            this.comboBoxGranularity = new System.Windows.Forms.ComboBox();
            this.textBoxValue = new System.Windows.Forms.TextBox();
            this.comboBoxOptions = new System.Windows.Forms.ComboBox();
            this.labelTest = new System.Windows.Forms.Label();
            this.comboBoxTest = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.buttonRunQuery = new System.Windows.Forms.Button();
            this.textBoxQuery = new System.Windows.Forms.TextBox();
            this.labelQuery = new System.Windows.Forms.Label();
            this.panel3 = new System.Windows.Forms.Panel();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.labelDataView = new System.Windows.Forms.Label();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.exitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.labelVisualize = new System.Windows.Forms.Label();
            this.checkedListBox1 = new System.Windows.Forms.CheckedListBox();
            this.panel4 = new System.Windows.Forms.Panel();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.menuStrip1.SuspendLayout();
            this.panel4.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ControlDark;
            this.panel1.Controls.Add(this.checkBoxManuelQuery);
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Controls.Add(this.buttonRunQuery);
            this.panel1.Controls.Add(this.textBoxQuery);
            this.panel1.Controls.Add(this.labelQuery);
            this.panel1.Location = new System.Drawing.Point(11, 48);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(477, 222);
            this.panel1.TabIndex = 0;
            // 
            // checkBoxManuelQuery
            // 
            this.checkBoxManuelQuery.AutoSize = true;
            this.checkBoxManuelQuery.Location = new System.Drawing.Point(3, 85);
            this.checkBoxManuelQuery.Name = "checkBoxManuelQuery";
            this.checkBoxManuelQuery.Size = new System.Drawing.Size(266, 17);
            this.checkBoxManuelQuery.TabIndex = 12;
            this.checkBoxManuelQuery.Text = "Check this box to manually update the query below";
            this.checkBoxManuelQuery.UseVisualStyleBackColor = true;
            this.checkBoxManuelQuery.CheckedChanged += new System.EventHandler(this.checkBoxManuelQuery_CheckedChanged);
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel2.Controls.Add(this.labelGranularity);
            this.panel2.Controls.Add(this.labelValue);
            this.panel2.Controls.Add(this.comboBoxGranularity);
            this.panel2.Controls.Add(this.textBoxValue);
            this.panel2.Controls.Add(this.comboBoxOptions);
            this.panel2.Controls.Add(this.labelTest);
            this.panel2.Controls.Add(this.comboBoxTest);
            this.panel2.Controls.Add(this.label1);
            this.panel2.Location = new System.Drawing.Point(3, 23);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(462, 56);
            this.panel2.TabIndex = 11;
            // 
            // labelGranularity
            // 
            this.labelGranularity.AutoSize = true;
            this.labelGranularity.Location = new System.Drawing.Point(3, 9);
            this.labelGranularity.Name = "labelGranularity";
            this.labelGranularity.Size = new System.Drawing.Size(57, 13);
            this.labelGranularity.TabIndex = 4;
            this.labelGranularity.Text = "Granularity";
            // 
            // labelValue
            // 
            this.labelValue.AutoSize = true;
            this.labelValue.Location = new System.Drawing.Point(360, 9);
            this.labelValue.Name = "labelValue";
            this.labelValue.Size = new System.Drawing.Size(34, 13);
            this.labelValue.TabIndex = 10;
            this.labelValue.Text = "Value";
            // 
            // comboBoxGranularity
            // 
            this.comboBoxGranularity.FormattingEnabled = true;
            this.comboBoxGranularity.Items.AddRange(new object[] {
            "Functions",
            "Basic Blocks"});
            this.comboBoxGranularity.Location = new System.Drawing.Point(6, 25);
            this.comboBoxGranularity.Name = "comboBoxGranularity";
            this.comboBoxGranularity.Size = new System.Drawing.Size(101, 21);
            this.comboBoxGranularity.TabIndex = 3;
            // 
            // textBoxValue
            // 
            this.textBoxValue.Location = new System.Drawing.Point(359, 26);
            this.textBoxValue.Name = "textBoxValue";
            this.textBoxValue.Size = new System.Drawing.Size(100, 20);
            this.textBoxValue.TabIndex = 9;
            // 
            // comboBoxOptions
            // 
            this.comboBoxOptions.FormattingEnabled = true;
            this.comboBoxOptions.Items.AddRange(new object[] {
            "Line Count"});
            this.comboBoxOptions.Location = new System.Drawing.Point(111, 25);
            this.comboBoxOptions.Name = "comboBoxOptions";
            this.comboBoxOptions.Size = new System.Drawing.Size(121, 21);
            this.comboBoxOptions.TabIndex = 5;
            // 
            // labelTest
            // 
            this.labelTest.AutoSize = true;
            this.labelTest.Location = new System.Drawing.Point(235, 9);
            this.labelTest.Name = "labelTest";
            this.labelTest.Size = new System.Drawing.Size(28, 13);
            this.labelTest.TabIndex = 8;
            this.labelTest.Text = "Test";
            // 
            // comboBoxTest
            // 
            this.comboBoxTest.FormattingEnabled = true;
            this.comboBoxTest.Items.AddRange(new object[] {
            "=",
            ">",
            "<",
            "!=",
            ">=",
            "<="});
            this.comboBoxTest.Location = new System.Drawing.Point(235, 25);
            this.comboBoxTest.Name = "comboBoxTest";
            this.comboBoxTest.Size = new System.Drawing.Size(121, 21);
            this.comboBoxTest.TabIndex = 6;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(108, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(43, 13);
            this.label1.TabIndex = 7;
            this.label1.Text = "Options";
            // 
            // buttonRunQuery
            // 
            this.buttonRunQuery.Location = new System.Drawing.Point(3, 190);
            this.buttonRunQuery.Name = "buttonRunQuery";
            this.buttonRunQuery.Size = new System.Drawing.Size(471, 23);
            this.buttonRunQuery.TabIndex = 2;
            this.buttonRunQuery.Text = "Run Query String";
            this.buttonRunQuery.UseVisualStyleBackColor = true;
            this.buttonRunQuery.Click += new System.EventHandler(this.buttonRunQuery_Click);
            // 
            // textBoxQuery
            // 
            this.textBoxQuery.Location = new System.Drawing.Point(3, 108);
            this.textBoxQuery.Multiline = true;
            this.textBoxQuery.Name = "textBoxQuery";
            this.textBoxQuery.Size = new System.Drawing.Size(471, 76);
            this.textBoxQuery.TabIndex = 1;
            // 
            // labelQuery
            // 
            this.labelQuery.AutoSize = true;
            this.labelQuery.Location = new System.Drawing.Point(3, 7);
            this.labelQuery.Name = "labelQuery";
            this.labelQuery.Size = new System.Drawing.Size(35, 13);
            this.labelQuery.TabIndex = 0;
            this.labelQuery.Text = "Query";
            // 
            // panel3
            // 
            this.panel3.BackColor = System.Drawing.SystemColors.ControlDark;
            this.panel3.Controls.Add(this.dataGridView1);
            this.panel3.Controls.Add(this.labelDataView);
            this.panel3.Location = new System.Drawing.Point(11, 356);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(477, 183);
            this.panel3.TabIndex = 13;
            // 
            // dataGridView1
            // 
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(6, 23);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(459, 150);
            this.dataGridView1.TabIndex = 1;
            // 
            // labelDataView
            // 
            this.labelDataView.AutoSize = true;
            this.labelDataView.Location = new System.Drawing.Point(3, 7);
            this.labelDataView.Name = "labelDataView";
            this.labelDataView.Size = new System.Drawing.Size(56, 13);
            this.labelDataView.TabIndex = 0;
            this.labelDataView.Text = "Data View";
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(500, 24);
            this.menuStrip1.TabIndex = 14;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.exitToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(37, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // exitToolStripMenuItem
            // 
            this.exitToolStripMenuItem.Name = "exitToolStripMenuItem";
            this.exitToolStripMenuItem.Size = new System.Drawing.Size(92, 22);
            this.exitToolStripMenuItem.Text = "Exit";
            this.exitToolStripMenuItem.Click += new System.EventHandler(this.exitToolStripMenuItem_Click);
            // 
            // labelVisualize
            // 
            this.labelVisualize.AutoSize = true;
            this.labelVisualize.Location = new System.Drawing.Point(3, 1);
            this.labelVisualize.Name = "labelVisualize";
            this.labelVisualize.Size = new System.Drawing.Size(146, 13);
            this.labelVisualize.TabIndex = 2;
            this.labelVisualize.Text = "Interact and Visualize Results";
            // 
            // checkedListBox1
            // 
            this.checkedListBox1.FormattingEnabled = true;
            this.checkedListBox1.Items.AddRange(new object[] {
            "Control Flow Graph",
            "Control Flow Graph (Matrix)",
            "Tree Map"});
            this.checkedListBox1.Location = new System.Drawing.Point(6, 17);
            this.checkedListBox1.Name = "checkedListBox1";
            this.checkedListBox1.Size = new System.Drawing.Size(158, 49);
            this.checkedListBox1.TabIndex = 3;
            // 
            // panel4
            // 
            this.panel4.BackColor = System.Drawing.SystemColors.ControlDark;
            this.panel4.Controls.Add(this.labelVisualize);
            this.panel4.Controls.Add(this.checkedListBox1);
            this.panel4.Location = new System.Drawing.Point(11, 276);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(477, 74);
            this.panel4.TabIndex = 5;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(500, 545);
            this.Controls.Add(this.panel4);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form1";
            this.Text = "Visualization Explorer";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.panel4.ResumeLayout(false);
            this.panel4.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.ComboBox comboBoxOptions;
        private System.Windows.Forms.Label labelGranularity;
        private System.Windows.Forms.ComboBox comboBoxGranularity;
        private System.Windows.Forms.Button buttonRunQuery;
        private System.Windows.Forms.TextBox textBoxQuery;
        private System.Windows.Forms.Label labelQuery;
        private System.Windows.Forms.Label labelValue;
        private System.Windows.Forms.TextBox textBoxValue;
        private System.Windows.Forms.Label labelTest;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox comboBoxTest;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.CheckBox checkBoxManuelQuery;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Label labelDataView;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem exitToolStripMenuItem;
        private System.Windows.Forms.Label labelVisualize;
        private System.Windows.Forms.CheckedListBox checkedListBox1;
        private System.Windows.Forms.Panel panel4;
    }
}

