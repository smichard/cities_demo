#!/bin/sh

# Exit on error
set -e

# Error handling
trap 'echo "An error occurred at line $LINENO. Exiting."' ERR

# Path to the Git repository (current directory)
REPO_DIR="."
CHANGELOG_FILE="$REPO_DIR/CHANGELOG_new.md"
GITHUB_REPO_URL="https://github.com/smichard/cities_demo" # Replace with your repository URL

echo "Starting changelog generation script..."

# Go to the repository directory
cd $REPO_DIR

# Fetch the latest changes
git fetch --tags
echo "Fetched latest tags."

# Get tags in reverse order
TAGS=$(git tag --sort=-v:refname)

# Check if there are any tags
if [ -z "$TAGS" ]; then
    echo "No tags found in the repository."
    exit 1
fi

echo "Found tags: $TAGS"

# Placeholder for the previous tag
PREV_TAG=HEAD

# Create or clear the changelog file
echo "" > $CHANGELOG_FILE

# Collect and list unreleased changes
echo "## Unreleased Changes" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE
echo "Processing unreleased changes..."
UNRELEASED_COMMITS=$(git log $(git describe --tags --abbrev=0)..HEAD --oneline)
if [ ! -z "$UNRELEASED_COMMITS" ]; then
    echo "$UNRELEASED_COMMITS" | while read -r COMMIT; do
        HASH=$(echo $COMMIT | awk '{print $1}')
        MESSAGE=$(echo $COMMIT | sed -E 's/^[^:]+(\([^)]+\))?: //')
        echo "- $MESSAGE [\`$HASH\`]($GITHUB_REPO_URL/commit/$HASH)" >> $CHANGELOG_FILE
    done
    echo "" >> $CHANGELOG_FILE
fi

# Define categories
CATEGORIES="feat fix ci perf docs gitops deploy test demo build chore style refactor"

# Iterate over tags
for TAG in $TAGS; do
    echo "Processing tag: $TAG"
    TAG_DATE=$(git log -1 --format=%ai $TAG | cut -d ' ' -f 1)
    echo "## $TAG ($TAG_DATE)" >> $CHANGELOG_FILE
    echo "" >> $CHANGELOG_FILE

    # Collect all commits for this tag range
    echo "Collecting commits for tag $TAG..."
    ALL_COMMITS=$(git log $TAG..$PREV_TAG --oneline)

    for KEY in $CATEGORIES; do
        echo "Starting category: $KEY for tag $TAG"
        CATEGORY_COMMITS=$(echo "$ALL_COMMITS" | grep -E "^.* $KEY(\(.*\))?: " || echo "No commits for this category")
        echo "Commits for category $KEY: $CATEGORY_COMMITS"
        if [ "$CATEGORY_COMMITS" != "No commits for this category" ]; then
            case $KEY in
                "feat") CATEGORY_NAME="Feature" ;;
                "fix") CATEGORY_NAME="Bug Fixes" ;;
                "ci") CATEGORY_NAME="Continuous Integration" ;;
                "perf") CATEGORY_NAME="Performance Improvements" ;;
                "docs") CATEGORY_NAME="Documentation" ;;
                "gitops") CATEGORY_NAME="GitOps" ;;
                "deploy") CATEGORY_NAME="Deployment" ;;
                "test") CATEGORY_NAME="Test" ;;
                "demo") CATEGORY_NAME="Demo" ;;
                "build") CATEGORY_NAME="Build" ;;
                "chore") CATEGORY_NAME="Chore" ;;
                "style") CATEGORY_NAME="Style" ;;
                "refactor") CATEGORY_NAME="Refactor" ;;
            esac
            echo "### $CATEGORY_NAME" >> $CHANGELOG_FILE
            echo "Listing commits for category: $CATEGORY_NAME under tag $TAG"
            echo "$CATEGORY_COMMITS" | while read -r COMMIT; do
                HASH=$(echo $COMMIT | awk '{print $1}')
                MESSAGE=$(echo $COMMIT | sed -E "s/^$HASH $KEY(\(.*\))?: //")
                echo "- $MESSAGE [\`$HASH\`]($GITHUB_REPO_URL/commit/$HASH)" >> $CHANGELOG_FILE
            done
            echo "" >> $CHANGELOG_FILE
        else
            echo "No commits found for category $KEY under tag $TAG"
        fi
        echo "Completed category: $KEY for tag $TAG"
    done

    echo "Completed processing tag: $TAG"
    # Update the previous tag
    PREV_TAG=$TAG
done

echo "Changelog generation complete."