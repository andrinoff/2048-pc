OWNER := "andrinoff"
# The name of your repository
REPO := "2048-pc"
RELEASE_DIR := "./dist"
# The git tag for this release (e.g., v1.0.0). It will be created if it doesn't exist.
# You can override this from the command line, e.g., `make release TAG=v1.0.1`
TAG := "v1.0.0"


release: check_gh check_tag create_release upload_assets
	@echo "✅ Successfully created release $(TAG) and uploaded assets."
create_release:
	@echo "Creating GitHub release for tag $(TAG)..."
	@gh release create $(TAG) --repo $(OWNER)/$(REPO) --title "Release $(TAG)" --notes "Released on $(shell date)"

# Finds all files in the RELEASE_DIR and uploads them to the release
upload_assets:
	@echo "Uploading assets from $(RELEASE_DIR)..."
	@gh release upload $(TAG) $(RELEASE_DIR)/* --repo $(OWNER)/$(REPO)

# Checks if the gh cli is installed
check_gh:
	@command -v gh >/dev/null 2>&1 || { echo "❌ 'gh' (GitHub CLI) not found. Please install it from https://cli.github.com/"; exit 1; }

# Checks if the git tag already exists locally
check_tag:
	@git rev-parse $(TAG) >/dev/null 2>&1 || { echo "ℹ️ Note: Git tag '$(TAG)' does not exist. It will be created by the release command."; }

# A 'clean' target is good practice
clean:
	@echo "Cleaning up release directory..."
	@rm -rf $(RELEASE_DIR)

# Help target to show how to use the Makefile
help:
	@echo "Makefile for GitHub Releases"
	@echo "----------------------------"
	@echo "Usage:"
	@echo "  make release       - Creates a release and uploads assets from $(RELEASE_DIR)."
	@echo "                     - Uses the default TAG: $(TAG)."
	@echo "  make release TAG=vX.Y.Z - Creates a release with a specific tag."
	@echo "  make clean         - Removes the $(RELEASE_DIR) directory."
	@echo "  make help          - Shows this help message."

.PHONY: release create_release upload_assets check_gh check_tag clean help
