namespace LibraryXMLEditor
{
    partial class ElementConfig
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.typeLabel = new System.Windows.Forms.Label();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.textFieldLabel = new System.Windows.Forms.Label();
            this.textField = new System.Windows.Forms.TextBox();
            this.numericField = new System.Windows.Forms.NumericUpDown();
            this.numericFieldLabel = new System.Windows.Forms.Label();
            this.optionsLabel = new System.Windows.Forms.Label();
            this.optionsTable = new System.Windows.Forms.TableLayoutPanel();
            this.imageButton = new System.Windows.Forms.RadioButton();
            this.videoButton = new System.Windows.Forms.RadioButton();
            this.deleteButton = new System.Windows.Forms.Button();
            this.tableLayoutPanel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericField)).BeginInit();
            this.optionsTable.SuspendLayout();
            this.SuspendLayout();
            // 
            // typeLabel
            // 
            this.typeLabel.AutoSize = true;
            this.typeLabel.Location = new System.Drawing.Point(4, 4);
            this.typeLabel.Name = "typeLabel";
            this.typeLabel.Size = new System.Drawing.Size(49, 13);
            this.typeLabel.TabIndex = 1;
            this.typeLabel.Text = "Type: ***";
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Controls.Add(this.textFieldLabel, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.textField, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.numericField, 1, 1);
            this.tableLayoutPanel1.Controls.Add(this.numericFieldLabel, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.optionsLabel, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.optionsTable, 1, 2);
            this.tableLayoutPanel1.Controls.Add(this.deleteButton, 0, 3);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 20);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 4;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(338, 219);
            this.tableLayoutPanel1.TabIndex = 2;
            // 
            // textFieldLabel
            // 
            this.textFieldLabel.AutoSize = true;
            this.textFieldLabel.Dock = System.Windows.Forms.DockStyle.Left;
            this.textFieldLabel.Location = new System.Drawing.Point(3, 3);
            this.textFieldLabel.Margin = new System.Windows.Forms.Padding(3);
            this.textFieldLabel.Name = "textFieldLabel";
            this.textFieldLabel.Size = new System.Drawing.Size(35, 61);
            this.textFieldLabel.TabIndex = 0;
            this.textFieldLabel.Text = "label1";
            // 
            // textField
            // 
            this.textField.Dock = System.Windows.Forms.DockStyle.Top;
            this.textField.Location = new System.Drawing.Point(45, 3);
            this.textField.Multiline = true;
            this.textField.Name = "textField";
            this.textField.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textField.Size = new System.Drawing.Size(290, 61);
            this.textField.TabIndex = 1;
            this.textField.TextChanged += new System.EventHandler(this.textField_TextChanged);
            // 
            // numericField
            // 
            this.numericField.Dock = System.Windows.Forms.DockStyle.Top;
            this.numericField.Location = new System.Drawing.Point(45, 70);
            this.numericField.Maximum = new decimal(new int[] {
            999,
            0,
            0,
            0});
            this.numericField.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            -2147483648});
            this.numericField.Name = "numericField";
            this.numericField.Size = new System.Drawing.Size(290, 20);
            this.numericField.TabIndex = 2;
            this.numericField.ValueChanged += new System.EventHandler(this.numericField_ValueChanged);
            // 
            // numericFieldLabel
            // 
            this.numericFieldLabel.AutoSize = true;
            this.numericFieldLabel.Dock = System.Windows.Forms.DockStyle.Left;
            this.numericFieldLabel.Location = new System.Drawing.Point(3, 67);
            this.numericFieldLabel.Name = "numericFieldLabel";
            this.numericFieldLabel.Size = new System.Drawing.Size(35, 26);
            this.numericFieldLabel.TabIndex = 3;
            this.numericFieldLabel.Text = "label2";
            this.numericFieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // optionsLabel
            // 
            this.optionsLabel.AutoSize = true;
            this.optionsLabel.Dock = System.Windows.Forms.DockStyle.Left;
            this.optionsLabel.Location = new System.Drawing.Point(3, 93);
            this.optionsLabel.Name = "optionsLabel";
            this.optionsLabel.Size = new System.Drawing.Size(36, 23);
            this.optionsLabel.TabIndex = 4;
            this.optionsLabel.Text = "Media";
            this.optionsLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // optionsTable
            // 
            this.optionsTable.AutoSize = true;
            this.optionsTable.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.optionsTable.ColumnCount = 2;
            this.optionsTable.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.optionsTable.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.optionsTable.Controls.Add(this.imageButton, 0, 0);
            this.optionsTable.Controls.Add(this.videoButton, 1, 0);
            this.optionsTable.Dock = System.Windows.Forms.DockStyle.Top;
            this.optionsTable.Location = new System.Drawing.Point(42, 93);
            this.optionsTable.Margin = new System.Windows.Forms.Padding(0);
            this.optionsTable.Name = "optionsTable";
            this.optionsTable.RowCount = 1;
            this.optionsTable.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.optionsTable.Size = new System.Drawing.Size(296, 23);
            this.optionsTable.TabIndex = 5;
            // 
            // imageButton
            // 
            this.imageButton.AutoSize = true;
            this.imageButton.Location = new System.Drawing.Point(3, 3);
            this.imageButton.Name = "imageButton";
            this.imageButton.Size = new System.Drawing.Size(54, 17);
            this.imageButton.TabIndex = 0;
            this.imageButton.TabStop = true;
            this.imageButton.Text = "Image";
            this.imageButton.UseVisualStyleBackColor = true;
            this.imageButton.CheckedChanged += new System.EventHandler(this.imageButton_CheckedChanged);
            // 
            // videoButton
            // 
            this.videoButton.AutoSize = true;
            this.videoButton.Location = new System.Drawing.Point(151, 3);
            this.videoButton.Name = "videoButton";
            this.videoButton.Size = new System.Drawing.Size(52, 17);
            this.videoButton.TabIndex = 1;
            this.videoButton.TabStop = true;
            this.videoButton.Text = "Video";
            this.videoButton.UseVisualStyleBackColor = true;
            this.videoButton.CheckedChanged += new System.EventHandler(this.videoButton_CheckedChanged);
            // 
            // deleteButton
            // 
            this.tableLayoutPanel1.SetColumnSpan(this.deleteButton, 2);
            this.deleteButton.Dock = System.Windows.Forms.DockStyle.Top;
            this.deleteButton.Location = new System.Drawing.Point(3, 119);
            this.deleteButton.Name = "deleteButton";
            this.deleteButton.Size = new System.Drawing.Size(332, 23);
            this.deleteButton.TabIndex = 6;
            this.deleteButton.Text = "Delete";
            this.deleteButton.UseVisualStyleBackColor = true;
            this.deleteButton.Click += new System.EventHandler(this.deleteButton_Click);
            // 
            // ElementConfig
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.Controls.Add(this.tableLayoutPanel1);
            this.Controls.Add(this.typeLabel);
            this.Name = "ElementConfig";
            this.Size = new System.Drawing.Size(338, 239);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericField)).EndInit();
            this.optionsTable.ResumeLayout(false);
            this.optionsTable.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label typeLabel;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.Label textFieldLabel;
        private System.Windows.Forms.TextBox textField;
        private System.Windows.Forms.NumericUpDown numericField;
        private System.Windows.Forms.Label numericFieldLabel;
        private System.Windows.Forms.Label optionsLabel;
        private System.Windows.Forms.TableLayoutPanel optionsTable;
        private System.Windows.Forms.RadioButton imageButton;
        private System.Windows.Forms.RadioButton videoButton;
        private System.Windows.Forms.Button deleteButton;
    }
}
