using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace LibraryXMLEditor
{
    public class Library
    {
        String language;
        
        public List<StudyResource> resources;

        public Library(String language = "eng")
        {
            this.language = language;
            resources = new List<StudyResource>();
        }

        public Library(XmlNode node)
        {
            language = node.Attributes.GetNamedItem("lang").Value;

            resources = new List<StudyResource>();
            foreach (XmlNode child in node.ChildNodes)
            {
                if (child.Name == "resource")
                    resources.Add(new StudyResource(child));
            }
        }

        public XmlNode ToXml(XmlDocument document)
        {
            XmlNode node = document.CreateElement("library");

            // Set language attribute
            XmlAttribute lang = document.CreateAttribute("lang");
            lang.Value = language;
            node.Attributes.Append(lang);

            // Create resource elements
            foreach(StudyResource resource in resources)
            {
                XmlNode child = resource.ToXml(document);
                node.AppendChild(child);
            }

            return node;
        }
    }
}
