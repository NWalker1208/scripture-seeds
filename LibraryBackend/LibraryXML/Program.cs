using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibraryXML
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Topic: ");
            string topic = Console.ReadLine();

            List<string> pages = WebCrawler.SearchWebByTopic(topic);
            List<string> secondaryPages = new List<string>();
            List<ScriptureReference> scriptures = new List<ScriptureReference>();

            Console.WriteLine("Found {0} pages referencing '{1}'", pages.Count, topic);

            foreach (string page in pages)
            {
                Console.WriteLine("Searching {0}...", page);

                List<string> newPages;
                scriptures.AddRange(WebCrawler.SearchPageForScriptures(page, out newPages));
                secondaryPages.AddRange(newPages);

                System.Threading.Thread.Sleep(1000);
            }

            Console.WriteLine("Found {0} scriptures for the topic '{1}'", scriptures.Count, topic);
        }
    }
}
