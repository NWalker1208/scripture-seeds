using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace LibraryJSON
{
    public class Index
    {
        public string language;
        public uint version;
        public readonly uint schema = 1;

        public SortedSet<Topic> topics = new SortedSet<Topic>();

        public Index(uint version, string language = "eng")
        {
            this.version = version;
            this.language = language;
        }

        public Topic this[string id]
        {
            get => topics.FirstOrDefault((existing) => existing.id == id);
        }

        public Topic ByName(string name)
        {
            return topics.Where((existing) => existing.name == name).FirstOrDefault();
        }

        public static Index FromJson(string json) => JsonConvert.DeserializeObject<Index>(json, new ReferenceConverter());
        public string ToJson(bool indented = false) => JsonConvert.SerializeObject(this, indented ? Formatting.Indented : Formatting.None, new ReferenceConverter());

        public override string ToString()
        {
            return string.Format("Language: {0}, Version: {1}, Topics:\n\n{2}", language, version, string.Join("\n\n", topics));
        }
    }
}
