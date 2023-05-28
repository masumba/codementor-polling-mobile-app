class ResourceMissingException implements Exception {
  String cause;
  ResourceMissingException(this.cause);
}
