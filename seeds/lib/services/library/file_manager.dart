import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeds/services/library/library.dart';
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
   ) : _libFileName = 'library_$lang';


  // Initialize library from cache, assets, and/or web.
  Future<void> initializeLibrary() async {
    print('Initializing library...');
    bool successful = false;

    // Load from cache and assets
    XmlElement cacheLibrary = (await _loadFromCache())?.rootElement;
    XmlElement assetLibrary = (await _loadFromAssets())?.rootElement;

    // Use whichever library is newer
    if (Library.versionOfXml(assetLibrary) > Library.versionOfXml(cacheLibrary)) {
      // Delete cache if old
      if (cacheLibrary != null) {
        print('Deleting old cache.');
        (await _getCacheFile()).delete();
      }

      successful = library.loadFromXml(assetLibrary);
    }

    if (!successful && cacheLibrary != null) {
      successful = library.loadFromXml(cacheLibrary);
    }

    // If no cache is present, or if cache is over 48 hours old, download from web
    if (!successful || await _shouldRefreshCache()) {
      print('Automatically refreshing library...');
      await refreshLibrary();
    }
  }

  // Attempt to refresh library from web.
  Future<void> refreshLibrary() async {
    XmlDocument libDoc = await _loadFromWeb();

    if (libDoc != null) {
      if (library.loadFromXml(libDoc.rootElement))
        _updateCacheFromDownload();
    }
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
      try {
        return XmlDocument.parse(await cache.readAsString());
      } on XmlParserException catch (e) {
        print('Parsing of library XML from cache failed: $e');
        print('Deleting library cache...');
        cache.delete();
      }
    }
    else
      print('No library cache exists.');

    return null;
  }

  // Loads library file from web and saves to cache
  Future<XmlDocument> _loadFromWeb() async {
    File libFile = await _downloadLibrary();

    if (libFile != null) {
      print('Loading library from web download...');

      try {
        return XmlDocument.parse(await libFile.readAsString());
      } on XmlParserException catch (e) {
        print('Parsing of library XML from web failed: $e');
      }
    }
    else
      print('Unable to download library from web.');

    return null;
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