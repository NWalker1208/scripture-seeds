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
            UpdateSettingsView();
        }

        public void UpdateTreeView()
        {
            libraryTreeView.Nodes.Clear();

            foreach(int id in lib.ResourceIDs)
            {
                StudyResource resource = lib.GetResource(id);
                TreeNode resourceRoot = libraryTreeView.Nodes.Add(resource.id.ToString(), resource.ToString());

                for (int i = 0; i < resource.body.Count; i++)
                {
                    resourceRoot.Nodes.Add(i.ToString(), resource.body[i].ToString());
                }
            }
        }

        private void libraryTreeView_AfterSelect(object sender, TreeViewEventArgs e)
        {
            if (e.Node.Level == 0)
                UpdateSettingsView(lib.GetResource(int.Parse(e.Node.Name)));
            else if (e.Node.Level == 1)
            {
                StudyResource resource = lib.GetResource(int.Parse(e.Node.Parent.Name));
                UpdateSettingsView(resource, resource.body[int.Parse(e.Node.Name)]);
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
            if (sender is ResourceConfig)
            {
                TreeNode node = libraryTreeView.SelectedNode;
                StudyResource resource = lib.GetResource(int.Parse(node.Name));
                node.Text = resource.ToString();
            }
        }

        private void elementConfig_ElementUpdate(object sender, EventArgs e)
        {
            if (sender is ElementConfig)
            {
                TreeNode node = libraryTreeView.SelectedNode;
                StudyResource resource = lib.GetResource(int.Parse(node.Parent.Name));
                node.Text = resource.body[int.Parse(node.Name)].ToString();
            }
        }

        private void resourceConfig_ResourceDelete(object sender, EventArgs e)
        {
            if (sender is ResourceConfig)
            {
                TreeNode node = libraryTreeView.SelectedNode;
                lib.RemoveResource(int.Parse(node.Name));

                UpdateTreeView();
                UpdateSettingsView();
            }
        }

        private void elementConfig_ElementDelete(object sender, EventArgs e)
        {
            if (sender is ElementConfig)
            {
                TreeNode node = libraryTreeView.SelectedNode;
                StudyResource resource = lib.GetResource(int.Parse(node.Parent.Name));
                resource.body.RemoveAt(int.Parse(node.Name));

                UpdateTreeView();
                UpdateSettingsView();
            }
        }
    }
}
