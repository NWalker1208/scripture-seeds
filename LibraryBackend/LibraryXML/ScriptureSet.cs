using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibraryXML
{
    using ScriptureTopics = SortedDictionary<ScriptureReference, SortedSet<string>>;

    public class ScriptureSet
    {
        SortedDictionary<ScriptureReference, ScriptureTopics> chapterSets;

        public IEnumerable<ScriptureReference> chapters
        {
            get => chapterSets.Keys;
        }

        public IEnumerable<ScriptureReference> allReferences
        {
            get => chapterSets.SelectMany(x => x.Value.Keys);
        }

        public ISet<string> allTopics
        {
            get => new SortedSet<string>(chapterSets.SelectMany(x => x.Value.SelectMany(y => y.Value).ToHashSet()));
        }

        public ScriptureSet() => chapterSets = new SortedDictionary<ScriptureReference, ScriptureTopics>();

        public ScriptureSet(IEnumerable<ScriptureReference> references) : base()
        {
            UnionWith(references);
        }

        public void Add(ScriptureReference reference, IEnumerable<string> topics = null)
        {
            if (topics == null)
                topics = new SortedSet<string>();

            ScriptureReference chapter = reference.ChapterOnly();

            if (!chapterSets.ContainsKey(chapter))
                chapterSets.Add(chapter, new ScriptureTopics());

            // Check if references covers entire chapter
            var chapterReferences = chapterSets[chapter];

            if (reference.verses.Count == 0)
            {
                if (!chapterReferences.ContainsKey(reference))
                    chapterReferences.Add(reference, new SortedSet<string>());

                // Add given topics to chapter
                chapterReferences[reference].UnionWith(topics);
                return;
            }

            // Search chapter for overlapping references
            SortedSet<string> newTopics = new SortedSet<string>(topics);
            List<ScriptureReference> toRemove = new List<ScriptureReference>();

            foreach (ScriptureReference existing in chapterReferences.Keys)
            {
                // If existing references covers whole chapter, don't merge
                // If reference has overlapping verses, merge verses and topics
                if (existing.verses.Count > 0 && existing.Overlap(reference) > 0)
                {
                    // Merge new reference with existing
                    reference.verses.UnionWith(existing.verses);
                    newTopics.UnionWith(chapterReferences[existing]);

                    // Remove existing
                    toRemove.Add(existing);
                }
            }

            // Remove old overlapping references
            foreach (ScriptureReference remove in toRemove)
            {
                chapterReferences.Remove(remove);
            }

            // Add new unified reference
            chapterReferences.Add(reference, newTopics);
        }

        public void UnionWith(IEnumerable<ScriptureReference> references, IEnumerable<string> topics = null)
        {
            foreach (ScriptureReference reference in references)
                Add(reference, topics);
        }

        public bool Remove(ScriptureReference reference)
        {
            ScriptureReference chapter = reference.ChapterOnly();

            if (chapterSets.ContainsKey(chapter))
                if (chapterSets[chapter].Remove(reference))
                {
                    if (chapterSets[chapter].Count == 0)
                        chapterSets.Remove(chapter);

                    return true;
                }

            return false;
        }

        public bool Contains(ScriptureReference reference)
        {
            ScriptureReference chapter = reference.ChapterOnly();

            if (chapterSets.ContainsKey(chapter))
                return chapterSets[chapter].ContainsKey(reference);

            return false;
        }
    
        public ISet<string> Topics(ScriptureReference reference)
        {
            ScriptureReference chapter = reference.ChapterOnly();

            if (chapterSets.ContainsKey(chapter) &&
                chapterSets[chapter].ContainsKey(reference))
                return chapterSets[chapter][reference];

            return null;
        }
    }
}
