namespace LibraryXMLEditor
{
    partial class Editor
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Editor));
            this.libraryTreeView = new System.Windows.Forms.TreeView();
            this.saveButton = new System.Windows.Forms.Button();
            this.loadButton = new System.Windows.Forms.Button();
            this.libraryLabel = new System.Windows.Forms.Label();
            this.elementConfig = new LibraryXMLEditor.ElementConfig();
            this.resourceConfig = new LibraryXMLEditor.ResourceConfig();
            this.SuspendLayout();
            // 
            // libraryTreeView
            // 
            this.libraryTreeView.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.libraryTreeView.Location = new System.Drawing.Point(12, 29);
            this.libraryTreeView.Name = "libraryTreeView";
            this.libraryTreeView.PathSeparator = "/";
            this.libraryTreeView.Size = new System.Drawing.Size(205, 382);
            this.libraryTreeView.TabIndex = 3;
            this.libraryTreeView.AfterSelect += new System.Windows.Forms.TreeViewEventHandler(this.libraryTreeView_AfterSelect);
            // 
            // saveButton
            // 
            this.saveButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.saveButton.Location = new System.Drawing.Point(670, 388);
            this.saveButton.Name = "saveButton";
            this.saveButton.Size = new System.Drawing.Size(75, 23);
            this.saveButton.TabIndex = 1;
            this.saveButton.Text = "Save";
            this.saveButton.UseVisualStyleBackColor = true;
            this.saveButton.Click += new System.EventHandler(this.saveButton_Click);
            // 
            // loadButton
            // 
            this.loadButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.loadButton.Location = new System.Drawing.Point(589, 388);
            this.loadButton.Name = "loadButton";
            this.loadButton.Size = new System.Drawing.Size(75, 23);
            this.loadButton.TabIndex = 0;
            this.loadButton.Text = "Load";
            this.loadButton.UseVisualStyleBackColor = true;
            this.loadButton.Click += new System.EventHandler(this.loadButton_Click);
            // 
            // libraryLabel
            // 
            this.libraryLabel.AutoSize = true;
            this.libraryLabel.Location = new System.Drawing.Point(13, 13);
            this.libraryLabel.Name = "libraryLabel";
            this.libraryLabel.Size = new System.Drawing.Size(92, 13);
            this.libraryLabel.TabIndex = 3;
            this.libraryLabel.Text = "Library Resources";
            // 
            // elementConfig
            // 
            this.elementConfig.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.elementConfig.BackColor = System.Drawing.SystemColors.Window;
            this.elementConfig.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.elementConfig.Location = new System.Drawing.Point(223, 29);
            this.elementConfig.Name = "elementConfig";
            this.elementConfig.Size = new System.Drawing.Size(522, 353);
            this.elementConfig.TabIndex = 5;
            this.elementConfig.Visible = false;
            this.elementConfig.ElementUpdate += new System.EventHandler(this.elementConfig_ElementUpdate);
            this.elementConfig.ElementDelete += new System.EventHandler(this.elementConfig_ElementDelete);
            // 
            // resourceConfig
            // 
            this.resourceConfig.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.resourceConfig.BackColor = System.Drawing.SystemColors.Window;
            this.resourceConfig.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.resourceConfig.Location = new System.Drawing.Point(223, 29);
            this.resourceConfig.Name = "resourceConfig";
            this.resourceConfig.Size = new System.Drawing.Size(522, 353);
            this.resourceConfig.TabIndex = 4;
            this.resourceConfig.Visible = false;
            this.resourceConfig.ResourceUpdate += new System.EventHandler(this.resourceConfig_ResourceUpdate);
            this.resourceConfig.ResourceDelete += new System.EventHandler(this.resourceConfig_ResourceDelete);
            // 
            // Editor
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.ClientSize = new System.Drawing.Size(757, 423);
            this.Controls.Add(this.elementConfig);
            this.Controls.Add(this.resourceConfig);
            this.Controls.Add(this.libraryLabel);
            this.Controls.Add(this.loadButton);
            this.Controls.Add(this.saveButton);
            this.Controls.Add(this.libraryTreeView);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(410, 250);
            this.Name = "Editor";
            this.Text = "Editor";
            this.Load += new System.EventHandler(this.Editor_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TreeView libraryTreeView;
        private System.Windows.Forms.Button saveButton;
        private System.Windows.Forms.Button loadButton;
        private System.Windows.Forms.Label libraryLabel;
        private ResourceConfig resourceConfig;
        private ElementConfig elementConfig;
    }
}

