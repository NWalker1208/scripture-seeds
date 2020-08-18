namespace LibraryXMLEditor
{
    partial class ResourceConfig
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
            this.resourceLabel = new System.Windows.Forms.Label();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.referenceLabel = new System.Windows.Forms.Label();
            this.referenceTextBox = new System.Windows.Forms.TextBox();
            this.urlLabel = new System.Windows.Forms.Label();
            this.urlTextBox = new System.Windows.Forms.TextBox();
            this.topicsLabel = new System.Windows.Forms.Label();
            this.topicListBox = new System.Windows.Forms.ListBox();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // resourceLabel
            // 
            this.resourceLabel.AutoSize = true;
            this.resourceLabel.Location = new System.Drawing.Point(4, 4);
            this.resourceLabel.Name = "resourceLabel";
            this.resourceLabel.Size = new System.Drawing.Size(83, 13);
            this.resourceLabel.TabIndex = 0;
            this.resourceLabel.Text = "Study Resource";
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.topicsLabel, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.referenceLabel, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.referenceTextBox, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.urlLabel, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.urlTextBox, 1, 1);
            this.tableLayoutPanel1.Controls.Add(this.topicListBox, 1, 2);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 21);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 4;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(413, 297);
            this.tableLayoutPanel1.TabIndex = 1;
            // 
            // referenceLabel
            // 
            this.referenceLabel.AutoSize = true;
            this.referenceLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.referenceLabel.Location = new System.Drawing.Point(3, 0);
            this.referenceLabel.Name = "referenceLabel";
            this.referenceLabel.Size = new System.Drawing.Size(57, 26);
            this.referenceLabel.TabIndex = 0;
            this.referenceLabel.Text = "Reference";
            this.referenceLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // referenceTextBox
            // 
            this.referenceTextBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.referenceTextBox.Location = new System.Drawing.Point(66, 3);
            this.referenceTextBox.Name = "referenceTextBox";
            this.referenceTextBox.Size = new System.Drawing.Size(344, 20);
            this.referenceTextBox.TabIndex = 1;
            this.referenceTextBox.TextChanged += new System.EventHandler(this.referenceTextBox_TextChanged);
            // 
            // urlLabel
            // 
            this.urlLabel.AutoSize = true;
            this.urlLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.urlLabel.Location = new System.Drawing.Point(3, 26);
            this.urlLabel.Name = "urlLabel";
            this.urlLabel.Size = new System.Drawing.Size(57, 26);
            this.urlLabel.TabIndex = 2;
            this.urlLabel.Text = "URL";
            this.urlLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // urlTextBox
            // 
            this.urlTextBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.urlTextBox.Location = new System.Drawing.Point(66, 29);
            this.urlTextBox.Name = "urlTextBox";
            this.urlTextBox.Size = new System.Drawing.Size(344, 20);
            this.urlTextBox.TabIndex = 3;
            this.urlTextBox.TextChanged += new System.EventHandler(this.urlTextBox_TextChanged);
            // 
            // topicsLabel
            // 
            this.topicsLabel.AutoSize = true;
            this.topicsLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.topicsLabel.Location = new System.Drawing.Point(3, 55);
            this.topicsLabel.Margin = new System.Windows.Forms.Padding(3);
            this.topicsLabel.Name = "topicsLabel";
            this.topicsLabel.Size = new System.Drawing.Size(57, 95);
            this.topicsLabel.TabIndex = 4;
            this.topicsLabel.Text = "Topics";
            // 
            // topicListBox
            // 
            this.topicListBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.topicListBox.FormattingEnabled = true;
            this.topicListBox.Location = new System.Drawing.Point(66, 55);
            this.topicListBox.Name = "topicListBox";
            this.topicListBox.Size = new System.Drawing.Size(344, 95);
            this.topicListBox.Sorted = true;
            this.topicListBox.TabIndex = 5;
            // 
            // ResourceConfig
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.tableLayoutPanel1);
            this.Controls.Add(this.resourceLabel);
            this.Name = "ResourceConfig";
            this.Size = new System.Drawing.Size(413, 318);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label resourceLabel;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.Label referenceLabel;
        private System.Windows.Forms.TextBox referenceTextBox;
        private System.Windows.Forms.Label urlLabel;
        private System.Windows.Forms.TextBox urlTextBox;
        private System.Windows.Forms.Label topicsLabel;
        private System.Windows.Forms.ListBox topicListBox;
    }
}
