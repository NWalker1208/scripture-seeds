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
        }

        private void referenceTextBox_TextChanged(object sender, EventArgs e) => resource.reference = referenceTextBox.Text;

        private void urlTextBox_TextChanged(object sender, EventArgs e) => resource.referenceURL = urlTextBox.Text;
    }
}
