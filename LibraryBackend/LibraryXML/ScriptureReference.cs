using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace LibraryXML
{
    public class ScriptureReference
    {
        public string book;
        public uint chapter;
        public SortedSet<uint> verses;

        public ScriptureReference(string book, uint chapter, SortedSet<uint> verses)
        {
            this.book = book;
            this.chapter = chapter;
            this.verses = new SortedSet<uint>(verses);
        }

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

        public override string ToString()
        {
            string str = book.ToString() + ' ' + chapter.ToString() + ':';

            foreach (uint verse in verses)
            {
                str += verse.ToString() + ' ';
            }

            // TODO: Finish this

            return str;
        }

        // TODO: Generate link based on scripture reference

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
