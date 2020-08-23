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
        String file;
        Library lib;

        public Editor(String file)
        {
            this.file = file;

            InitializeComponent();
            LoadLibrary();
        }

        private void Editor_Load(object sender, EventArgs e)
        {
            UpdateTreeView();
        }

        private void saveButton_Click(object sender, EventArgs e) => SaveLibrary();

        private void loadButton_Click(object sender, EventArgs e)
        {
            LoadLibrary();
            UpdateTreeView();
        }

        public void SaveLibrary()
        {
            XmlDocument doc = new XmlDocument();

            XmlDeclaration declaration = doc.CreateXmlDeclaration("1.0", "UTF-8", null);
            doc.AppendChild(declaration);

            doc.AppendChild(lib.ToXml(doc));
            doc.Save(file);
        }

        public void LoadLibrary()
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(file);

            lib = new Library(doc.ChildNodes[1]);
            UpdateTreeView();
        }

        public void UpdateTreeView()
        {
            // Display resources in the order of their ID's
            List<int> ids = lib.ResourceIDs;
            ids.Sort();

            // Iterate over resources and update tree view for changes
            int n = 0;
            foreach (int id in ids)
            {
                StudyResource res = lib.GetResource(id);

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
                    libraryTreeView.SelectedNode = node;
                    libraryTreeView.Focus();
                }
                else
                {
                    // If one does exist, remove any extra nodes present before it
                    node.Text = res.ToString();
                    while (n < i)
                    {
                        libraryTreeView.Nodes.RemoveAt(n);
                        i--;
                    }
                }

                UpdateElementTree(node, res);
                n++;
            }

            // Remove excess nodes
            while (n < libraryTreeView.Nodes.Count)
                libraryTreeView.Nodes.RemoveAt(n);
        }

        private void UpdateElementTree(TreeNode resourceNode, StudyResource resource)
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
                    libraryTreeView.SelectedNode = node;
                    libraryTreeView.Focus();
                }
                else
                {
                    // If one does exist, remove any extra nodes present before it
                    resourceNode.Nodes[i].Text = element.ToString();
                    while (n < i)
                    {
                        resourceNode.Nodes.RemoveAt(n);
                        i--;
                    }
                }

                n++;
            }

            // Remove excess nodes
            while (n < resourceNode.Nodes.Count)
                resourceNode.Nodes.RemoveAt(n);
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

        private void resourceConfig_ResourceUpdate(object sender, EventArgs e)
        {
            UpdateTreeView();

            //TreeNode node = libraryTreeView.SelectedNode;
            //node.Text = node.Tag.ToString();
        }

        private void elementConfig_ElementUpdate(object sender, EventArgs e)
        {
            TreeNode node = libraryTreeView.SelectedNode;
            node.Text = node.Tag.ToString();
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            lib.AddResource(new StudyResource("Genesis 1:1", "https://example.com"));
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

            libraryTreeView.SelectedNode = null;
            removeButton.Enabled = false;
            UpdateSettingsView();
        }
    }
}
