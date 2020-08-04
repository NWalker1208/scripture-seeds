import os
from os import path
import urllib.request
import time

PAUSE_TIME = 1
TOPICS_FILE = "Assets/topics.txt"
CACHE_DIR = "Cache"
CACHE_FILE = CACHE_DIR + "/{:}.html"
SOURCE_URL = "https://www.churchofjesuschrist.org/study/manual/gospel-topics/{:}?lang=eng"
# Use SOURCE_URL.format('topic_name')

# Load topic list
topics_file = open(TOPICS_FILE, "r", encoding="utf8")
topics = topics_file.readlines()
topics_file.close()

for i in range(len(topics)):
    # Modify topics to remove illegal characters
    topics[i] = topics[i].replace("\n","")
    topics[i] = topics[i].replace(",","")
    topics[i] = topics[i].replace("?","")
    topics[i] = topics[i].replace("'","")
    topics[i] = topics[i].replace("’","")
    topics[i] = topics[i].replace("—","")
    topics[i] = topics[i].replace(".","")
    topics[i] = topics[i].replace("(","")
    topics[i] = topics[i].replace(")","")
    topics[i] = topics[i].replace(" ","-")
    topics[i] = topics[i].lower()

# Load webpages
topic_pages = {}

if not path.exists(CACHE_DIR):
    print("Creating cache directory...")
    os.makedirs(CACHE_DIR)

for topic in topics:
    if (path.exists(CACHE_FILE.format(topic))):
        # Load cached page
        print(f"Found cache for {topic}")
        cached_file = open(CACHE_FILE.format(topic), "r", encoding="utf8")
        topic_pages[topic] = cached_file.read()
        cached_file.close()
    else:
        # Download gospel topic from church website
        print(f"Downloading page for {topic}...")
        page = urllib.request.urlopen(SOURCE_URL.format(topic))
        bytes = page.read()
        topic_pages[topic] = bytes.decode("utf8")
        page.close()
        # Cache file for next time
        cached_file = open(CACHE_FILE.format(topic), "w", encoding="utf8")
        cached_file.write(topic_pages[topic])
        cached_file.close()
        # Sleep to prevent spamming server
        print("Waiting...")
        time.sleep(PAUSE_TIME)