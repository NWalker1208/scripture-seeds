using Google.Apis.Customsearch.v1;
using Google.Apis.Customsearch.v1.Data;
using Google.Apis.Services;
using HtmlAgilityPack;
using System.Linq;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Text;

namespace LibraryXML
{
    public static class WebCrawler
    {
        // Gets the page at the given url and returns the HTML document
        private static HtmlDocument GetWebpage(string url)
        {
            WebClient client = new WebClient();
            byte[] htmlCode = client.DownloadData(url);
            HtmlDocument htmlDoc = new HtmlDocument();
            htmlDoc.LoadHtml(Encoding.UTF8.GetString(htmlCode));

            return htmlDoc;
        }

        // Creates text elements based on the text from the specified paragraphs at
        // the given URL.
        public static List<TextElement> GetWebText(string url, SortedSet<uint> paragraphs)
        {
            HtmlDocument htmlDoc = GetWebpage(url);
            List<TextElement> text = new List<TextElement>();

            // If no verses provided, attempt to include all
            if (paragraphs.Count == 0)
                paragraphs.UnionWith(Enumerable.Range(1, 250).Select(x => (uint) x));

            foreach (uint p in paragraphs)
            {
                HtmlNode paragraph = htmlDoc.GetElementbyId("p" + p.ToString());

                if (paragraph == null)
                    break;

                string pText = "";
                int verse = -1;

                List<HtmlNode> nodesToAdd = new List<HtmlNode>(paragraph.ChildNodes);

                while (nodesToAdd.Count > 0)
                {
                    HtmlNode node = nodesToAdd[0];

                    if (node.NodeType == HtmlNodeType.Text)
                        pText += node.InnerText;
                    else if (node.HasClass("verse-number"))
                        verse = int.Parse(node.InnerText);
                    else if (!node.HasClass("marker") &&
                             !node.HasClass("para-mark"))
                        nodesToAdd.InsertRange(1, node.ChildNodes);

                    nodesToAdd.RemoveAt(0);
                }

                text.Add(new TextElement(pText, verse));
            }

            return text;
        }
    
        // Creates a list of URL's that may contain scripture references to the topic.
        public static List<string> SearchWebByTopic(string topic)
        {
            string apiKey = ConfigurationManager.AppSettings["APIKey"];
            string searchEngineId = ConfigurationManager.AppSettings["CustomSearchID"];

            CustomsearchService customSearchService = new CustomsearchService(
                new BaseClientService.Initializer { ApiKey = apiKey }
            );

            CseResource.ListRequest listRequest = customSearchService.Cse.List();
            listRequest.Cx = searchEngineId;
            listRequest.Q = topic;

            Search search = listRequest.Execute();
            List<string> urls = new List<string>();

            foreach (Result result in search.Items)
                urls.Add(result.Link);

            return urls;
        }

        // Searches for scripture references at the given URL
        public static List<ScriptureReference> SearchPageForScriptures(string url, out List<string> secondaryURLs)
        {
            HtmlDocument htmlDoc = GetWebpage(url);
            List<ScriptureReference> scriptures = new List<ScriptureReference>();
            secondaryURLs = new List<string>();

            HtmlNodeCollection scriptureLinks = htmlDoc.DocumentNode.SelectNodes("//a[@class='scripture-ref']");

            string previousBook = null;
            if (scriptureLinks != null)
                foreach (HtmlNode link in scriptureLinks)
                {
                    ScriptureReference reference = ScriptureReference.Parse(link.InnerText, previousBook);

                    if (reference != null)
                    {
                        previousBook = reference.book;
                        scriptures.Add(reference);
                    }
                    else
                    {
                        string newURL = link.GetAttributeValue("href", "");

                        if (newURL != "")
                            secondaryURLs.Add("https://churchofjesuschrist.org" + newURL);
                    }
                }

            return scriptures;
        }
    }
}
