enum NavigationRoute {
  home("/home"),
  detail("/detail"),
  login("/login"),
  register("/register");

  final String name;

  const NavigationRoute(this.name);
}
