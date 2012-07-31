# modify PS1 to your preference and include this file in your bashrc
# or copy to /etc/bash_completions.d.
function __prompt_stgit()
{
	local git_dir ref br top;
	git_dir=$(git rev-parse --git-dir 2> /dev/null) || return
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	br=${ref#refs/heads/}
	top=$(tail -n 1 $git_dir/patches/$br/applied 2>/dev/null)
	[ -z "$top" ] || echo -n "($top)"
}
