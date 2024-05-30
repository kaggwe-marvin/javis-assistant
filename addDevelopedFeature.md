name: Create Pull Request and Merge to Development

on:
  push:
    branches:
      - feature/**

jobs:
  create-pr:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Make changes to pull request
        run: echo "Making some changes" > changes.txt
        
      - name: Create Pull Request
        id: cpr
        uses: peter-evans/create-pull-request@v6
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          title: 'Automated PR from feature branch'
          body: 'Automatic code review and merge to development branch'
          head: feature/${{ github.ref_name }}
          base: development
          commit-message: |
            [create-pull-request] automated change

            This commit was created by the GitHub Action

      - name: Code review
        uses: actions/code-review@v4
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          pull-request-number: ${{ steps.cpr.outputs.pull-request-number }}
        
      - name: Merge pull request
        uses: actions/merge-pull-request@v4
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          pull-request-number: ${{ steps.cpr.outputs.pull-request-number }}
        
      - name: Delete feature branch
        uses: actions/delete-branch@v4
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          branch: feature/${{ github.ref_name }}
