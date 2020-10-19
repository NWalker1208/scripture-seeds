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
        public enum Category
        {
            OldTestament = ScriptureConsts.Volume.OldTestament,
            NewTestament = ScriptureConsts.Volume.NewTestament,
            BookOfMormon = ScriptureConsts.Volume.BookOfMormon,
            DoctrineAndCovenants = ScriptureConsts.Volume.DoctrineAndCovenants,
            PearlOfGreatPrice = ScriptureConsts.Volume.PearlOfGreatPrice,
            GeneralConference, Other
        }

        public Category category;
        public string reference;
        public string referenceURL;
        public ISet<string> topics;
        public List<StudyElement> body;

        public StudyResource(Category category, string reference, string referenceURL, int id = -1)
        {
            this.category = category;
            this.reference = reference;
            this.referenceURL = referenceURL;
            topics = new SortedSet<string>();
            body = new List<StudyElement>();
        }

        public StudyResource(XmlNode node)
        {
            // Get category attribute
            XmlNode catAttr = node.Attributes.GetNamedItem("category");

            if (catAttr != null)
                category = (Category)Enum.Parse(typeof(Category), catAttr.Value);

            // Parse topics and body
            topics = new SortedSet<string>();
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

            // If no category was given, attempt to guess
            if (catAttr == null && ScriptureReference.Parse(reference) is ScriptureReference parsed)
                category = (Category)parsed.volume;
        }

        public StudyResource(ScriptureReference reference, ISet<string> topics)
        {
            category = (Category) reference.volume;
            this.reference = reference.ToString();
            referenceURL = reference.GetURL();
            this.topics = new SortedSet<string>(topics);
            body = reference.GetText();
        }

        public override string ToString()
        {
            return "[" + category.ToString()[0] + "] " + reference + " (" + body.Count.ToString() + " elements)";
        }

        public XmlNode ToXml(XmlDocument document)
        {
            XmlNode node = document.CreateElement("resource");

            // Add category attribute
            XmlAttribute catAttr = document.CreateAttribute("category");
            catAttr.Value = category.ToString();
            node.Attributes.Append(catAttr);

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
