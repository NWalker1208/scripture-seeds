using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibraryJSON
{
    class Index
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
    }
}
