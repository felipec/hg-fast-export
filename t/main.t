#!/bin/bash
#
# Copyright (c) 2023 Felipe Contreras
#

# shellcheck disable=SC2034
test_description='Main tests'

# shellcheck source=/dev/null
. /usr/share/sharness/sharness.sh

check() {
	echo "$3" > expected &&
	git -C "$1" show -q --format='%s' "$2" > actual &&
	test_cmp expected actual
}

git_clone() {
	(
	git init -q "$2" &&
	fast-export "$1" | git -C "$2" fast-import --quiet &&
	git -C "$2" reset --hard
	)
}

setup() {
	cat > "$HOME"/.hgrc <<-EOF
	[ui]
	username = H G Wells <wells@example.com>
	EOF
}

setup

test_expect_success 'basic' '
	test_when_finished "rm -rf hgrepo gitrepo" &&

	(
	hg init hgrepo &&
	cd hgrepo &&
	echo zero > content &&
	hg add content &&
	hg commit -m zero
	) &&

	git_clone hgrepo gitrepo &&
	check gitrepo @ zero
'

test_done
