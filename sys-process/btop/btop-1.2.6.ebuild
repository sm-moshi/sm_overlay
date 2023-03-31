# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A monitor of resources"
HOMEPAGE="https://github.com/aristocratos/btop"
SRC_URI="https://github.com/aristocratos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	>=sys-devel/gcc-10
"

src_prepare() {
	default
	# btop installs README.md to /usr/share/btop by default
	sed -i 's/^.*cp -p README.md.*$//' Makefile
}

src_compile() {
	# Disable btop optimization flags, since we have our flags in CXXFLAGS
	emake \
		CXX="$(tc-getCXX)" \
		OPTFLAGS="${CXXFLAGS}" \
		ADDFLAGS="${LDFLAGS}"
}

src_install() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		DESTDIR="${D}" \
		install

	DOCS=(*.md)
	einstalldocs
	rm -f "${D}/${EPREFIX}/usr/share/btop/README.md"
}