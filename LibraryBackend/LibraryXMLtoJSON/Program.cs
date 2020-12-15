using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Xml;
using Xml = LibraryXML;
using Json = LibraryJSON;

namespace LibraryXMLtoJSON
{
    class Program
    {
        static void Main(string[] args)
        {
            // Check arguments
            if (args.Length < 2)
                throw new ArgumentException("Not enough arguments provided.");

            if (!File.Exists(args[0]))
                throw new FileNotFoundException("The given input file does not exist.");

            // Read XML file
            StreamReader inputXml = new StreamReader(args[0]);

            XmlDocument doc = new XmlDocument();
            doc.Load(inputXml);
            Xml.Library library = new Xml.Library(doc.GetElementsByTagName("library")[0]);

            inputXml.Close();

            // Convert XML to JSON
            Json.Index index = Converter.LibraryToIndex(library);
            string json = index.ToJson();

            // Write JSON file
            StreamWriter outputJson = new StreamWriter(args[1], false);
            outputJson.Write(json);
            outputJson.Close();

            // Print human readable format
            Console.WriteLine(index.ToString());
        }
    }
}
