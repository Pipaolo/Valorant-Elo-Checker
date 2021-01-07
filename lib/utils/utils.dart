String parseAccessToken(String rawAccessToken) {
  return RegExp("access_token=(.+?)&scope=")
      .stringMatch(rawAccessToken)
      .split("=")[1]
      .split("&")[0];
}
