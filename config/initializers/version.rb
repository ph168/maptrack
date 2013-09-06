class Version
  Number = `git describe --always --tags`.split("-", 2)[0]
  Revision = `git show --pretty=oneline`.split(" ", 2)[0]
end
