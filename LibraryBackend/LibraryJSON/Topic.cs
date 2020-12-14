using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibraryJSON
{
    class Topic
    {
        public string id;
        public string name;
        public uint cost = 1;

        public SortedSet<Reference> scriptures = new SortedSet<Reference>();

        public Topic(string id, string name, uint cost = 1)
        {
            this.id = id;
            this.name = name;
            this.cost = cost;
        }

        // Operators for sorting
        public override bool Equals(object obj)
        {
            if (obj is Topic other)
                return id == other.id;
            else
                return false;
        }

        public static bool operator ==(Topic a, Topic b)
        {
            if (ReferenceEquals(a, null))
                return ReferenceEquals(b, null);
            return a.Equals(b);
        }
        public static bool operator !=(Topic a, Topic b) => !(a == b);

        public int CompareTo(Topic other) => id.CompareTo(other.id);

        public override int GetHashCode() => id.GetHashCode();
    }
}
