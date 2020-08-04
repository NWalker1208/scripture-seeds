import urllib.request

TOPICS_FILE = ""
SOURCE_URL = "https://www.churchofjesuschrist.org/study/manual/gospel-topics/{:}?lang=eng"
# Use SOURCE_URL.format('topic_name')

# Load topic list
topics_file = open("Assets/topics.txt","r", encoding="utf8")
topics = topics_file.readlines()
topics_file.close()

for i in range(len(topics)):
    topics[i] = topics[i].replace("\n","").replace(" ","-").lower()

# Load webpage
fp = urllib.request.urlopen(SOURCE_URL.format(topics[0]))
mybytes = fp.read()

mystr = mybytes.decode("utf8")
fp.close()

print(mystr)