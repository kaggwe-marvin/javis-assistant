name: Create Development Branch On Repo Init

on:
  create:

jobs:
  setup-branches:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Checkout main branch
        uses: actions/checkout@v4

      - name: Set Git user identity
        run: |
          git config --global user.email "kiwanukamarvin597@gmail.com"
          git config --global user.name "saybaba"

      - name: Get branch names
        id: branch-names
        uses: tj-actions/branch-names@v8

      - name: Create development branch if it does not exist
        run: |
          if [[ "${{ steps.branch-names.outputs.current_branch }}" != "development" && ! git show-ref --verify --quiet refs/heads/development ]]; then
            git checkout -b development
            git push origin development:development
          else
            echo ":: Development branch already exists."
          fi

      - name: Checkout development branch
        run: git checkout development

      - name: Create feature branch from development branch
        run: git checkout -b feature/setup-branch development

      - name: Touch create_branch.sh and set permissions
        run: |
          touch create_branch.sh
          chmod +x create_branch.sh

      - name: Generate create_branch.sh content
        run: |
          cat <<'EOF' > create_branch.sh
          #!/bin/bash
          create_branch() {
            local branch_type=$1
            local branch_name=$2
            local full_branch_name="${branch_type}/${branch_name}"
            if [ "$DEVELOPMENT_EXISTS" != "true" ]; then
              echo ":: Development branch does not exist. Exiting."
              exit 1
            fi
            git checkout development
            git pull origin development
            git checkout -b "$full_branch_name"
            git push -u origin "$full_branch_name"
            echo ":: Branch $full_branch_name created and pushed to remote."
            }
            if [ "$#" -ne 2 ]; then
              echo ":: Usage: $0 [feature|bugfix|hotfix|release] <branch-name>"
              exit 1
            fi
            create_branch "$1" "$2"
          EOF

      - name: Set development branch existence environment variable
        run: |
          if git show-ref --verify --quiet refs/heads/development; then
            echo "DEVELOPMENT_EXISTS=true" >> $GITHUB_ENV
          else
            echo "DEVELOPMENT_EXISTS=false" >> $GITHUB_ENV
          fi

      - name: Commit and push feature branch
        run: |
          git add create_branch.sh
          git commit -m "Add create_branch.sh"
          git push origin feature/setup-branch
