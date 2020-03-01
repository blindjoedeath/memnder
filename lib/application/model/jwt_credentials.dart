

class JwtCredentials{
  final String username;
  final String password;
  final String accessToken;
  final String refreshToken;

  JwtCredentials(
    {
      this.username,
      this.password,
      this.accessToken,
      this.refreshToken
    }
  );
}