#!/bin/bash

# Prompt user for input
echo "Enter commit type (e.g., feat, fix, docs, style, refactor, perf, test, chore):"
read type

echo "Enter optional scope (e.g., component or file name) or leave blank:"
read scope

echo "Enter a brief description of the change (imperative mood, max 50 chars):"
read description

echo "Enter a detailed description of the change. Press Enter to skip."
echo "Detailed description: "
read body

# Construct the commit message
if [ -z "$scope" ]; then
    commit_message="$type: $description"
else
    commit_message="$type($scope): $description"
fi

# Add body if provided
if [ ! -z "$body" ]; then
    commit_message="$commit_message\n\n$body"
fi

# Confirm the commit message
echo -e "\nYour commit message is:\n$commit_message"
echo -e "\nDo you want to proceed with this commit? (y/n)"
read confirm

if [ "$confirm" = "y" ]; then
    # Stage all changes
    git add -A

    # Make the commit
    git commit -m "$commit_message"
    echo "Commit has been made."
else
    echo "Commit has been canceled."
fi
