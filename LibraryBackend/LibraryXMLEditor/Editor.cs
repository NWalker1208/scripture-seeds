using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
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
        Library lib;

        public Editor()
        {
            InitializeComponent();

            lib = new Library();

            StudyResource resource = new StudyResource("test", "test.com");

            resource.AddTopic("truth");
            resource.AppendElement(new MediaElement(MediaElement.Type.Image, "image.com"));
            resource.AppendElement(new TitleElement("Chapter"));
            resource.AppendElement(new TextElement("yay!", 5));

            lib.AppendResource(resource);
        }

        private void Editor_Load(object sender, EventArgs e)
        {
            TreeNode root = libraryTreeView.Nodes.Add("test");
            root.Nodes.Add("test2");
            libraryTreeView.Nodes.Add("test3");
        }

        private void saveButton_Click(object sender, EventArgs e) => SaveLibrary();

        private void loadButton_Click(object sender, EventArgs e) => LoadLibrary();

        public void SaveLibrary()
        {
            XmlDocument doc = new XmlDocument();

            XmlDeclaration declaration = doc.CreateXmlDeclaration("1.0", "UTF-8", null);
            doc.AppendChild(declaration);

            doc.AppendChild(lib.ToXml(doc));
            doc.Save("test.xml");
        }

        public void LoadLibrary()
        {
            XmlDocument doc = new XmlDocument();
            doc.Load("test.xml");

            lib = new Library(doc.ChildNodes[1]);
        }
    }
}
