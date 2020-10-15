namespace LibraryWebCrawler
{
    partial class Search
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
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.topicTextBox = new System.Windows.Forms.TextBox();
            this.searchButton = new System.Windows.Forms.Button();
            this.websitesListBox = new System.Windows.Forms.CheckedListBox();
            this.scriptureButton = new System.Windows.Forms.Button();
            this.downloadProgress = new System.Windows.Forms.ProgressBar();
            this.downloadWorker = new System.ComponentModel.BackgroundWorker();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.Controls.Add(this.topicTextBox, 0, 0);
            this.tableLayoutPanel1.Controls.Add(this.searchButton, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.websitesListBox, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.scriptureButton, 1, 2);
            this.tableLayoutPanel1.Controls.Add(this.downloadProgress, 0, 2);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 3;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.Size = new System.Drawing.Size(800, 450);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // topicTextBox
            // 
            this.topicTextBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.topicTextBox.Location = new System.Drawing.Point(4, 4);
            this.topicTextBox.Margin = new System.Windows.Forms.Padding(4);
            this.topicTextBox.Name = "topicTextBox";
            this.topicTextBox.Size = new System.Drawing.Size(670, 20);
            this.topicTextBox.TabIndex = 0;
            // 
            // searchButton
            // 
            this.searchButton.Dock = System.Windows.Forms.DockStyle.Fill;
            this.searchButton.Location = new System.Drawing.Point(681, 3);
            this.searchButton.Name = "searchButton";
            this.searchButton.Size = new System.Drawing.Size(116, 23);
            this.searchButton.TabIndex = 1;
            this.searchButton.Text = "Search";
            this.searchButton.UseVisualStyleBackColor = true;
            this.searchButton.Click += new System.EventHandler(this.searchButton_Click);
            // 
            // websitesListBox
            // 
            this.websitesListBox.CheckOnClick = true;
            this.tableLayoutPanel1.SetColumnSpan(this.websitesListBox, 2);
            this.websitesListBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.websitesListBox.FormattingEnabled = true;
            this.websitesListBox.Location = new System.Drawing.Point(3, 32);
            this.websitesListBox.Name = "websitesListBox";
            this.websitesListBox.Size = new System.Drawing.Size(794, 386);
            this.websitesListBox.TabIndex = 2;
            // 
            // scriptureButton
            // 
            this.scriptureButton.Location = new System.Drawing.Point(681, 424);
            this.scriptureButton.Name = "scriptureButton";
            this.scriptureButton.Size = new System.Drawing.Size(116, 23);
            this.scriptureButton.TabIndex = 3;
            this.scriptureButton.Text = "Get Scriptures";
            this.scriptureButton.UseVisualStyleBackColor = true;
            this.scriptureButton.Click += new System.EventHandler(this.scriptureButton_Click);
            // 
            // downloadProgress
            // 
            this.downloadProgress.Dock = System.Windows.Forms.DockStyle.Top;
            this.downloadProgress.Location = new System.Drawing.Point(3, 424);
            this.downloadProgress.Name = "downloadProgress";
            this.downloadProgress.Size = new System.Drawing.Size(672, 23);
            this.downloadProgress.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.downloadProgress.TabIndex = 4;
            // 
            // downloadWorker
            // 
            this.downloadWorker.WorkerReportsProgress = true;
            this.downloadWorker.WorkerSupportsCancellation = true;
            this.downloadWorker.DoWork += new System.ComponentModel.DoWorkEventHandler(this.downloadWorker_DoWork);
            this.downloadWorker.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.downloadWorker_ProgressChanged);
            this.downloadWorker.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.downloadWorker_RunWorkerCompleted);
            // 
            // Search
            // 
            this.AcceptButton = this.searchButton;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Icon = global::LibraryXMLEditor.Properties.Resources.seeds_icon;
            this.Name = "Search";
            this.Text = "Search";
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.TextBox topicTextBox;
        private System.Windows.Forms.Button searchButton;
        private System.Windows.Forms.CheckedListBox websitesListBox;
        private System.Windows.Forms.Button scriptureButton;
        private System.ComponentModel.BackgroundWorker downloadWorker;
        private System.Windows.Forms.ProgressBar downloadProgress;
    }
}