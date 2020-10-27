import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeds/services/library/library.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart';

class LibraryManager extends ChangeNotifier {
  static final String _webStorageURL = 'https://firebasestorage.googleapis.com/v0/b/scripture-seeds.appspot.com/o/';

  final String lang;
  final AssetBundle assets;
  final int daysBetweenRefresh;
  final String _libFileName;

  Library library;

  LibraryManager({
    this.assets,
    this.daysBetweenRefresh = 2,
    this.lang = 'eng'
  }) : _libFileName = 'library_$lang' {
    _loadLibrary().then((library) async {
      // Update library and notify listeners
      if (library != null) {
        this.library = library;
        notifyListeners();
      }

      // If library was unable to load, or if cache is over 48 hours old, download from web
      if (library == null || await _shouldRefreshCache())
        refreshLibrary();
    });
  }

  // Attempt to refresh library from web.
  Future<void> refreshLibrary() async {
    print('Refreshing library...');
    Library newLibrary = Library.fromXmlElement((await _loadFromWeb())?.rootElement);

    if (newLibrary == null) return;

    if (newLibrary.version > (library?.version ?? -1)) {
      library = newLibrary;
      notifyListeners();
      _updateCacheFromDownload();
    } else
      print('Web library is outdated.');
  }

  /// Cache Management Functions
  // Gets cache file
  Future<File> _getCacheFile({bool newDownload = false}) async {
    Directory tempDirectory = await getTemporaryDirectory();
    return File(tempDirectory.path + '/lib_cache/$_libFileName' +
                (newDownload ? '_new' : '') + '.xml');
  }

  // Swaps new cache file for old cache file
  Future<void> _updateCacheFromDownload() async {
    File newCache = await _getCacheFile(newDownload: true);
    File oldCache = await _getCacheFile();

    if (await newCache.exists()) {
      print('Saving library to cache...');

      if (await oldCache.exists())
        await oldCache.delete();

      await newCache.rename(oldCache.path);
    }
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

  /// XML Loading Functions
  // Initialize library from cache and assets
  Future<Library> _loadLibrary() async {
    print('Loading local library...');

    // Load from cache and assets
    List<Library> libs = await Future.wait([
      _loadFromCache().then(
              (libDoc) => Library.fromXmlElement(libDoc?.rootElement)
      ),
      _loadFromAssets().then(
              (libDoc) => Library.fromXmlElement(libDoc?.rootElement)
      )
    ]);

    Library cacheLibrary = libs[0];
    Library assetsLibrary = libs[1];

    // If cache is older than asset, return asset
    if ((assetsLibrary?.version ?? -1) > (cacheLibrary?.version ?? -1)) {
      // Delete cache
      _getCacheFile().then((cache) {
        if (cache.existsSync()){
          print('Cache is outdated. Deleting old cache...');
          cache.delete();
        }
      });

      return assetsLibrary;
    }

    // Otherwise, cache is newer, so use cache
    return cacheLibrary;
  }

  // Loads library file from assets
  Future<XmlDocument> _loadFromAssets() async {
    if (assets != null) {
      print('Loading library from assets...');
      try {
        return XmlDocument.parse(await assets.loadString('assets/$_libFileName.xml'));
      } on FlutterError {
        print('Could not find library asset for language "$lang"');
      } on XmlParserException catch (e) {
        print('Parsing of library XML from assets failed: $e');
      }
    }
    else
      print('No assets provided to library file manager.');

    return null;
  }

  // Loads library file from cache
  Future<XmlDocument> _loadFromCache() async {
    File cache = await _getCacheFile();

    if (await cache.exists()) {
      print('Loading library from cache...');
      return _loadFromFile(cache).then((libDoc) {
        // Delete cache if XML parsing failed
        if (libDoc == null) {
          print('Deleting library cache...');
          cache.delete();
        }
        return libDoc;
      });
    } else {
      print('No library cache exists.');
      return null;
    }
  }

  // Loads library file from web and saves to cache
  Future<XmlDocument> _loadFromWeb() async {
    File libFile = await _downloadLibrary();

    if (libFile != null) {
      print('Loading library from web download...');
      return _loadFromFile(libFile);
    } else {
      print('Unable to download library from web.');
      return null;
    }
  }

  // Parses library from XML file
  Future<XmlDocument> _loadFromFile(File file) async {
    try {
      return XmlDocument.parse(await file.readAsString());
    } on XmlParserException catch (e) {
      print('Exception while parsing library XML: $e');
      return null;
    }
  }

  /// Download Function
  // Downloads the library and saves to the cache
  Future<File> _downloadLibrary() async {
    Uri url = Uri.parse('$_webStorageURL$_libFileName.xml?alt=media');

    print('Downloading library from "$url"...');
    Response response = await get(url);
    if (response.statusCode == 200) {
      File cache = await _getCacheFile(newDownload: true);
      if (!await cache.exists())
        await cache.create(recursive: true);
      await cache.writeAsBytes(response.bodyBytes);

      return cache;
    }

    print('Download failed with code ${response.statusCode}');
    return null;
  }
}