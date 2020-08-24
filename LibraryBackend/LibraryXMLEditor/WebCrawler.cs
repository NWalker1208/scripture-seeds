using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using HtmlAgilityPack;
using System.Diagnostics;

namespace LibraryXMLEditor
{
    static class WebCrawler
    {
        // Generates a list of paragraph numbers from a given reference
        // Returns null if the reference is invalid.
        public static List<int> VersesFromReference(String reference)
        {
            int colonIndex = reference.IndexOf(':');

            if (colonIndex == -1)
                return null;

            List<int> paragraphs = new List<int>();

            String verseStr = "";
            String blockStr = null;
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
        public static String GenerateURL(String reference, String lang = "eng")
        {
            // Determine book, chapter, and verse
            String volume = "bofm";
            String book;
            int chapter;
            int startVerse;
            String allVerses;

            int spaceIndex = reference.IndexOf(' ');
            int colonIndex = reference.IndexOf(':');
            int dashIndex = reference.IndexOf('-');
            int commaIndex = reference.IndexOf(',');

            if (spaceIndex == -1 || colonIndex == -1 || colonIndex == reference.Length - 1)
                return null;

            book = reference.Substring(0, spaceIndex).ToLower();
            chapter = int.Parse(reference.Substring(spaceIndex + 1, colonIndex - spaceIndex - 1));

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
            String url = "https://www.churchofjesuschrist.org/study/scriptures/";

            url += volume + "/" + book + "/" + chapter.ToString() + "." + allVerses;
            url += "?lang=" + lang + "#p" + startVerse.ToString();

            return url;
        }

        public static List<TextElement> GetWebText(String url, List<int> paragraphs)
        {
            List<TextElement> text = new List<TextElement>();

            using (WebClient client = new WebClient())
            {
                byte[] htmlCode = client.DownloadData(url);
                HtmlDocument htmlDoc = new HtmlDocument();
                htmlDoc.LoadHtml(Encoding.UTF8.GetString(htmlCode));

                foreach (int p in paragraphs)
                {
                    HtmlNode paragraph = htmlDoc.GetElementbyId("p" + p.ToString());

                    String pText = "";
                    int verse = -1;

                    foreach (HtmlNode child in paragraph.ChildNodes)
                    {
                        if (child.NodeType == HtmlNodeType.Text)
                            pText += child.InnerText;
                        else if (child.HasClass("study-note-ref"))
                            pText += child.ChildNodes[1].InnerText;
                        else if (child.HasClass("verse-number"))
                            verse = int.Parse(child.InnerText);
                    }

                    text.Add(new TextElement(pText, verse));
                }
            }

            return text;
        }
    }
}
