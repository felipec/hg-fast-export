#!/bin/bash
#
# Copyright (c) 2023 Felipe Contreras
#

# shellcheck disable=SC2034
test_description='Main tests'

# shellcheck source=/dev/null
. "${SHARNESS_TEST_SRCDIR-/usr/share/sharness}"/sharness.sh

check() {
	echo "$3" > expected &&
	git -C "$1" show -q --format='%s' "$2" > actual &&
	test_cmp expected actual
}

git_clone() {
	(
	git init -q "$2" &&
	fast-export "$1" | git -C "$2" fast-import --quiet
	)
}

setup() {
	cat > "$HOME"/.hgrc <<-EOF
	[ui]
	username = H G Wells <wells@example.com>
	EOF

	export HGMERGE=true
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

author() {
	echo bump >> content &&
	hg commit -u "$1" -m "add with $1"
}

test_expect_success 'authors' '
	test_when_finished "rm -rf hgrepo gitrepo" &&

	(
	hg init hgrepo &&
	cd hgrepo &&

	touch content &&
	hg add content &&

	author "Alpha <alpha@sane.com>" &&
	author "beta@example.com" &&
	author "gamma" &&
	author "Delta <test@example.com" &&
	author "Epsilon <non@sense.com <mailto:non@sense.com>>"
	) &&

	git_clone hgrepo gitrepo
'

test_expect_success 'merge' '
	test_when_finished "rm -rf hgrepo gitrepo" &&

	(
	hg init hgrepo &&
	cd hgrepo &&
	echo a > content &&
	echo a > file1 &&
	hg add content file1 &&
	hg commit -m "origin" &&

	echo b > content &&
	echo b > file2 &&
	hg add file2 &&
	hg rm file1 &&
	hg commit -m "right" &&

	hg update -r0 &&
	echo c > content &&
	hg commit -m "left" &&

	hg merge -r1 &&
	echo c > content &&
	hg resolve -m content &&
	hg commit -m "merge"
	) &&

	git_clone hgrepo gitrepo &&

	cat > expected <<-EOF &&
	left
	c
	tree @:

	content
	file2
	EOF

	(
	cd gitrepo
	git show -q --format='%s' @^ &&
	git show @:content &&
	git show @:
	) > actual &&

	test_cmp expected actual
'

test_done
