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
            foreach (String topic in resource.topics)
                topicListBox.Items.Add(topic);
            removeButton.Enabled = false;
        }

        private void referenceTextBox_TextChanged(object sender, EventArgs e) => resource.reference = referenceTextBox.Text;

        private void urlTextBox_TextChanged(object sender, EventArgs e) => resource.referenceURL = urlTextBox.Text;

        private void topicListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (topicListBox.SelectedIndices.Count == 0)
                removeButton.Enabled = false;
            else
                removeButton.Enabled = true;
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            TextInput topicForm = new TextInput();
            topicForm.ShowDialog();

            if (topicForm.value != null)
            {
                resource.topics.Add(topicForm.value.ToLower());
                UpdateView();
            }
        }

        private void removeButton_Click(object sender, EventArgs e)
        {
            foreach(String topic in topicListBox.SelectedItems)
                resource.topics.Remove(topic);

            UpdateView();
        }

        private void openLinkButton_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start(urlTextBox.Text);
        }

        private void autoLinkButton_Click(object sender, EventArgs e)
        {
            urlTextBox.Text = GenerateURL(referenceTextBox.Text);
        }

        private static String GenerateURL(String reference, String lang = "eng")
        {
            // Determine book, chapter, and verse
            String volume = "bofm";
            String book;
            int chapter;
            int startVerse;
            String allVerses;

            int spaceIndex = reference.IndexOf(' ');
            int colonIndex = reference.IndexOf(':');
            int dashIndex = reference.IndexOf('-');
            int commaIndex = reference.IndexOf(',');

            book = reference.Substring(0, spaceIndex).ToLower();
            chapter = int.Parse(reference.Substring(spaceIndex + 1, colonIndex - spaceIndex - 1));

            if (dashIndex == -1 && commaIndex == -1)
            {
                startVerse = int.Parse(reference.Substring(colonIndex + 1));
                allVerses = reference.Substring(colonIndex + 1);
            }
            else
            {
                // Separate starting verse from list of all verses
                int endStartVerseIndex;

                if (dashIndex == -1 && commaIndex != -1)
                    endStartVerseIndex = commaIndex;
                else if (commaIndex == -1 && dashIndex != -1)
                    endStartVerseIndex = dashIndex;
                else
                    endStartVerseIndex = Math.Min(dashIndex, commaIndex);

                startVerse = int.Parse(reference.Substring(colonIndex + 1, endStartVerseIndex - colonIndex - 1));
                allVerses = reference.Substring(colonIndex + 1);
            }    

            // Generate url
            String url = "https://www.churchofjesuschrist.org/study/scriptures/";

            url += volume + "/" + book + "/" + chapter.ToString() + "." + allVerses;
            url += "?lang=" + lang + "#" + startVerse.ToString();

            return url;
        }
    }
}
