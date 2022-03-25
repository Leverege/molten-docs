#./bin/sh
mkdocs build && firebase deploy --only hosting:dev-molten-docs
