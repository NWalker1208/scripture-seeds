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
    public partial class ResourceConfig : UserControl
    {
        [Browsable(true)]
        [Category("Action")]
        [Description("Invoked when the resource is modified.")]
        public event EventHandler ResourceUpdate;

        StudyResource resource;

        public ResourceConfig()
        {
            InitializeComponent();
        }

        public void SetResource(StudyResource resource)
        {
            this.resource = resource;
            UpdateView();
        }

        private void UpdateView()
        {
            referenceTextBox.Text = resource.reference;
            urlTextBox.Text = resource.referenceURL;
            topicListBox.Items.Clear();
            foreach (string topic in resource.topics)
                topicListBox.Items.Add(topic);
            removeButton.Enabled = false;
        }

        private void referenceTextBox_TextChanged(object sender, EventArgs e)
        {
            if (Util.TrySet(ref resource.reference, referenceTextBox.Text))
                ResourceUpdate?.Invoke(this, new EventArgs());
        }

        private void urlTextBox_TextChanged(object sender, EventArgs e)
        {
            if (Util.TrySet(ref resource.referenceURL, urlTextBox.Text))
                ResourceUpdate?.Invoke(this, new EventArgs());
        }

        private void topicListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (topicListBox.SelectedIndices.Count == 0)
                removeButton.Enabled = false;
            else
                removeButton.Enabled = true;
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            TextInput topicForm = new TextInput("Add Topic");
            topicForm.ShowDialog();

            if (topicForm.value != null)
            {
                resource.topics.Add(topicForm.value.ToLower());
                ResourceUpdate?.Invoke(this, new EventArgs());
                UpdateView();
            }
        }

        private void removeButton_Click(object sender, EventArgs e)
        {
            foreach(string topic in topicListBox.SelectedItems)
                resource.topics.Remove(topic);

            if (topicListBox.SelectedItems.Count > 0)
                ResourceUpdate?.Invoke(this, new EventArgs());

            UpdateView();
        }

        private void mediaButton_Click(object sender, EventArgs e)
        {
            resource.body.Add(new MediaElement(MediaElement.Type.Image, ""));
            ResourceUpdate?.Invoke(this, new EventArgs());
        }

        private void titleButton_Click(object sender, EventArgs e)
        {
            resource.body.Add(new TitleElement(""));
            ResourceUpdate?.Invoke(this, new EventArgs());
        }

        private void textButton_Click(object sender, EventArgs e)
        {
            resource.body.Add(new TextElement(""));
            ResourceUpdate?.Invoke(this, new EventArgs());
        }

        private void webTextButton_Click(object sender, EventArgs e)
        {
            List<int> paragraphs = WebCrawler.VersesFromReference(resource.reference);

            if (paragraphs == null)
            {
                MessageBox.Show("Invalid reference.");
                return;
            }

            List<TextElement> webText = WebCrawler.GetWebText(resource.referenceURL, paragraphs);

            if (webText != null)
            {
                // Add title for chapter
                string title = resource.reference.Substring(0, resource.reference.IndexOf(':'));
                resource.body.Add(new TitleElement(title));

                resource.body.AddRange(webText);
                ResourceUpdate?.Invoke(this, new EventArgs());
            }
            else
                MessageBox.Show("Failed to obtain text from web.");
        }

        private void openLinkButton_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start(urlTextBox.Text);
        }

        private void autoLinkButton_Click(object sender, EventArgs e)
        {
            string url = WebCrawler.GenerateURL(referenceTextBox.Text);
            if (url != null)
                urlTextBox.Text = url;
            else
                MessageBox.Show("Invalid reference for scripture.");
        }
    }
}
