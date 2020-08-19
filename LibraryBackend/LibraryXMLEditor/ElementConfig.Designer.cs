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
            this.mediaButton = new System.Windows.Forms.RadioButton();
            this.typeLabel = new System.Windows.Forms.Label();
            this.titleButton = new System.Windows.Forms.RadioButton();
            this.textButton = new System.Windows.Forms.RadioButton();
            this.SuspendLayout();
            // 
            // mediaButton
            // 
            this.mediaButton.AutoSize = true;
            this.mediaButton.Location = new System.Drawing.Point(7, 20);
            this.mediaButton.Name = "mediaButton";
            this.mediaButton.Size = new System.Drawing.Size(54, 17);
            this.mediaButton.TabIndex = 0;
            this.mediaButton.TabStop = true;
            this.mediaButton.Text = "Media";
            this.mediaButton.UseVisualStyleBackColor = true;
            // 
            // typeLabel
            // 
            this.typeLabel.AutoSize = true;
            this.typeLabel.Location = new System.Drawing.Point(4, 4);
            this.typeLabel.Name = "typeLabel";
            this.typeLabel.Size = new System.Drawing.Size(31, 13);
            this.typeLabel.TabIndex = 1;
            this.typeLabel.Text = "Type";
            // 
            // titleButton
            // 
            this.titleButton.AutoSize = true;
            this.titleButton.Location = new System.Drawing.Point(67, 20);
            this.titleButton.Name = "titleButton";
            this.titleButton.Size = new System.Drawing.Size(45, 17);
            this.titleButton.TabIndex = 2;
            this.titleButton.TabStop = true;
            this.titleButton.Text = "Title";
            this.titleButton.UseVisualStyleBackColor = true;
            // 
            // textButton
            // 
            this.textButton.AutoSize = true;
            this.textButton.Location = new System.Drawing.Point(118, 20);
            this.textButton.Name = "textButton";
            this.textButton.Size = new System.Drawing.Size(46, 17);
            this.textButton.TabIndex = 3;
            this.textButton.TabStop = true;
            this.textButton.Text = "Text";
            this.textButton.UseVisualStyleBackColor = true;
            // 
            // ElementConfig
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.Controls.Add(this.textButton);
            this.Controls.Add(this.titleButton);
            this.Controls.Add(this.typeLabel);
            this.Controls.Add(this.mediaButton);
            this.Name = "ElementConfig";
            this.Size = new System.Drawing.Size(338, 239);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RadioButton mediaButton;
        private System.Windows.Forms.Label typeLabel;
        private System.Windows.Forms.RadioButton titleButton;
        private System.Windows.Forms.RadioButton textButton;
    }
}
