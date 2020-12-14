using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibraryJSON
{
    enum Volume
    {
        OldTestament, NewTestament, BookOfMormon, DoctrineAndCovenants, PearlOfGreatPrice
    }

    enum Book
    {
        Genesis, Exodus, Leviticus, Numbers, Deuteronomy, Joshua, Judges, Ruth, Samuel1, Samuel2,
        Kings1, Kings2, Chronicles1, Chronicles2, Ezra, Nehemiah, Esther, Job, Psalms, Proverbs,
        Ecclesiastes, TheSongOfSolomon, Isaiah, Jeremiah, Lamentations, Ezekiel, Daniel, Hosea,
        Joel, Amos, Obadiah, Jonah, Micah, Nahum, Habakkuk, Zephaniah, Haggai, Zechariah, Malachi,

        Matthew, Mark, Luke, John, Acts, Romans, Corinthians1, Corinthians2, Galatians, Ephesians,
        Philippians, Colossians, Thessalonians1, Thessalonians2, Timothy1, Timothy2, Titus, Philemon,
        Hebrews, James, Peter1, Peter2, John1, John2, John3, Jude, Revelation,

        Nephi1, Nephi2, Jacob, Enos, Jarom, Omni, WordsOfMormon, Mosiah, Alma, Helaman, Nephi3, Nephi4,
        Mormon, Ether, Moroni,

        DoctrineAndCovenants, Moses, Abraham, JosephSmithMatthew, JosephSmithHistory, ArticlesOfFaith
    }

    class Reference : IComparable<Reference>
    {
        public Volume volume;
        public Book book;
        public uint chapter;

        public SortedSet<uint> verses = new SortedSet<uint>();

        public Reference(Volume volume, Book book, uint chapter, IEnumerable<uint> verses)
        {
            this.volume = volume;
            this.book = book;
            this.chapter = chapter;
            this.verses = new SortedSet<uint>(verses);
        }

        // Operators for sorting
        public override bool Equals(object obj)
        {
            if (obj is Reference other)
                return (book == other.book &&
                        chapter == other.chapter &&
                        verses.SetEquals(other.verses));
            else
                return false;
        }

        public static bool operator ==(Reference a, Reference b)
        {
            if (ReferenceEquals(a, null))
                return ReferenceEquals(b, null);
            else
                return a.Equals(b);
        }
        public static bool operator !=(Reference a, Reference b) => !(a == b);

        public int CompareTo(Reference other)
        {
            // Compare order of books
            int bookDif = book.CompareTo(other.book);

            if (bookDif != 0)
                return bookDif;

            // Compare order of chapters
            int chapterDif = chapter.CompareTo(other.chapter);

            if (chapterDif != 0)
                return chapterDif;

            // Compare order of verses
            foreach (Tuple<uint, uint> verse in verses.Zip(other.verses, Tuple.Create))
            {
                int verseCompare = verse.Item1.CompareTo(verse.Item2);

                if (verseCompare != 0)
                    return verseCompare;
            }

            // Compare length of verse sets
            return verses.Count.CompareTo(other.verses.Count);
        }

        public override int GetHashCode() => book.GetHashCode() | chapter.GetHashCode() | verses.GetHashCode();
    }
}
