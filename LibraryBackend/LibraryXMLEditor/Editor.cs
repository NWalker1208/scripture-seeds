using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace LibraryXMLEditor
{
    public partial class Editor : Form
    {
        string file;
        Library lib;
        string filter;

        public string File
        {
            get => file;
            set
            {
                file = value;

                if (file == null)
                    Text = "Editor";
                else
                    Text = "Editor (" + file.Substring(file.LastIndexOf('\\') + 1) + ")";
            }
        }

        public Editor(string file = null)
        {
            InitializeComponent();

            if (file != null)
            {
                File = file;
                LoadLibrary();
            }
            else
            {
                File = null;
                lib = new Library();
                filterComboBox.SelectedIndex = 0;
                UpdateTreeView();
            }
        }

        public void SaveLibrary()
        {
            // Select file if not selected
            if (File == null)
            {
                if (saveFileDialog.ShowDialog() == DialogResult.OK)
                    File = saveFileDialog.FileName;
                else
                    return;
            }    

            XmlDocument doc = new XmlDocument();

            XmlDeclaration declaration = doc.CreateXmlDeclaration("1.0", "UTF-8", null);
            doc.AppendChild(declaration);

            doc.AppendChild(lib.ToXml(doc));
            doc.Save(File);
        }

        public void LoadLibrary()
        {
            if (File == null)
                return;

            try
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(File);
                lib = new Library(doc.GetElementsByTagName("library")[0]);
            }
            catch (Exception e)
            {
                MessageBox.Show("Error while opening XML file:\n" + e.ToString());
                File = null;
            }

            filterComboBox.SelectedIndex = 0;
            UpdateTreeView(false);
        }

        public void UpdateFilters()
        {
            // Get collection of topics
            HashSet<string> topics = new HashSet<string>();

            List<int> ids = lib.ResourceIDs;
            foreach (int id in ids)
            {
                StudyResource res = lib.GetResource(id);
                topics.UnionWith(res.topics);
            }

            // Update filter options
            List<string> topicList = topics.ToList();
            topicList.Sort();

            int i = 1;
            foreach (string topic in topicList)
            {
                if (i >= filterComboBox.Items.Count || filterComboBox.Items[i] as string != topic)
                {
                    int index = filterComboBox.Items.IndexOf(topic);

                    if (index == -1)
                        filterComboBox.Items.Insert(i, topic);
                    else
                        while (i < index)
                        {
                            filterComboBox.Items.RemoveAt(i);
                            index--;
                        }
                }

                i++;
            }

            while (filterComboBox.Items.Count > i)
                filterComboBox.Items.RemoveAt(i);

            if (filterComboBox.SelectedIndex == -1)
                filterComboBox.SelectedIndex = 0;
        }

        public void UpdateTreeView(bool selectNewNodes = true)
        {
            UpdateFilters();

            // Display resources in the order of their ID's
            List<int> ids = lib.ResourceIDs;
            ids.Sort();

            // Iterate over resources and update tree view for changes
            int n = 0;
            foreach (int id in ids)
            {
                StudyResource res = lib.GetResource(id);

                if (filter != null && !res.topics.Contains(filter))
                    continue;

                // Look ahead in nodes to see if one already exists
                TreeNode node = null;
                int i;
                for (i = n; i < libraryTreeView.Nodes.Count; i++)
                {
                    if (libraryTreeView.Nodes[i].Tag == res)
                    {
                        node = libraryTreeView.Nodes[i];
                        break;
                    }
                }    

                if (node == null)
                {
                    // If an existing node is not present, create one
                    node = libraryTreeView.Nodes.Insert(n, res.ToString());
                    node.Tag = res;

                    if (selectNewNodes)
                    {
                        libraryTreeView.SelectedNode = node;
                        libraryTreeView.Focus();
                    }
                }
                else
                {
                    // If one does exist, remove any extra nodes present before it
                    node.Text = res.ToString();
                    while (n < i)
                    {
                        if (libraryTreeView.SelectedNode == libraryTreeView.Nodes[n])
                            Deselect();

                        libraryTreeView.Nodes.RemoveAt(n);
                        i--;
                    }
                }

                UpdateElementTree(node, res, selectNewNodes);
                n++;
            }

            // Remove excess nodes
            while (n < libraryTreeView.Nodes.Count)
            {
                if (libraryTreeView.SelectedNode == libraryTreeView.Nodes[n])
                    Deselect();

                libraryTreeView.Nodes.RemoveAt(n);
            }
        }

        private void UpdateElementTree(TreeNode resourceNode, StudyResource resource, bool selectNewNodes = true)
        {
            int n = 0;
            foreach (StudyElement element in resource.body)
            {
                // Look ahead in nodes to see if one already exists
                bool createNew = true;
                int i;
                for (i = n; i < resourceNode.Nodes.Count; i++)
                {
                    if (resourceNode.Nodes[i].Tag == element)
                    {
                        createNew = false;
                        break;
                    }
                }

                if (createNew)
                {
                    // If an existing node is not present, create one
                    TreeNode node = resourceNode.Nodes.Insert(n, element.ToString());
                    node.Tag = element;

                    if (selectNewNodes)
                    {
                        libraryTreeView.SelectedNode = node;
                        libraryTreeView.Focus();
                    }
                }
                else
                {
                    // If one does exist, remove any extra nodes present before it
                    resourceNode.Nodes[i].Text = element.ToString();
                    while (n < i)
                    {
                        if (libraryTreeView.SelectedNode == resourceNode.Nodes[n])
                            Deselect();

                        resourceNode.Nodes.RemoveAt(n);
                        i--;
                    }
                }

                n++;
            }

            // Remove excess nodes
            while (n < resourceNode.Nodes.Count)
            {
                if (libraryTreeView.SelectedNode == resourceNode.Nodes[n])
                    Deselect();

                resourceNode.Nodes.RemoveAt(n);
            }
        }

        public void UpdateSettingsView(StudyResource resource = null, StudyElement element = null)
        {
            if (resource == null)
            {
                resourceConfig.Visible = false;
                resourceConfig.Enabled = false;
                elementConfig.Visible = false;
                elementConfig.Enabled = false;
            }
            else if (element == null)
            {
                elementConfig.Visible = false;
                elementConfig.Enabled = false;
                resourceConfig.Enabled = true;
                resourceConfig.Visible = true;

                resourceConfig.SetResource(resource);
            }
            else
            {
                resourceConfig.Visible = false;
                resourceConfig.Enabled = false;
                elementConfig.Enabled = true;
                elementConfig.Visible = true;

                elementConfig.SetElement(element);
            }
        }

        private void Deselect()
        {
            libraryTreeView.SelectedNode = null;
            removeButton.Enabled = false;
            UpdateSettingsView();
        }

        private void libraryTreeView_AfterSelect(object sender, TreeViewEventArgs e)
        {
            if (libraryTreeView.SelectedNode == null)
            {
                removeButton.Enabled = false;
                UpdateSettingsView();
            }
            else if (e.Node.Tag is StudyResource resource)
            {
                removeButton.Enabled = true;
                UpdateSettingsView(resource);
            }
            else if (e.Node.Tag is StudyElement element)
            {
                removeButton.Enabled = true;
                resource = e.Node.Parent.Tag as StudyResource;
                UpdateSettingsView(resource, element);
            }
        }

        private void resourceConfig_ResourceUpdate(object sender, EventArgs e) => UpdateTreeView();

        private void elementConfig_ElementUpdate(object sender, EventArgs e)
        {
            TreeNode node = libraryTreeView.SelectedNode;
            node.Text = node.Tag.ToString();
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            StudyResource newResource = new StudyResource("Genesis 1:1", "https://example.com");

            if (filter != null)
                newResource.topics.Add(filter);

            lib.AddResource(newResource);
            UpdateTreeView();
        }

        private void removeButton_Click(object sender, EventArgs e)
        {
            TreeNode node = libraryTreeView.SelectedNode;

            if (node.Tag is StudyResource resource)
            {
                lib.RemoveResource(resource.id);
                UpdateTreeView();
            }
            else if (node.Tag is StudyElement element)
            {
                resource = node.Parent.Tag as StudyResource;
                resource.body.Remove(element);
                UpdateTreeView();
            }
        }

        private void filterComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (filterComboBox.SelectedIndex == 0)
            {
                filter = null;
                UpdateTreeView(false);
            }
            else
            {
                filter = filterComboBox.Text;
                UpdateTreeView(false);
            }
        }

        // ToolStrip Items
        private void newToolStripMenuItem_Click(object sender, EventArgs e)
        {
            File = null;
            lib = new Library();
            UpdateTreeView();
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                File = openFileDialog.FileName;
                LoadLibrary();
            }
        }

        private void reloadToolStripMenuItem_Click(object sender, EventArgs e) => LoadLibrary();

        private void saveToolStripMenuItem_Click(object sender, EventArgs e) => SaveLibrary();

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                File = saveFileDialog.FileName;
                SaveLibrary();
            }
        }
    }
}
