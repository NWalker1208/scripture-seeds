using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace LibraryXMLEditor
{
    class MediaElement : StudyElement
    {
        public enum Type {Image, Video}

        public Type type;
        public String url;

        public MediaElement(Type type, String url)
        {
            this.type = type;
            this.url = url;
        }

        public override XmlNode ToXml(XmlDocument document)
        {
            XmlNode node;

            if (type == Type.Image)
                node = document.CreateElement("image");
            else
                node = document.CreateElement("video");

            XmlAttribute urlAttr = document.CreateAttribute("url");
            urlAttr.Value = url;
            node.Attributes.Append(urlAttr);

            return node;
        }
    }

    class TitleElement : StudyElement
    {
        public String text;

        public TitleElement(String text)
        {
            this.text = text;
        }

        public override XmlNode ToXml(XmlDocument document)
        {
            XmlNode node = document.CreateElement("title");
            node.InnerText = text;
            return node;
        }
    }

    class TextElement : StudyElement
    {
        public String text;
        public int verse;

        public TextElement(String text, int verse = -1)
        {
            this.text = text;
            this.verse = verse;
        }

        public override XmlNode ToXml(XmlDocument document)
        {
            XmlNode node = document.CreateElement("highlight");

            if (verse != -1)
            {
                XmlAttribute verseAttr = document.CreateAttribute("verse");
                verseAttr.Value = verse.ToString();
                node.Attributes.Append(verseAttr);
            }

            node.InnerText = text;

            return node;
        }
    }

    abstract class StudyElement
    {
        public abstract XmlNode ToXml(XmlDocument document);

        public static StudyElement FromXml(XmlNode node)
        {
            if (node.Name == "image")
                return new MediaElement(MediaElement.Type.Image, node.Attributes.GetNamedItem("url").Value);
            else if (node.Name == "video")
                return new MediaElement(MediaElement.Type.Video, node.Attributes.GetNamedItem("url").Value);
            else if (node.Name == "title")
                return new TitleElement(node.InnerText);
            else if (node.Name == "highlight")
            {
                XmlNode verse = node.Attributes.GetNamedItem("verse");

                if (verse == null)
                    return new TextElement(node.InnerText);
                else
                    return new TextElement(node.InnerText, int.Parse(verse.Value));
            }
            
            return null;
        }
    }
}
