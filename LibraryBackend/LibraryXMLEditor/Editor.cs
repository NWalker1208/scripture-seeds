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
            libraryTreeView.Nodes.Clear();

            foreach(int id in lib.ResourceIDs)
            {
                StudyResource resource = lib.GetResource(id);
                TreeNode resourceRoot = libraryTreeView.Nodes.Add(resource.ToString());
                resourceRoot.Tag = resource;

                for (int i = 0; i < resource.body.Count; i++)
                {
                    StudyElement element = resource.body[i];
                    TreeNode node = resourceRoot.Nodes.Add(element.ToString());
                    node.Tag = element;
                }
            }

            removeButton.Enabled = false;
            UpdateSettingsView();
        }

        private void libraryTreeView_AfterSelect(object sender, TreeViewEventArgs e)
        {
            removeButton.Enabled = true;

            if (e.Node.Tag is StudyResource resource)
            {
                UpdateSettingsView(resource);
            }
            else if (e.Node.Tag is StudyElement element)
            {
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
            TreeNode node = libraryTreeView.SelectedNode;
            node.Text = node.Tag.ToString();
        }

        private void elementConfig_ElementUpdate(object sender, EventArgs e)
        {
            TreeNode node = libraryTreeView.SelectedNode;
            node.Text = node.Tag.ToString();
        }

        private void addResourceButton_Click(object sender, EventArgs e)
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
        }
    }
}
