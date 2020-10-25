using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace LibraryXML
{
    public class Library
    {
        public string language;
        public List<StudyResource> resources;
        public Dictionary<string, uint> topicPrices;

        public Library(string language = "eng")
        {
            this.language = language;
            resources = new List<StudyResource>();
            topicPrices = new Dictionary<string, uint>();
        }

        public Library(XmlNode node)
        {
            language = node.Attributes.GetNamedItem("lang").Value;

            resources = new List<StudyResource>();
            topicPrices = new Dictionary<string, uint>();

            foreach (XmlNode child in node.ChildNodes)
            {
                if (child.Name == "summary")
                    foreach (XmlNode summaryChild in child.ChildNodes)
                    {
                        if (summaryChild.Name == "topic" &&
                            summaryChild.Attributes.GetNamedItem("price") is XmlNode price)
                            topicPrices.Add(summaryChild.InnerText, uint.Parse(price.Value));
                    }

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

            // Create summary
            XmlNode summary = document.CreateElement("summary");
            AppendTopics(document, summary);
            node.AppendChild(summary);

            // Create resource elements
            foreach (StudyResource resource in resources)
            {
                XmlNode child = resource.ToXml(document);
                node.AppendChild(child);
            }

            return node;
        }

        private void AppendTopics(XmlDocument document, XmlNode summary)
        {
            ISet<string> topics = GetAllTopics();

            foreach (string topic in topics)
            {
                XmlNode topicNode = document.CreateElement("topic");
                topicNode.InnerText = topic;

                // Set price attribute
                XmlAttribute price = document.CreateAttribute("price");
                
                uint priceValue = 1;
                if (topicPrices.ContainsKey(topic))
                    priceValue = topicPrices[topic];

                price.Value = priceValue.ToString();
                topicNode.Attributes.Append(price);
                summary.AppendChild(topicNode);
            }
        }

        public ISet<string> GetAllTopics()
        {
            SortedSet<string> topics = new SortedSet<string>();

            foreach (StudyResource resource in resources)
                topics.UnionWith(resource.topics);

            return topics;
        }
    }
}
