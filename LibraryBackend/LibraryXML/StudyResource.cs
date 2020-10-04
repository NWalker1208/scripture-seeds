using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Activation;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace LibraryXML
{
    public class StudyResource
    {
        static int nextId = 0;

        int _id;
        public int id { get => _id; private set => _id = value; }

        public string reference;
        public string referenceURL;
        public HashSet<string> topics;
        public List<StudyElement> body;

        public StudyResource(string reference, string referenceURL, int id = -1)
        {
            InitID(id);
            this.reference = reference;
            this.referenceURL = referenceURL;
            topics = new HashSet<string>();
            body = new List<StudyElement>();
        }

        public StudyResource(XmlNode node)
        {
            InitID(int.Parse(node.Attributes.GetNamedItem("id").Value));

            topics = new HashSet<string>();
            body = new List<StudyElement>();

            foreach (XmlNode child in node.ChildNodes)
            {
                if (child.Name == "topic")
                    topics.Add(child.InnerText);
                else if (child.Name == "reference")
                {
                    reference = child.InnerText;
                    referenceURL = child.Attributes.GetNamedItem("url").Value;
                }
                else if (child.Name == "body")
                {
                    // Parse body
                    foreach (XmlNode elementNode in child.ChildNodes)
                    {
                        StudyElement element = StudyElement.FromXml(elementNode);

                        if (element != null)
                            body.Add(element);
                    }
                }
            }
        }

        private void InitID(int id = -1)
        {
            if (id == -1)
            {
                id = nextId;
                nextId++;
            }
            else if (id >= nextId)
                nextId = id + 1;

            this.id = id;
        }

        public override string ToString()
        {
            return id.ToString() + ". " + reference + " (" + body.Count.ToString() + " elements)";
        }

        public XmlNode ToXml(XmlDocument document)
        {
            XmlNode node = document.CreateElement("resource");

            // Add id attribute
            XmlAttribute idAttr = document.CreateAttribute("id");
            idAttr.Value = id.ToString();
            node.Attributes.Append(idAttr);

            // Create elements for topics
            foreach(string topic in topics)
            {
                XmlNode topicNode = document.CreateElement("topic");
                topicNode.InnerText = topic;
                node.AppendChild(topicNode);
            }

            // Create element for reference
            XmlNode referenceNode = document.CreateElement("reference");
            referenceNode.InnerText = reference;
            node.AppendChild(referenceNode);

            XmlAttribute urlAttr = document.CreateAttribute("url");
            urlAttr.Value = referenceURL;
            referenceNode.Attributes.Append(urlAttr);

            // Create body of resource
            XmlNode bodyNode = document.CreateElement("body");
            node.AppendChild(bodyNode);

            foreach(StudyElement studyEl in body)
            {
                XmlNode studyNode = studyEl.ToXml(document);
                bodyNode.AppendChild(studyNode);
            }

            return node;
        }
    }
}
