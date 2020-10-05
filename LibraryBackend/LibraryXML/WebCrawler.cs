using Google.Apis.Customsearch.v1;
using Google.Apis.Customsearch.v1.Data;
using Google.Apis.Services;
using HtmlAgilityPack;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Text;

namespace LibraryXML
{
    public static class WebCrawler
    {
        // Generates a list of paragraph numbers from a given reference
        // Returns null if the reference is invalid.
        public static List<int> VersesFromReference(string reference)
        {
            int colonIndex = reference.IndexOf(':');

            if (colonIndex == -1)
                return null;

            List<int> paragraphs = new List<int>();

            string verseStr = "";
            string blockStr = null;
            for (int c = colonIndex + 1; c <= reference.Length; c++)
            {
                if (c == reference.Length || reference[c] == ',')
                {
                    int verse = int.Parse(verseStr);
                    int start = (blockStr == null) ? verse : int.Parse(blockStr);

                    for (int i = Math.Min(verse, start); i <= Math.Max(verse, start); i++)
                        paragraphs.Add(i);

                    verseStr = "";
                    blockStr = null;
                }
                else if (reference[c] == '-')
                {
                    blockStr = verseStr;
                    verseStr = "";
                }
                else if (char.IsDigit(reference[c]))
                    verseStr += reference[c];
            }

            return paragraphs;
        }

        // Creates a URL to the Gospel Library page for the given scripture reference.
        // Returns null if the reference is invalid.
        public static string GenerateURL(string reference, string lang = "eng")
        {
            // Determine book, chapter, and verse
            string volume;
            string book;
            int chapter;
            int startVerse;
            string allVerses;

            int spaceIndex = reference.IndexOf(' ', 2);
            int colonIndex = reference.IndexOf(':');
            int dashIndex = reference.IndexOf('-');
            int commaIndex = reference.IndexOf(',');

            if (spaceIndex == -1 || colonIndex == -1 || colonIndex == reference.Length - 1)
                return null;

            book = reference.Substring(0, spaceIndex).ToLower();
            chapter = int.Parse(reference.Substring(spaceIndex + 1, colonIndex - spaceIndex - 1));

            volume = ScriptureConsts.VolumeOf(book);

            if (volume == null)
                return null;

            if (dashIndex == -1 && commaIndex == -1)
            {
                startVerse = int.Parse(reference.Substring(colonIndex + 1));
                allVerses = reference.Substring(colonIndex + 1);
            }
            else
            {
                // Separate starting verse from list of all verses
                int endStartVerseIndex;

                if (dashIndex == -1 && commaIndex != -1)
                    endStartVerseIndex = commaIndex;
                else if (commaIndex == -1 && dashIndex != -1)
                    endStartVerseIndex = dashIndex;
                else
                    endStartVerseIndex = Math.Min(dashIndex, commaIndex);

                startVerse = int.Parse(reference.Substring(colonIndex + 1, endStartVerseIndex - colonIndex - 1));
                allVerses = reference.Substring(colonIndex + 1);
            }

            // Generate url
            string url = "https://www.churchofjesuschrist.org/study/scriptures/";

            url += volume + "/" + ScriptureConsts.Abbreviations[book] + "/" + chapter.ToString() + "." + allVerses;
            url += "?lang=" + lang + "#p" + startVerse.ToString();

            return url;
        }

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
        public static List<TextElement> GetWebText(string url, List<int> paragraphs)
        {
            HtmlDocument htmlDoc = GetWebpage(url);
            List<TextElement> text = new List<TextElement>();

            foreach (int p in paragraphs)
            {
                HtmlNode paragraph = htmlDoc.GetElementbyId("p" + p.ToString());

                string pText = "";
                int verse = -1;

                foreach (HtmlNode child in paragraph.ChildNodes)
                {
                    if (child.NodeType == HtmlNodeType.Text)
                        pText += child.InnerText;
                    else if (child.HasClass("study-note-ref"))
                        pText += child.ChildNodes[1].InnerText;
                    else if (child.HasClass("verse-number"))
                        verse = int.Parse(child.InnerText);
                    else if (child.Name == "span")
                        pText += child.InnerText;
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
        public static List<string> SearchPageForScriptures(string url)
        {
            HtmlDocument htmlDoc = GetWebpage(url);
            List<string> scriptures = new List<string>();

            HtmlNodeCollection scriptureLinks = htmlDoc.DocumentNode.SelectNodes("//a[@class='scripture-ref']");

            if (scriptureLinks != null)
                foreach (HtmlNode link in scriptureLinks)
                    scriptures.Add(link.InnerText);

            return scriptures;
        }
    }
}
