using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace LibraryXMLEditor
{
    public class Library
    {
        String language;
        
        Dictionary<int, StudyResource> resources;
        public List<int> ResourceIDs { get => resources.Keys.ToList(); }

        public Library(String language = "eng")
        {
            this.language = language;
            resources = new Dictionary<int, StudyResource>();
        }

        public Library(XmlNode node)
        {
            language = node.Attributes.GetNamedItem("lang").Value;

            resources = new Dictionary<int, StudyResource>();
            foreach (XmlNode child in node.ChildNodes)
            {
                if (child.Name == "resource")
                    AddResource(new StudyResource(child));
            }
        }

        public void AddResource(StudyResource resource)
        {
            resources.Add(resource.id, resource);
        }

        public StudyResource GetResource(int id)
        {
            return resources[id];
        }

        public XmlNode ToXml(XmlDocument document)
        {
            XmlNode node = document.CreateElement("library");

            // Set language attribute
            XmlAttribute lang = document.CreateAttribute("lang");
            lang.Value = language;
            node.Attributes.Append(lang);

            // Create resource elements
            foreach(KeyValuePair<int, StudyResource> resource in resources)
            {
                XmlNode child = resource.Value.ToXml(document);
                node.AppendChild(child);
            }

            return node;
        }
    }
}
