#/bin/bash

# http://stackoverflow.com/questions/454734/how-can-one-change-the-timestamp-of-an-old-commit-in-git
rewrite_commit_date () {
    local commit="$1" date_timestamp="$2"
    local date temp_branch="temp-rebasing-branch"
    local current_branch="$(git rev-parse --abbrev-ref HEAD)"

    if [[ -z "$commit" ]]; then
        date="$(date -R)"
    else
        date="$(date -R --date "@$date_timestamp")"
    fi

    git checkout -b "$temp_branch" "$commit"
    GIT_COMMITTER_DATE="$date" git commit --amend --date "$date"
    git checkout "$current_branch"
    git rebase "$commit" --onto "$temp_branch"
    git branch -d "$temp_branch"
}