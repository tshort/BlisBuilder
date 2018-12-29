using BinaryBuilder

name = "BlisBuilder"
version = v"0.5.1"

ENV["BINARYBUILDER_USE_CCACHE"] = "false"

sources = [
    # "https://github.com/flame/blis/archive/0.3.0.tar.gz" =>
    # "d34d17df7bdc2be8771fe0b7f867109fd10437ac91e2a29000a4a23164c7f0da",
    "https://github.com/flame/blis/archive/0.5.1.tar.gz" =>
    "7816a1f6085b1d779f074bca2435c195c524582edbb04d9cd399dade9187a72d",
]

script = raw"""
cd $WORKSPACE/srcdir
mv blis* blis
cd $WORKSPACE/srcdir/blis

./configure -p $prefix generic

if [[ ${target} == wasm32-* ]]; then
    apk add nodejs
    emcc -v
    make -j${nproc} CC_VENDOR=clang
    make install CC_VENDOR=clang
else 
    make -j${nproc}
    make install
fi

"""

# We attempt to build for all defined platforms
platforms = [
    BinaryProvider.WebAssembly(),
#    BinaryProvider.Linux(:x86_64, :glibc),
#    BinaryProvider.Windows(:x86_64),
#    BinaryProvider.Windows(:i686),
#    BinaryProvider.MacOS(),
#    BinaryProvider.Linux(:i686, :glibc),
#    BinaryProvider.Linux(:aarch64, :glibc),
#    BinaryProvider.Linux(:armv7l, :glibc),
#    BinaryProvider.Linux(:powerpc64le, :glibc),
]


products(prefix) = [
    LibraryProduct(prefix, "libblis", :libblis),
]

dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(["--verbose", "--debug"], name, version, sources, script, platforms, products, dependencies)
