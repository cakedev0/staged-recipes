#!/bin/bash
set -ex

# Use the host Python when cross-compiling: extend the meson cross file created
# by the compiler activation scripts, whose [binaries] section is last.
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
    echo "python = '${PREFIX}/bin/python'" >> "${BUILD_PREFIX}/meson_cross_file.txt"
fi

# meson-python already passes -Dbuildtype=release.
MESON_ARGS_REDUCED="$(echo $MESON_ARGS | sed 's/--buildtype release //g')"

$PYTHON -m pip install . -vv --no-deps --no-build-isolation \
    -Cbuilddir=builddir \
    -Csetup-args=${MESON_ARGS_REDUCED// / -Csetup-args=} \
    || (cat builddir/meson-logs/meson-log.txt && exit 1)
