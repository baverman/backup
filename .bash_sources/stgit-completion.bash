# -*- shell-script -*-
# bash completion script for StGit (automatically generated)
#
# To use these routines:
#
#    1. Copy this file to somewhere (e.g. ~/.stgit-completion.bash).
#
#    2. Add the following line to your .bashrc:
#         . ~/.stgit-completion.bash

# The path to .git, or empty if we're not in a repository.
_gitdir ()
{
    echo "$(git rev-parse --git-dir 2>/dev/null)"
}

# Name of the current branch, or empty if there isn't one.
_current_branch ()
{
    local b=$(git symbolic-ref HEAD 2>/dev/null)
    echo ${b#refs/heads/}
}

# List of all applied patches except the current patch.
_other_applied_patches ()
{
    local b=$(_current_branch)
    local g=$(_gitdir)
    test "$g" && cat "$g/patches/$b/applied" | grep -v "^$(tail -n 1 $g/patches/$b/applied 2> /dev/null)$"
}

_patch_range ()
{
    local patches="$1"
    local cur="$2"
    case "$cur" in
        *..*)
            local pfx="${cur%..*}.."
            cur="${cur#*..}"
            compgen -P "$pfx" -W "$patches" -- "$cur"
            ;;
        *)
            compgen -W "$patches" -- "$cur"
            ;;
    esac
}

_stg_branches ()
{
    local g=$(_gitdir)
    test "$g" && (cd $g/patches/ && echo *)
}

_all_branches ()
{
    local g=$(_gitdir)
    test "$g" && git show-ref | grep ' refs/heads/' | sed 's,.* refs/heads/,,'
}

_tags ()
{
    local g=$(_gitdir)
    test "$g" && git show-ref | grep ' refs/tags/' | sed 's,.* refs/tags/,,'
}

_remotes ()
{
    local g=$(_gitdir)
    test "$g" && git show-ref | grep ' refs/remotes/' | sed 's,.* refs/remotes/,,'
}

_applied_patches ()
{
    local g=$(_gitdir)
    test "$g" && cat "$g/patches/$(_current_branch)/applied"
}

_unapplied_patches ()
{
    local g=$(_gitdir)
    test "$g" && cat "$g/patches/$(_current_branch)/unapplied"
}

_hidden_patches ()
{
    local g=$(_gitdir)
    test "$g" && cat "$g/patches/$(_current_branch)/hidden"
}

_conflicting_files ()
{
    local g=$(_gitdir)
    test "$g" && git ls-files --unmerged | sed 's/.*\t//g' | sort -u
}

_dirty_files ()
{
    local g=$(_gitdir)
    test "$g" && git diff-index --name-only HEAD
}

_unknown_files ()
{
    local g=$(_gitdir)
    test "$g" && git ls-files --others --exclude-standard
}

_known_files ()
{
    local g=$(_gitdir)
    test "$g" && git ls-files
}

_stg_commands="branch clean clone commit delete diff edit export files float fold goto hide id import init log mail new next patches pick pop prev publish pull push rebase redo refresh rename repair reset series show sink squash sync top uncommit undo unhide"

_stg_branch ()
{
    local flags="--cleanup --clone --create --delete --description --force --help --list --merge --protect --rename --unprotect"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -d|--description) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_all_branches) $flags" -- "$cur")) ;;
    esac
}

_stg_clean ()
{
    local flags="--applied --help --unapplied"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_clone ()
{
    local flags="--help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -A directory -W "$flags" -- "$cur")) ;;
    esac
}

_stg_commit ()
{
    local flags="--all --help --number"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--number) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_delete ()
{
    local flags="--branch --help --spill --top"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_diff ()
{
    local flags="--diff-opts --help --range --stat"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -r|--range) COMPREPLY=($(compgen -W "$(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
        -O|--diff-opts) COMPREPLY=($(compgen -W "-M -C" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_dirty_files) $flags $(_known_files)" -- "$cur")) ;;
    esac
}

_stg_edit ()
{
    local flags="--ack --authdate --authemail --authname --author --diff --diff-opts --edit --file --help --message --save-template --set-tree --sign"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -m|--message) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -f|--file) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --save-template) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --author) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authname) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authemail) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authdate) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -O|--diff-opts) COMPREPLY=($(compgen -W "-M -C" -- "$cur")) ;;
        -t|--set-tree) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches) $flags" -- "$cur")) ;;
    esac
}

