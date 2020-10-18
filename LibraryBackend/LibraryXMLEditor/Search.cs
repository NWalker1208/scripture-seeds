using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using LibraryXML;

namespace LibraryWebCrawler
{
    public partial class Search : Form
    {
        ScriptureSet scriptures;

        public Search(ScriptureSet existing)
        {
            scriptures = existing;
            InitializeComponent();
        }

        private void searchButton_Click(object sender, EventArgs e)
        {
            List<string> pages = WebCrawler.SearchWebByTopic(topicTextBox.Text.ToLower());
            websitesListBox.Items.Clear();

            foreach (string page in pages)
                websitesListBox.Items.Add(page, true);
        }

        private void scriptureButton_Click(object sender, EventArgs e)
        {
            downloadWorker.RunWorkerAsync();
            scriptureButton.Enabled = false;
        }

        private void downloadWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker backgroundWorker = (BackgroundWorker) sender;
            backgroundWorker.ReportProgress(0);

            SortedSet<ScriptureReference> allReferences = new SortedSet<ScriptureReference>();

            List<string> sitesToSearch = new List<string>(websitesListBox.CheckedItems.OfType<string>());

            int i = 0;
            foreach (string page in sitesToSearch)
            {
                List<ScriptureReference> found = WebCrawler.SearchPageForScriptures(page, out _);

                // Remove references to whole chapters
                found.RemoveAll(x => x.isChapter);

                allReferences.UnionWith(found);
                i++;

                backgroundWorker.ReportProgress((int) (100 * ((float) i / sitesToSearch.Count)));
                Thread.Sleep(250);
            }

            e.Result = allReferences;
        }

        private void downloadWorker_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            downloadProgress.Value = e.ProgressPercentage;
        }

        private void downloadWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            if (e.Result is SortedSet<ScriptureReference> found)
                scriptures.UnionWith(found, new SortedSet<string> { topicTextBox.Text.ToLower() });

            MessageBox.Show("Found " + scriptures.allReferences.Count().ToString() + " scriptures total.");

            scriptureButton.Enabled = true;
        }
    }
}
