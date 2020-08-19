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
            this.topicsLabel = new System.Windows.Forms.Label();
            this.referenceLabel = new System.Windows.Forms.Label();
            this.referenceTextBox = new System.Windows.Forms.TextBox();
            this.urlLabel = new System.Windows.Forms.Label();
            this.urlTextBox = new System.Windows.Forms.TextBox();
            this.topicListBox = new System.Windows.Forms.ListBox();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.addButton = new System.Windows.Forms.Button();
            this.removeButton = new System.Windows.Forms.Button();
            this.openLinkButton = new System.Windows.Forms.Button();
            this.tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel();
            this.autoLinkButton = new System.Windows.Forms.Button();
            this.tableLayoutPanel1.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.tableLayoutPanel3.SuspendLayout();
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
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.Controls.Add(this.topicsLabel, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.referenceLabel, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.referenceTextBox, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.urlLabel, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.topicListBox, 1, 2);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel2, 1, 3);
            this.tableLayoutPanel1.Controls.Add(this.tableLayoutPanel3, 1, 1);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 21);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 5;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(413, 297);
            this.tableLayoutPanel1.TabIndex = 1;
            // 
            // topicsLabel
            // 
            this.topicsLabel.AutoSize = true;
            this.topicsLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.topicsLabel.Location = new System.Drawing.Point(3, 56);
            this.topicsLabel.Margin = new System.Windows.Forms.Padding(3);
            this.topicsLabel.Name = "topicsLabel";
            this.topicsLabel.Size = new System.Drawing.Size(57, 95);
            this.topicsLabel.TabIndex = 4;
            this.topicsLabel.Text = "Topics";
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
            this.urlLabel.Size = new System.Drawing.Size(57, 27);
            this.urlLabel.TabIndex = 2;
            this.urlLabel.Text = "URL";
            this.urlLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // urlTextBox
            // 
            this.urlTextBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.urlTextBox.Location = new System.Drawing.Point(33, 3);
            this.urlTextBox.Name = "urlTextBox";
            this.urlTextBox.Size = new System.Drawing.Size(287, 20);
            this.urlTextBox.TabIndex = 3;
            this.urlTextBox.TextChanged += new System.EventHandler(this.urlTextBox_TextChanged);
            // 
            // topicListBox
            // 
            this.topicListBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.topicListBox.FormattingEnabled = true;
            this.topicListBox.Location = new System.Drawing.Point(66, 56);
            this.topicListBox.Name = "topicListBox";
            this.topicListBox.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended;
            this.topicListBox.Size = new System.Drawing.Size(344, 95);
            this.topicListBox.Sorted = true;
            this.topicListBox.TabIndex = 5;
            this.topicListBox.SelectedIndexChanged += new System.EventHandler(this.topicListBox_SelectedIndexChanged);
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.AutoSize = true;
            this.tableLayoutPanel2.ColumnCount = 2;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.Controls.Add(this.addButton, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.removeButton, 1, 0);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(63, 154);
            this.tableLayoutPanel2.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 1;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel2.Size = new System.Drawing.Size(350, 29);
            this.tableLayoutPanel2.TabIndex = 6;
            // 
            // addButton
            // 
            this.addButton.Dock = System.Windows.Forms.DockStyle.Top;
            this.addButton.Location = new System.Drawing.Point(3, 3);
            this.addButton.Name = "addButton";
            this.addButton.Size = new System.Drawing.Size(169, 23);
            this.addButton.TabIndex = 2;
            this.addButton.Text = "Add";
            this.addButton.UseVisualStyleBackColor = true;
            this.addButton.Click += new System.EventHandler(this.addButton_Click);
            // 
            // removeButton
            // 
            this.removeButton.Dock = System.Windows.Forms.DockStyle.Top;
            this.removeButton.Enabled = false;
            this.removeButton.Location = new System.Drawing.Point(178, 3);
            this.removeButton.Name = "removeButton";
            this.removeButton.Size = new System.Drawing.Size(169, 23);
            this.removeButton.TabIndex = 3;
            this.removeButton.Text = "Remove";
            this.removeButton.UseVisualStyleBackColor = true;
            this.removeButton.Click += new System.EventHandler(this.removeButton_Click);
            // 
            // openLinkButton
            // 
            this.openLinkButton.AutoSize = true;
            this.openLinkButton.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.openLinkButton.Location = new System.Drawing.Point(325, 2);
            this.openLinkButton.Margin = new System.Windows.Forms.Padding(2);
            this.openLinkButton.Name = "openLinkButton";
            this.openLinkButton.Size = new System.Drawing.Size(23, 23);
            this.openLinkButton.TabIndex = 7;
            this.openLinkButton.Text = ">";
            this.openLinkButton.UseVisualStyleBackColor = true;
            this.openLinkButton.Click += new System.EventHandler(this.openLinkButton_Click);
            // 
            // tableLayoutPanel3
            // 
            this.tableLayoutPanel3.AutoSize = true;
            this.tableLayoutPanel3.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.tableLayoutPanel3.ColumnCount = 3;
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel3.Controls.Add(this.urlTextBox, 1, 0);
            this.tableLayoutPanel3.Controls.Add(this.openLinkButton, 2, 0);
            this.tableLayoutPanel3.Controls.Add(this.autoLinkButton, 0, 0);
            this.tableLayoutPanel3.Dock = System.Windows.Forms.DockStyle.Top;
            this.tableLayoutPanel3.Location = new System.Drawing.Point(63, 26);
            this.tableLayoutPanel3.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel3.Name = "tableLayoutPanel3";
            this.tableLayoutPanel3.RowCount = 1;
            this.tableLayoutPanel3.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel3.Size = new System.Drawing.Size(350, 27);
            this.tableLayoutPanel3.TabIndex = 8;
            // 
            // autoLinkButton
            // 
            this.autoLinkButton.AutoSize = true;
            this.autoLinkButton.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.autoLinkButton.Location = new System.Drawing.Point(2, 2);
            this.autoLinkButton.Margin = new System.Windows.Forms.Padding(2);
            this.autoLinkButton.Name = "autoLinkButton";
            this.autoLinkButton.Size = new System.Drawing.Size(26, 23);
            this.autoLinkButton.TabIndex = 8;
            this.autoLinkButton.Text = "↻";
            this.autoLinkButton.UseVisualStyleBackColor = true;
            this.autoLinkButton.Click += new System.EventHandler(this.autoLinkButton_Click);
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
            this.tableLayoutPanel2.ResumeLayout(false);
            this.tableLayoutPanel3.ResumeLayout(false);
            this.tableLayoutPanel3.PerformLayout();
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
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.Button addButton;
        private System.Windows.Forms.Button removeButton;
        private System.Windows.Forms.Button openLinkButton;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel3;
        private System.Windows.Forms.Button autoLinkButton;
    }
}