_stg_export ()
{
    local flags="--branch --diff-opts --dir --extension --help --numbered --patch --stdout --template"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -d|--dir) COMPREPLY=($(compgen -A directory -- "$cur")) ;;
        -e|--extension) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -t|--template) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        -O|--diff-opts) COMPREPLY=($(compgen -W "-M -C" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_files ()
{
    local flags="--bare --diff-opts --help --stat"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -O|--diff-opts) COMPREPLY=($(compgen -W "-M -C" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches) $flags" -- "$cur")) ;;
    esac
}

_stg_float ()
{
    local flags="--help --keep --series"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -s|--series) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_fold ()
{
    local flags="--base --help --reject --strip --threeway"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--base) COMPREPLY=($(compgen -W "$(_all_branches) $(_tags) $(_remotes)" -- "$cur")) ;;
        -p|--strip) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -A file -W "$flags" -- "$cur")) ;;
    esac
}

_stg_goto ()
{
    local flags="--help --keep --merged"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -W "$(_other_applied_patches) $flags $(_unapplied_patches)" -- "$cur")) ;;
    esac
}

_stg_hide ()
{
    local flags="--branch --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_id ()
{
    local flags="--help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -W "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches) $flags" -- "$cur")) ;;
    esac
}

_stg_import ()
{
    local flags="--ack --authdate --authemail --authname --author --base --edit --help --ignore --mail --mbox --name --reject --replace --series --showdiff --sign --strip --stripname --url"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--name) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -p|--strip) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -b|--base) COMPREPLY=($(compgen -W "$(_all_branches) $(_tags) $(_remotes)" -- "$cur")) ;;
        -a|--author) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authname) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authemail) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authdate) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -A file -W "$flags" -- "$cur")) ;;
    esac
}

_stg_init ()
{
    local flags="--help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_log ()
{
    local flags="--branch --clear --diff --full --graphical --help --number"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        -n|--number) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_mail ()
{
    local flags="--all --attach --auto --bcc --branch --cc --cover --diff-opts --edit-cover --edit-patches --git --help --in-reply-to --mbox --no-thread --prefix --sleep --smtp-password --smtp-server --smtp-tls --smtp-user --template --to --unrelated --version"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        --to) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --cc) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --bcc) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -v|--version) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --prefix) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -t|--template) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -c|--cover) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -s|--sleep) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --in-reply-to) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --smtp-server) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -u|--smtp-user) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -p|--smtp-password) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        -O|--diff-opts) COMPREPLY=($(compgen -W "-M -C" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_new ()
{
    local flags="--ack --authdate --authemail --authname --author --file --help --message --save-template --sign"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        --author) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authname) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authemail) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authdate) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -m|--message) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -f|--file) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --save-template) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_next ()
{
    local flags="--branch --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_patches ()
{
    local flags="--branch --diff --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_known_files)" -- "$cur")) ;;
    esac
}

_stg_pick ()
{
    local flags="--expose --file --fold --help --name --parent --ref-branch --revert --unapplied --update"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--name) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -B|--ref-branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        -p|--parent) COMPREPLY=($(compgen -W "$(_all_branches) $(_tags) $(_remotes)" -- "$cur")) ;;
        -f|--file) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_pop ()
{
    local flags="--all --help --keep --number"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--number) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_prev ()
{
    local flags="--branch --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_publish ()
{
    local flags="--ack --authdate --authemail --authname --author --branch --file --help --last --message --sign --unpublished"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        --author) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authname) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authemail) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authdate) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -m|--message) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -f|--file) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_all_branches) $flags" -- "$cur")) ;;
    esac
}

_stg_pull ()
{
    local flags="--help --merged --nopush"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -A directory -W "$flags" -- "$cur")) ;;
    esac
}

_stg_push ()
{
    local flags="--all --help --keep --merged --number --reverse --set-tree"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--number) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_patch_range "$(_unapplied_patches)" "$cur") $flags" -- "$cur")) ;;
    esac
}

_stg_rebase ()
{
    local flags="--help --merged --nopush"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -W "$flags $(_all_branches) $(_tags) $(_remotes)" -- "$cur")) ;;
    esac
}

_stg_redo ()
{
    local flags="--hard --help --number"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--number) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_refresh ()
{
    local flags="--ack --annotate --authdate --authemail --authname --author --edit --file --help --index --message --patch --sign --update"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -p|--patch) COMPREPLY=($(compgen -W "$(_other_applied_patches) $(_unapplied_patches)" -- "$cur")) ;;
        -a|--annotate) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -m|--message) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -f|--file) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --author) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authname) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authemail) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --authdate) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_dirty_files) $flags" -- "$cur")) ;;
    esac
}

