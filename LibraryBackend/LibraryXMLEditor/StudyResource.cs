using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Activation;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;

namespace LibraryXMLEditor
{
    class StudyResource
    {
        static int nextId = 0;

        int id;
        List<String> topics;
        public String reference;
        public String referenceURL;
        List<StudyElement> body;

        public StudyResource(String reference, String referenceURL, int id = -1)
        {
            InitID(id);
            topics = new List<String>();
            this.reference = reference;
            this.referenceURL = referenceURL;
            body = new List<StudyElement>();
        }

        public StudyResource(XmlNode node)
        {
            InitID(int.Parse(node.Attributes.GetNamedItem("id").Value));

            topics = new List<String>();
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

        public void AddTopic(String topic)
        {
            if (!topics.Contains(topic))
                topics.Add(topic);
        }

        public void AppendElement(StudyElement element)
        {
            body.Add(element);
        }

        public XmlNode ToXml(XmlDocument document)
        {
            XmlNode node = document.CreateElement("resource");

            // Add id attribute
            XmlAttribute idAttr = document.CreateAttribute("id");
            idAttr.Value = id.ToString();
            node.Attributes.Append(idAttr);

            // Create elements for topics
            foreach(String topic in topics)
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
