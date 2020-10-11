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
            // Scripture Set Test
            string input = null;
            ScriptureSet scriptures = new ScriptureSet();

            while (input != "")
            {
                Console.Write("Scripture Reference: ");
                input = Console.ReadLine();

                ScriptureReference reference = ScriptureReference.Parse(input);

                if (reference != null)
                {
                    Console.WriteLine("Parsed: {0}", reference);
                    scriptures.Add(reference, new SortedSet<string> { "test" } );
                }
                else
                    Console.WriteLine("Parsing failed.");

                Console.WriteLine("All Scriptures: {0}\n", string.Join("; ", scriptures.allReferences));
            }

            // Web Search
            Console.Write("Search Topic: ");
            string topic = Console.ReadLine();

            while (topic != "")
            {
                List<string> pages = WebCrawler.SearchWebByTopic(topic);
                List<string> secondaryPages = new List<string>();

                // Remove all usage of preach my gospel. Too many chapters combine several topics.
                pages.RemoveAll(x => x.Contains("preach-my-gospel"));

                Console.WriteLine("Found {0} pages referencing '{1}'", pages.Count, topic);

                int totalFound = 0;
                foreach (string page in pages)
                {
                    Console.WriteLine("Searching {0}...", page);

                    List<string> newPages;
                    List<ScriptureReference> found = WebCrawler.SearchPageForScriptures(page, out newPages);
                    totalFound += found.Count;

                    scriptures.UnionWith(found, new SortedSet<string> { topic });
                    secondaryPages.AddRange(newPages);

                    System.Threading.Thread.Sleep(1000);
                }

                Console.WriteLine("Found {0} scriptures for the topic '{1}'\n", totalFound, topic);

                // Get input for next search
                Console.Write("Search Topic: ");
                topic = Console.ReadLine();
            }

            Console.WriteLine("\nAll Topics: {0}", string.Join(", ", scriptures.allTopics));
            Console.WriteLine("All Scriptures:\n{0}", string.Join("\n", scriptures.allReferences));
            Console.ReadLine();
        }
    }
}