_stg_rename ()
{
    local flags="--branch --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches) $flags" -- "$cur")) ;;
    esac
}

_stg_repair ()
{
    local flags="--help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_reset ()
{
    local flags="--hard --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_series ()
{
    local flags="--all --applied --author --branch --count --description --empty --help --hidden --missing --noprefix --short --showbranch --unapplied"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        -m|--missing) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_show ()
{
    local flags="--applied --branch --diff-opts --help --stat --unapplied"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        -O|--diff-opts) COMPREPLY=($(compgen -W "-M -C" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_hidden_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_sink ()
{
    local flags="--help --keep --nopush --to"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -t|--to) COMPREPLY=($(compgen -W "$(_applied_patches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_squash ()
{
    local flags="--file --help --message --name --save-template"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--name) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -m|--message) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -f|--file) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        --save-template) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_sync ()
{
    local flags="--all --help --ref-branch --series"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -B|--ref-branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        -s|--series) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags $(_patch_range "$(_unapplied_patches) $(_applied_patches)" "$cur")" -- "$cur")) ;;
    esac
}

_stg_top ()
{
    local flags="--branch --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_uncommit ()
{
    local flags="--exclusive --help --number --to"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--number) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        -t|--to) COMPREPLY=($(compgen -W "$(_all_branches) $(_tags) $(_remotes)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_undo ()
{
    local flags="--hard --help --number"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -n|--number) COMPREPLY=($(compgen -A file -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$flags" -- "$cur")) ;;
    esac
}

_stg_unhide ()
{
    local flags="--branch --help"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    case "$prev" in
        -b|--branch) COMPREPLY=($(compgen -W "$(_stg_branches)" -- "$cur")) ;;
        *) COMPREPLY=($(compgen -W "$(_patch_range "$(_hidden_patches)" "$cur") $flags" -- "$cur")) ;;
    esac
}

_stg ()
{
    local i
    local c=1
    local command

    while test $c -lt $COMP_CWORD; do
        if test $c == 1; then
            command="${COMP_WORDS[c]}"
        fi
        c=$((++c))
    done

    # Complete name of subcommand if the user has not finished typing it yet.
    if test $c -eq $COMP_CWORD -a -z "$command"; then
        COMPREPLY=($(compgen -W "help version copyright $_stg_commands" -- "${COMP_WORDS[COMP_CWORD]}"))
        return
    fi

    # Complete arguments to subcommands.
    case "$command" in
        help)
            COMPREPLY=($(compgen -W "$_stg_commands" -- "${COMP_WORDS[COMP_CWORD]}"))
            return ;;
        version) return ;;
        copyright) return ;;
        branch) _stg_branch ;;
        clean) _stg_clean ;;
        clone) _stg_clone ;;
        commit) _stg_commit ;;
        delete) _stg_delete ;;
        diff) _stg_diff ;;
        edit) _stg_edit ;;
        export) _stg_export ;;
        files) _stg_files ;;
        float) _stg_float ;;
        fold) _stg_fold ;;
        goto) _stg_goto ;;
        hide) _stg_hide ;;
        id) _stg_id ;;
        import) _stg_import ;;
        init) _stg_init ;;
        log) _stg_log ;;
        mail) _stg_mail ;;
        new) _stg_new ;;
        next) _stg_next ;;
        patches) _stg_patches ;;
        pick) _stg_pick ;;
        pop) _stg_pop ;;
        prev) _stg_prev ;;
        publish) _stg_publish ;;
        pull) _stg_pull ;;
        push) _stg_push ;;
        rebase) _stg_rebase ;;
        redo) _stg_redo ;;
        refresh) _stg_refresh ;;
        rename) _stg_rename ;;
        repair) _stg_repair ;;
        reset) _stg_reset ;;
        series) _stg_series ;;
        show) _stg_show ;;
        sink) _stg_sink ;;
        squash) _stg_squash ;;
        sync) _stg_sync ;;
        top) _stg_top ;;
        uncommit) _stg_uncommit ;;
        undo) _stg_undo ;;
        unhide) _stg_unhide ;;
    esac
}

complete -o bashdefault -o default -F _stg stg 2>/dev/null \
    || complete -o default -F _stg stg
