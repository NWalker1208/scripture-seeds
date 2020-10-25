namespace LibraryXMLEditor
{
    partial class TopicConfig
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
            this.topicPriceBox = new System.Windows.Forms.NumericUpDown();
            this.topicComboBox = new System.Windows.Forms.ComboBox();
            ((System.ComponentModel.ISupportInitialize)(this.topicPriceBox)).BeginInit();
            this.SuspendLayout();
            // 
            // topicPriceBox
            // 
            this.topicPriceBox.Location = new System.Drawing.Point(159, 13);
            this.topicPriceBox.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.topicPriceBox.Name = "topicPriceBox";
            this.topicPriceBox.Size = new System.Drawing.Size(80, 20);
            this.topicPriceBox.TabIndex = 1;
            this.topicPriceBox.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.topicPriceBox.ValueChanged += new System.EventHandler(this.topicPriceBox_ValueChanged);
            // 
            // topicComboBox
            // 
            this.topicComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.topicComboBox.FormattingEnabled = true;
            this.topicComboBox.Location = new System.Drawing.Point(12, 13);
            this.topicComboBox.Name = "topicComboBox";
            this.topicComboBox.Size = new System.Drawing.Size(141, 21);
            this.topicComboBox.TabIndex = 2;
            this.topicComboBox.SelectedIndexChanged += new System.EventHandler(this.topicComboBox_SelectedIndexChanged);
            // 
            // TopicConfig
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(249, 48);
            this.Controls.Add(this.topicComboBox);
            this.Controls.Add(this.topicPriceBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Name = "TopicConfig";
            this.ShowIcon = false;
            this.Text = "Topic Prices";
            this.Load += new System.EventHandler(this.TopicConfig_Load);
            ((System.ComponentModel.ISupportInitialize)(this.topicPriceBox)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.NumericUpDown topicPriceBox;
        private System.Windows.Forms.ComboBox topicComboBox;
    }
}