using LibraryXML;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LibraryXMLEditor
{
    public partial class DownloadDialog : Form
    {
        ScriptureSet scriptures;
        Library library;

        public DownloadDialog(ScriptureSet scriptures, Library library)
        {
            this.scriptures = scriptures;
            this.library = library;

            InitializeComponent();
        }

        private void DownloadDialog_Load(object sender, EventArgs e)
        {
            downloadWorker.RunWorkerAsync();
        }

        private void downloadWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            downloadWorker.ReportProgress(0);

            // Add new scriptures to library
            int i = 0;
            int total = scriptures.allReferences.Count();
            foreach (ScriptureReference reference in scriptures.allReferences)
            {
                int exists = -1;
                foreach (int id in library.ResourceIDs)
                {
                    if (ScriptureReference.Parse(library.GetResource(id).reference) == reference)
                    {
                        exists = id;
                        break;
                    }
                }

                if (exists != -1)
                {
                    StudyResource resource = library.GetResource(exists);
                    resource.topics.UnionWith(scriptures.Topics(reference));
                }
                else
                {
                    StudyResource newResource = new StudyResource(reference, scriptures.Topics(reference));
                    if (newResource != null)
                        library.AddResource(newResource);

                    System.Threading.Thread.Sleep(250);
                }

                i++;
                downloadWorker.ReportProgress((int)(100 * ((float)i / total)));
            }
        }

        private void downloadWorker_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            progressBar1.Value = e.ProgressPercentage;
            downloadLabel.Text = "Downloading... " + e.ProgressPercentage.ToString() + "%";
        }

        private void downloadWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            Close();
        }
    }
}
