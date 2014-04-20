part of ccompilers.ccompilers;

class _FileUtils {
  static String correctPathSeparators(String path) {
    var to = Platform.pathSeparator;
    var from = to == '\\' ? '/' : '\\';

    if (path != null && path is String) {
      path = path.replaceAll(from, to);
    }

    return path;
  }

  static int readAsListSync(RandomAccessFile fp, List<int> buffer, int position)
      {
    fp.setPositionSync(position);
    if (fp.positionSync() != position) {
      return 0;
    }

    return fp.readIntoSync(buffer, 0, buffer.length);
  }
}
