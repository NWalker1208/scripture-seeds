import os
from os import path
from html.parser import HTMLParser
import xml.etree.ElementTree as ET

CACHE_DIR = "Cache"
XML_FILENAME = "output.xml"

class ScriptureParser:
    def __init__(self, reference):
        self.reference = reference
        self.__index = 0
        self.is_valid = True
        self.__parse_book()
        if not self.is_valid: return
        self.__index += 1
        self.__parse_chapter()
        if not self.is_valid: return
        self.__index += 1
        self.__parse_verse()


    def __parse_book(self):
        self.book = ""
        while self.__index < len(self.reference) and self.reference[self.__index].isalpha():
            self.book += self.reference[self.__index]
            self.__index += 1

        if len(self.book) == 0 or self.__index >= len(self.reference) or self.reference[self.__index] != ' ':
            self.is_valid = False
    

    def __parse_chapter(self):
        self.chapter = ""
        while self.__index < len(self.reference) and self.reference[self.__index].isnumeric():
            self.chapter += self.reference[self.__index]
            self.__index += 1

        if len(self.chapter) == 0 or self.__index >= len(self.reference) or self.reference[self.__index] != ':':
            self.is_valid = False
        else:
            self.chapter = int(self.chapter)
    

    def __parse_verse(self):
        self.verse = ""
        while self.__index < len(self.reference) and self.reference[self.__index].isnumeric():
            self.verse += self.reference[self.__index]
            self.__index += 1

        if len(self.verse) == 0:
            self.is_valid = False
        else:
            self.verse = int(self.verse)


    def get_scripture(self):
        return {"book": self.book, "chapter": self.chapter, "verse": self.verse}

class TopicParser(HTMLParser):
    def __init__(self, topic_set, convert_charrefs=True):
        self.onScripture = False
        self.link = ''
        self.topic_set = topic_set
        return super().__init__(convert_charrefs=convert_charrefs)

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
            parser = ScriptureParser(data)
            if parser.is_valid:
                topic_set["resources"].append(parser.get_scripture())

def create_xml_from_topic(parent, topic_set):
    el = ET.SubElement(parent, "resource")
    topic = ET.SubElement(el, "topic")
    topic.text = topic_set["name"]
    body = ET.SubElement(el, "body")
    title = ET.SubElement(body, "title")
    title.text = "test"
    return el

# Check if cache has been built
if not path.exists(CACHE_DIR):
    print("Please run GetTopicPages.py first.")
    exit()

# Get list of page files
page_files = os.listdir(CACHE_DIR)

print(f"Loading {len(page_files)} HTML files...")

# Load file contents
topic_pages = {}

for file in page_files:
    # Load cached page
    cached_file = open(CACHE_DIR + '/' + file, "r", encoding="utf8")
    topic_pages[os.path.splitext(file)[0]] = cached_file.read()
    cached_file.close()

print("Done")

# Parse HTML
print(f"Processing {len(page_files)} HTML files...")

topic_sets = []

for topic in topic_pages:
    topic_set = {"name": topic, "resources": []}
    parser = TopicParser(topic_set)
    parser.feed(topic_pages[topic])
    topic_sets.append(topic_set)

print("Done")

# Create XML
print("Creating XML document...")
root = ET.Element("library")
root.set("lang","eng")

for topic_set in topic_sets:
    create_xml_from_topic(root, topic_set)
    
tree = ET.ElementTree(root)
tree.write(XML_FILENAME)

print("Finished!")