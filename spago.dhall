{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "dhall-gui"
, dependencies =
  [ "effect", "console", "psci-support", "parsing", "spec", "stringutils" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
