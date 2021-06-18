# modify PS1 to your preference and include this file in your bashrc
# or copy to /etc/bash_completions.d.
function __prompt_stgit()
{
	local top;
	top=$(stg top 2>/dev/null)
	[ -z "$top" ] || echo -n "($top)"
}
