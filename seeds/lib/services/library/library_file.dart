import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeds/services/library/library_xml.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart';

class LibraryFileManager {
  static final String _webStorageURL = 'https://firebasestorage.googleapis.com/v0/b/scripture-seeds.appspot.com/o/';

  final String lang;
  final AssetBundle assets;
  final int daysBetweenRefresh;
  final String _libFileName;

  Library library;

  LibraryFileManager(
    this.library, {
      this.assets,
      this.daysBetweenRefresh = 2,
      this.lang = 'eng'
    }
   ) : _libFileName = 'library_$lang.xml';


  // Initialize library from cache, assets, and/or web.
  Future<void> initializeLibrary() async {
    // Load from cache or assets if necessary
    XmlDocument libDoc = await _loadFromCache() ?? await _loadFromAssets();

    if (libDoc != null)
      library.loadFromXml(libDoc);

    // If not cache is present, or if cache is 48 hours old, download from web
    if (await _shouldRefreshCache())
      await refreshLibrary();
  }

  // Attempt to refresh library from web.
  Future<void> refreshLibrary() async {
    XmlDocument libDoc = await _loadFromWeb();

    if (libDoc != null)
      library.loadFromXml(libDoc);
  }


  // Gets cache file
  Future<File> _getCacheFile() async {
    Directory tempDirectory = await getTemporaryDirectory();
    return File(tempDirectory.path + '/lib_cache/$_libFileName');
  }

  // Returns true if no cache is present or if cache is over daysBetweenRefresh days old
  Future<bool> _shouldRefreshCache() async {
    File cache = await _getCacheFile();

    if (await cache.exists()) {
      DateTime lastRefresh = await cache.lastModified();
      return DateTime.now().difference(lastRefresh).inDays >= daysBetweenRefresh;
    }

    return true;
  }


  // Loads library file from assets
  Future<XmlDocument> _loadFromAssets() async {
    print('Loading library from assets...');
    if (assets != null) {
      try {
        return parse(await assets.loadString('assets/$_libFileName'));
      }
      on Exception {
        print('Could not find library asset for $lang');
      }
    }

    return null;
  }

  // Loads library file from cache
  Future<XmlDocument> _loadFromCache() async {
    File cache = await _getCacheFile();
    if (await cache.exists()) {
      print('Loading library from cache...');
      return parse(await cache.readAsString());
    }

    return null;
  }

  // Loads library file from web and saves to cache
  Future<XmlDocument> _loadFromWeb() async {
    Uri url = Uri.parse('$_webStorageURL$_libFileName?alt=media');
    String xml = await _download(url);
    if (xml != null) {
      print('Loading library from web...');
      File cache = await _getCacheFile();
      cache.writeAsString(xml);
      return parse(xml);
    }

    return null;
  }


  // Downloads the given file as a String
  static Future<String> _download(Uri url) async {
    Response response = await get(url);
    if (response.statusCode == 200)
      return response.body;

    return null;
  }
}