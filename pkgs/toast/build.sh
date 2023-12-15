
set -e
set -x

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*darwin.* ]]; then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
    # export LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,-dead_strip_dylibs//g")
else
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

if [[ ${DEBUG_C} == yes ]]; then
    CMAKE_BUILD_TYPE=Debug
else
    CMAKE_BUILD_TYPE=Release
fi

export TOAST_BUILD_CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
export TOAST_BUILD_CMAKE_PLATFORM_FLAGS=${CMAKE_PLATFORM_FLAGS}
export TOAST_BUILD_CMAKE_C_COMPILER="${CC}"
export TOAST_BUILD_CMAKE_CXX_COMPILER="${CXX}"
export TOAST_BUILD_CMAKE_C_FLAGS="-O3 -g -fPIC"
export TOAST_BUILD_CMAKE_CXX_FLAGS="-O3 -g -fPIC"
export TOAST_BUILD_CMAKE_VERBOSE_MAKEFILE=1
export TOAST_BUILD_CMAKE_INSTALL_PREFIX="${PREFIX}"
export TOAST_BUILD_CMAKE_PREFIX_PATH="${PREFIX}"
export TOAST_BUILD_FFTW_ROOT="${PREFIX}"
export TOAST_BUILD_AATM_ROOT="${PREFIX}"
export TOAST_BUILD_BLAS_LIBRARIES="${PREFIX}/lib/libblas${SHLIB_EXT}"
export TOAST_BUILD_LAPACK_LIBRARIES="${PREFIX}/lib/liblapack${SHLIB_EXT}"
export TOAST_BUILD_SUITESPARSE_INCLUDE_DIR_HINTS="${PREFIX}/include"
export TOAST_BUILD_SUITESPARSE_LIBRARY_DIR_HINTS="${PREFIX}/lib"

# Ensure that stale build products are removed
rm -rf build

python -m pip install -vvv --ignore-installed --no-deps --prefix "${PREFIX}" .
