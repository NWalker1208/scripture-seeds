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
        }

        public void UpdateTreeView()
        {
            libraryTreeView.Nodes.Clear();

            foreach(StudyResource resource in lib.resources)
            {
                TreeNode resourceRoot = libraryTreeView.Nodes.Add(resource.id.ToString(), resource.ToString());

                foreach(StudyElement element in resource.body)
                {
                    resourceRoot.Nodes.Add(element.ToString());
                }
            }
        }

        private void libraryTreeView_AfterSelect(object sender, TreeViewEventArgs e)
        {
            if (e.Node.Parent == null)
                resourceConfig.SetResource(lib.resources[e.Node.Index]);
        }
    }
}
