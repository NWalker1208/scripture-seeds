using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LibraryXMLEditor
{
    public partial class ElementConfig : UserControl
    {
        [Browsable(true)]
        [Category("Action")]
        [Description("Invoked when the element is modified.")]
        public event EventHandler ElementUpdate;

        StudyElement element;

        public ElementConfig()
        {
            InitializeComponent();
        }

        public void SetElement(StudyElement element)
        {
            this.element = element;
            UpdateView();
        }

        private void UpdateView()
        {
            if (element is MediaElement media)
            {
                if (media.type == MediaElement.Type.Image)
                    imageButton.Checked = true;
                else
                    videoButton.Checked = true;

                typeLabel.Text = "Type: Media";
                textFieldLabel.Text = "URL";
                textField.Text = media.url;
                textField.Multiline = false;
                numericFieldLabel.Visible = false;
                numericField.Visible = false;
                optionsLabel.Visible = true;
                optionsTable.Visible = true;
            }
            else if (element is TitleElement title)
            {
                typeLabel.Text = "Type: Title";
                textFieldLabel.Text = "Text";
                textField.Text = title.text;
                textField.Multiline = false;
                numericFieldLabel.Visible = false;
                numericField.Visible = false;
                optionsLabel.Visible = false;
                optionsTable.Visible = false;
            }
            else if (element is TextElement text)
            {
                typeLabel.Text = "Type: Text";
                textFieldLabel.Text = "Text";
                textField.Text = text.text;
                textField.Multiline = true;
                numericFieldLabel.Text = "Verse";
                numericFieldLabel.Visible = true;
                numericField.Value = text.verse;
                numericField.Visible = true;
                optionsLabel.Visible = false;
                optionsTable.Visible = false;
            }
        }

        private void textField_TextChanged(object sender, EventArgs e)
        {
            bool updated = false;

            if (element is MediaElement media)
                updated = Util.TrySet(ref media.url, textField.Text);
            else if (element is TitleElement title)
                updated = Util.TrySet(ref title.text, textField.Text);
            else if (element is TextElement text)
                updated = Util.TrySet(ref text.text, textField.Text);

            if (updated)
                ElementUpdate?.Invoke(this, new EventArgs());
        }

        private void numericField_ValueChanged(object sender, EventArgs e)
        {
            if (element is TextElement text)
                if (Util.TrySet(ref text.verse, (int)numericField.Value))
                    ElementUpdate?.Invoke(this, new EventArgs());
        }

        private void imageButton_CheckedChanged(object sender, EventArgs e)
        {
            if (element is MediaElement media)
                if (Util.TrySet(ref media.type, MediaElement.Type.Image))
                    ElementUpdate?.Invoke(this, new EventArgs());
        }

        private void videoButton_CheckedChanged(object sender, EventArgs e)
        {
            if (element is MediaElement media)
                if (Util.TrySet(ref media.type, MediaElement.Type.Video))
                    ElementUpdate?.Invoke(this, new EventArgs());
        }
    }
}
