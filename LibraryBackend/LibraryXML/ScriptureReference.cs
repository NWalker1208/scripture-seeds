using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace LibraryXML
{
    public class ScriptureReference : IComparable<ScriptureReference>
    {
        public string book;
        public uint chapter;
        public SortedSet<uint> verses;

        public int bookID
        {
            get => ScriptureConsts.AllBooks.IndexOf(book);
        }

        public bool isChapter
        {
            get => verses.Count == 0;
        }

        public ScriptureReference(string book, uint chapter, ISet<uint> verses = null)
        {
            this.book = book;
            this.chapter = chapter;
            this.verses = verses == null ? new SortedSet<uint>() : new SortedSet<uint>(verses);
        }

        public string ChapterToString()
        {
            string bookTitleCase = new CultureInfo("en-US", false).TextInfo.ToTitleCase(book);
            return bookTitleCase + ' ' + chapter.ToString();
        }

        public string VersesToString()
        {
            string str = "";

            if (verses.Count > 0)
            {
                uint prevVerse = verses.First();
                bool range = false;
                str += prevVerse.ToString();

                foreach (uint verse in verses.Skip(1))
                {
                    if (verse == prevVerse + 1)
                        range = true;
                    else
                    {
                        if (range)
                        {
                            range = false;
                            str += "-" + prevVerse.ToString();
                        }

                        str += "," + verse.ToString();
                    }

                    prevVerse = verse;
                }

                if (range)
                    str += "-" + prevVerse.ToString();
            }

            return str;
        }

        public override string ToString()
        {
            string str = ChapterToString();

            if (verses.Count > 0)
                str += ':' + VersesToString();

            return str;
        }

        // Creates a URL to the Gospel Library page for the scripture reference.
        public string GetURL(string lang = "eng")
        {
            string volume = ScriptureConsts.VolumeOf(book);

            string url = "https://www.churchofjesuschrist.org/study/scriptures/";
            url += volume + "/" + ScriptureConsts.Abbreviations[book] + "/" + chapter.ToString();

            if (verses.Count > 0)
                url += "." + VersesToString();

            url += "?lang=" + lang;

            if (verses.Count > 0)
               url += "#p" + verses.First().ToString();

            return url;
        }

        // Obtains the text of the scripture from the web
        public List<StudyElement> GetText(string lang = "eng")
        {
            List<StudyElement> body = new List<StudyElement>();
            body.Add(new TitleElement(ChapterToString()));

            List<TextElement> webText = WebCrawler.GetWebText(GetURL(lang), verses);
            if (webText == null)
                return null;

            body.AddRange(webText);
            return body;
        }

        // Gives a count of the number of verses in common between this reference
        // and the one provided.
        public int Overlap(ScriptureReference other)
        {
            if (book != other.book)
                return 0;

            if (chapter != other.chapter)
                return 0;

            if (verses.Count == 0 || other.verses.Count == 0)
            {
                if (verses.Count == 0 && other.verses.Count == 0)
                    return 1;

                return verses.Count + other.verses.Count;
            }
            
            int overlap = 0;

            foreach (uint verse in verses)
                if (other.verses.Contains(verse))
                    overlap++;

            return overlap;
        }

        // Creates a new reference without any verses
        public ScriptureReference ChapterOnly() => new ScriptureReference(book, chapter);

        public override bool Equals(object obj)
        {
            if (obj is ScriptureReference other)
            {
                return (book == other.book &&
                        chapter == other.chapter &&
                        verses.SetEquals(other.verses));
            }
            else
                return false;
        }

        public static bool operator ==(ScriptureReference a, ScriptureReference b)
        {
            if (ReferenceEquals(a, null))
                return ReferenceEquals(b, null);
            return a.Equals(b);
        }
        public static bool operator !=(ScriptureReference a, ScriptureReference b) => !(a == b);

        public int CompareTo(ScriptureReference other)
        {
            // Compare order of books
            int bookDif = bookID.CompareTo(other.bookID);

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

        public override int GetHashCode() => book.GetHashCode() | chapter.GetHashCode();

        // Parsing Functions

        // Returns null if parsing fails.
        public static ScriptureReference Parse(string str, string defaultBook = null)
        {
            string book;
            uint chapter;
            SortedSet<uint> verses;

            // Clean up string
            str = str.ToLower();
            str = Regex.Replace(str, @"\s+", " ");
            str = str.Replace('–', '-');

            // Parse string
            int i = 0;

            // Book
            if (ParseBook(str, ref i, out book))
            {
                // Space ( )
                if (i >= str.Length || str[i++] != ' ') return null;
            }
            else
            {
                // If no book is present, use default.
                // If no default was given, parsing has failed.
                if (defaultBook == null)
                    return null;
                else
                    book = defaultBook;
            }

            // Chapter
            if (!ParseChapter(str, ref i, out chapter)) return null;

            // Optional verses
            if (i < str.Length)
            {
                // Colon (:)
                if (str[i++] != ':') return null;
                // Verses
                if (!ParseVerses(str, ref i, out verses)) return null;
            }
            else
                verses = new SortedSet<uint>(); // Empty verse set

            return new ScriptureReference(book, chapter, verses);
        }

        private static bool ParseBook(string str, ref int i, out string book)
        {
            List<string> possibleBooks = new List<string>(ScriptureConsts.AllBooks);

            for (int strChar = i, bookChar = 0; strChar < str.Length && possibleBooks.Count > 1; strChar++, bookChar++)
            {
                // Remove all books whose character does not match the character of the string
                possibleBooks.RemoveAll((string bk) => (bookChar >= bk.Length || bk[bookChar] != str[strChar]));
            }

            // If all books were eliminated, parsing failed
            if (possibleBooks.Count != 1)
            {
                book = "";
                return false;
            }

            // Output last remaining book
            book = possibleBooks[0];

            // Advance i to complete name of book (check for period for appreviation)
            for (int bookChar = 0; bookChar < book.Length && str[i] != '.'; bookChar++, i++)
            {
                // If the book and string don't match, parsing failed
                if (book[bookChar] != str[i])
                    return false;
            }

            // Advance past period if necessary
            if (i < str.Length && str[i] == '.')
                i++;

            // If book is some variant of Doctrine and Covenants, change to basic version
            if (ScriptureConsts.DCTestament.Contains(book))
                book = ScriptureConsts.DCTestament[0];

            return true;
        }

        private static bool ParseChapter(string str, ref int i, out uint chapter)
        {
            return ParseInt(str, ref i, out chapter);
        }
        
        private static bool ParseVerses(string str, ref int i, out SortedSet<uint> verses)
        {
            verses = new SortedSet<uint>();

            uint first;
            if (!ParseInt(str, ref i, out first)) return false;
            verses.Add(first);

            return ParseVerseSet(str, ref i, verses, first);
        }

        private static bool ParseVerseSet(string str, ref int i, SortedSet<uint> verses, uint prev)
        {
            // If at end of string, verse set is complete
            if (i >= str.Length)
                return true;
                
            // If no separator is present, verse set is complete
            if (str[i] != ',' && str[i] != '-')
                return true;

            // Check if verses should be added between numbers (dash)
            bool span = false;
            if (str[i] == '-')
                span = true;

            // Move past separator
            i++;

            // Skip over whitespace
            while (i < str.Length && str[i] == ' ')
                i++;

            // Parse next number
            uint verse;
            if (!ParseInt(str, ref i, out verse)) return false;
            verses.Add(verse);

            // If separator was a dash, add verses in between
            if (span)
                for (uint v = prev + 1; v < verse; v++)
                    verses.Add(v);

            return ParseVerseSet(str, ref i, verses, verse);
        }

        private static bool ParseInt(string str, ref int i, out uint num)
        {
            string numStr = "";

            while (i < str.Length && char.IsDigit(str[i]))
                numStr += str[i++];

            return uint.TryParse(numStr, out num);
        }
    }
}
