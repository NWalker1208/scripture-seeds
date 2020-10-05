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
            List<string> scriptures = new List<string>();

            Console.WriteLine("Found {0} pages referencing {1}", pages.Count, topic);

            foreach (string page in pages)
            {
                Console.WriteLine("Searching {0}...", page);
                scriptures.AddRange(WebCrawler.SearchPageForScriptures(page));
                System.Threading.Thread.Sleep(1000);
            }

            Console.WriteLine("Found {0} scriptures for the topic '{1}'", scriptures.Count, topic);
        }
    }
}
