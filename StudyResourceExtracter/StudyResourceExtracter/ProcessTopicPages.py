import os
from os import path
from html.parser import HTMLParser

CACHE_DIR = "Cache"

# Check if cache has been built
if not path.exists(CACHE_DIR):
    print("Please run GetTopicPages.py first.")
    exit()

# Get list of page files
page_files = os.listdir(CACHE_DIR)

print(f"Processing {len(page_files)} HTML files...")

# Load file contents
topic_pages = {}

for file in page_files:
    # Load cached page
    cached_file = open(CACHE_DIR + '/' + file, "r", encoding="utf8")
    topic_pages[os.path.splitext(file)[0]] = cached_file.read()
    cached_file.close()

# Parse HTML
class TopicParser(HTMLParser):
    onScripture = False
    link = ''

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            for attr in attrs:
                if attr[0] == 'class' and attr[1] == 'scripture-ref':
                    self.onScripture = True
                if attr[0] == 'href':
                    self.link = attr[1]

    def handle_endtag(self, tag):
        if tag == 'a':
            self.onScripture = False

    def handle_data(self, data):
        if self.onScripture:
            print(f"Scripture reference: \"{data}\" link:", self.link)

parser = TopicParser()

for topic in topic_pages:
    parser.feed(topic_pages[topic])