using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibraryXML
{
    public static class ScriptureConsts
    {
        public static readonly List<string> OldTestament = new List<string> { "genesis", "exodus", "leviticus", "numbers", "deuteronomy", "joshua", "judges", "ruth", "1 samuel", "2 samuel", "1 kings", "2 kings", "1 chronicles", "2 chronicles", "ezra", "nehemiah", "esther", "job", "psalms", "proverbs", "ecclesiastes", "the song of solomon", "isaiah", "jeremiah", "lamentations", "ezekiel", "daniel", "hosea", "joel", "amos", "obadiah", "jonah", "micah", "nahum", "habakkuk", "zephaniah", "haggai", "zechariah", "malachi" };
        public static readonly List<string> NewTestament = new List<string> { "matthew", "mark", "luke", "john", "acts", "romans", "1 corinthians", "2 corinthians", "galatians", "ephesians", "philippians", "colossians", "1 thessalonians", "2 thessalonians", "1 timothy", "2 timothy", "titus", "philemon", "hebrews", "james", "1 peter", "2 peter", "1 john", "2 john", "3 john", "jude", "revelation" };
        public static readonly List<string> BookOfMormon = new List<string> { "1 nephi", "2 nephi", "jacob", "enos", "jarom", "omni", "words of mormon", "mosiah", "alma", "helaman", "3 nephi", "4 nephi", "mormon", "ether", "moroni" };
        public static readonly List<string> DCTestament = new List<string> { "doctrine and covenants", "doctrine & covenants", "d&c" };
        public static readonly List<string> PearlOfGP = new List<string> { "moses", "abraham", "joseph smith–matthew", "joseph smith–history", "articles of faith" };
        public static readonly List<string> AllBooks = new List<List<string>> { OldTestament, NewTestament, BookOfMormon, DCTestament, PearlOfGP }.SelectMany(x => x).ToList();

        public static readonly string OldTestamentURL = "ot";
        public static readonly string NewTestamentURL = "nt";
        public static readonly string BookOfMormonURL = "bofm";
        public static readonly string DCTestamentURL = "dc-testament";
        public static readonly string PearlOfGPURL = "pgp";

        public static readonly Dictionary<string, string> Abbreviations = new Dictionary<string, string>
            { {"genesis", "gen"}, { "exodus", "ex" }, { "leviticus", "lev" }, { "numbers", "num" }, {"deuteronomy", "deut"}, {"joshua", "josh"}, {"judges", "judg"}, {"ruth", "ruth"}, {"1 samuel", "1-sam"}, {"2 samuel", "2-sam"}, {"1 kings", "1-kgs"}, {"2 kings", "2-kgs"}, {"1 chronicles", "1-chr"}, {"2 chronicles", "2-chr"}, {"ezra", "ezra"}, {"nehemiah", "neh"}, {"esther", "esth"}, {"job", "job"}, {"psalms", "ps"}, {"proverbs", "prov"}, {"ecclesiastes", "eccl"}, {"the song of solomon", "song"}, {"isaiah", "isa"}, {"jeremiah", "jer"}, {"lamentations", "lam"}, {"ezekiel", "ezek"}, {"daniel", "dan"}, {"hosea", "hosea"}, {"joel", "joel"}, {"amos", "amos"}, {"obadiah", "obad"}, {"jonah", "jonah"}, {"micah", "micah"}, {"nahum", "nahum"}, {"habakkuk", "hab"}, {"zephaniah", "zeph"}, {"haggai", "hag"}, {"zechariah", "zech"}, {"malachi", "mal"},
              {"matthew", "matt"}, {"mark", "mark"}, {"luke", "luke"}, {"john", "john"}, {"acts", "acts"}, {"romans", "rom"}, {"1 corinthians", "1-cor"}, {"2 corinthians", "2-cor"}, {"galatians", "gal"}, {"ephesians", "eph"}, {"philippians", "philip"}, {"colossians", "col"}, {"1 thessalonians", "1-thes"}, {"2 thessalonians", "2-thes"}, {"1 timothy", "1-tim"}, {"2 timothy", "2-tim"}, {"titus", "titus"}, {"philemon", "philem"}, {"hebrews", "heb"}, {"james", "james"}, {"1 peter", "1-pet"}, {"2 peter", "2-pet"}, {"1 john", "1-jn"}, {"2 john", "2-jn"}, {"3 john", "3-jn"}, {"jude", "jude"}, {"revelation", "rev"},
              {"1 nephi", "1-ne"}, {"2 nephi", "2-ne"}, {"jacob", "jacob"}, {"enos", "enos"}, {"jarom", "jarom"}, {"omni", "omni"}, {"words of mormon", "w-of-m"}, {"mosiah", "mosiah"}, {"alma", "alma"}, {"helaman", "hel"}, {"3 nephi", "3-ne"}, {"4 nephi", "4-ne"}, {"mormon", "morm"}, {"ether", "ether"}, {"moroni", "moro"},
              {"doctrine and covenants", "dc"}, {"doctrine & covenants", "dc"}, {"d&c", "dc"},
              {"moses", "moses"}, {"abraham", "abr"}, {"joseph smith–matthew", "js-m"}, {"joseph smith–history", "js-h"}, {"articles of faith", "a-of-f"} };

        public static string VolumeOf(string book)
        {
            if (OldTestament.Contains(book))
                return OldTestamentURL;
            if (NewTestament.Contains(book))
                return NewTestamentURL;
            if (BookOfMormon.Contains(book))
                return BookOfMormonURL;
            if (DCTestament.Contains(book))
                return DCTestamentURL;
            if (PearlOfGP.Contains(book))
                return PearlOfGPURL;

            return null;
        }
    }
}
