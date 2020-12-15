using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xml = LibraryXML;
using Json = LibraryJSON;
using System.Text.RegularExpressions;

namespace LibraryXMLtoJSON
{
    public static class Converter
    {
        public static Json.Index LibraryToIndex(Xml.Library library)
        {
            Json.Index index = new Json.Index(library.version, library.language);

            // Capture references from library
            foreach (Xml.StudyResource resource in library.resources)
            {
                Xml.ScriptureReference oldReference = Xml.ScriptureReference.Parse(resource.reference);

                // Format book for enum parsing
                string bookString = oldReference.book;

                // For book numbers
                if (bookString[1] == ' ')
                {
                    bookString += bookString[0];
                    bookString = bookString.Substring(2);
                }

                // For whitespace
                bookString = bookString.Replace(" ", "");

                // Create new reference
                Json.Volume volume = (Json.Volume)resource.category;
                Json.Book book = (Json.Book)Enum.Parse(typeof(Json.Book), bookString, true);
                Json.Reference reference = new Json.Reference(volume, book, oldReference.chapter, oldReference.verses);
                
                // Add reference to topic collection for all topics
                foreach (string topicName in resource.topics)
                {
                    Json.Topic topic = index.ByName(topicName);

                    if (topic == null)
                    {
                        topic = new Json.Topic(topicName.ToLower().Replace(' ', '_'), topicName);
                        index.topics.Add(topic);
                    }

                    topic.scriptures.Add(reference);
                }
            }

            return index;
        }
    }
}
