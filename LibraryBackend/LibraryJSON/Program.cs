using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LibraryJSON
{
    class Program
    {
        static void Main(string[] args)
        {
            Index library = new Index(1);
            Topic topic = new Topic("jesus_christ", "Jesus Christ");

            Reference scriptureA = new Reference(Volume.BookOfMormon, Book.Alma, 32, new uint[] { 22, 21, 21 });
            Reference scriptureB = new Reference(Volume.BookOfMormon, Book.Alma, 32, new uint[] { 20, 23 });

            topic.scriptures.Add(scriptureA);
            topic.scriptures.Add(scriptureB);
            library.topics.Add(topic);

            Console.WriteLine(library.ToJson());
        }
    }
}
