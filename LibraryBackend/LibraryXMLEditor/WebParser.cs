using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using HtmlAgilityPack;

namespace LibraryXMLEditor
{
    static class WebParser
    {
        private static List<int> GetParagraphsFromURL(String url)
        {
            int verse = int.Parse(url.Substring(url.IndexOf('#') + 2));
            return new List<int> { verse };
            // This is naive at best
        }

        public static List<TextElement> GetWebText(String url)
        {
            List<int> paragraphs = GetParagraphsFromURL(url);

            List<TextElement> text = new List<TextElement>();

            using (WebClient client = new WebClient())
            {
                string htmlCode = client.DownloadString(url);
                HtmlDocument htmlDoc = new HtmlDocument();
                htmlDoc.LoadHtml(htmlCode);

                foreach (int p in paragraphs)
                {
                    HtmlNode paraNode = htmlDoc.GetElementbyId("p" + p.ToString());
                    text.Add(new TextElement(paraNode.InnerText, p));
                }
            }

            return text;
        }
    }
}
