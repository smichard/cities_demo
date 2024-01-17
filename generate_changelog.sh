#!/bin/sh

# Exit on error
set -e

# Path to the Git repository (current directory)
REPO_DIR="."
CHANGELOG_FILE="$REPO_DIR/CHANGELOG.md"
TEMP_CHANGELOG_FILE="$REPO_DIR/temp_changelog.md"
GITHUB_REPO_URL="https://github.com/smichard/cities_demo" # Replace with your repository URL

# Go to the repository directory
cd $REPO_DIR

# Fetch the latest changes
git fetch --tags

# Get tags in reverse order
TAGS=$(git tag --sort=-v:refname)

# Placeholder for the previous tag
PREV_TAG=HEAD

# Create or clear the temporary changelog file
echo "" > $TEMP_CHANGELOG_FILE

# Collect and list unreleased changes
echo "## Unreleased Changes" >> $TEMP_CHANGELOG_FILE
echo "" >> $TEMP_CHANGELOG_FILE
UNRELEASED_COMMITS=$(git log $(git describe --tags --abbrev=0)..HEAD --oneline)
if [ ! -z "$UNRELEASED_COMMITS" ]; then
    echo "$UNRELEASED_COMMITS" | while read -r COMMIT; do
        HASH=$(echo $COMMIT | awk '{print $1}')
        MESSAGE=$(echo $COMMIT | sed -E 's/^[^:]+(\([^)]+\))?: //')
        echo "- $MESSAGE [\`$HASH\`]($GITHUB_REPO_URL/commit/$HASH)" >> $TEMP_CHANGELOG_FILE
    done
    echo "" >> $TEMP_CHANGELOG_FILE
fi

# Iterate over tags
for TAG in $TAGS; do
    TAG_DATE=$(git log -1 --format=%ai $TAG | cut -d ' ' -f 1)
    echo "## $TAG ($TAG_DATE)" >> $TEMP_CHANGELOG_FILE
    echo "" >> $TEMP_CHANGELOG_FILE

    # Define categories
    CATEGORIES="feat fix ci perf docs gitops test demo build chore style refactor"

    # Collect all commits for this tag range
    ALL_COMMITS=$(git log $TAG..$PREV_TAG --oneline)

    for KEY in $CATEGORIES; do
        CATEGORY_COMMITS=$(echo "$ALL_COMMITS" | grep -E "$KEY(\(.*\))?:")
        if [ ! -z "$CATEGORY_COMMITS" ]; then
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
            echo "### $CATEGORY_NAME" >> $TEMP_CHANGELOG_FILE
            echo "$CATEGORY_COMMITS" | while read -r COMMIT; do
                HASH=$(echo $COMMIT | awk '{print $1}')
                MESSAGE=$(echo $COMMIT | sed -E "s/^$HASH $KEY(\(.*\))?: //")
                echo "- $MESSAGE [\`$HASH\`]($GITHUB_REPO_URL/commit/$HASH)" >> $TEMP_CHANGELOG_FILE
            done
            echo "" >> $TEMP_CHANGELOG_FILE
        fi
    done

    # Update the previous tag
    PREV_TAG=$TAG
done

# Add existing changelog to the end of the new log
cat $CHANGELOG_FILE >> $TEMP_CHANGELOG_FILE

# Replace the old changelog with the new one
mv $TEMP_CHANGELOG_FILE $CHANGELOG_FILE
