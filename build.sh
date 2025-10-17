# Clear current session log 
clear
# Source environment (Uncomment lines starting with "export" if you current env does not have these defined.)
# Define Resolver > Has to be one of 'fileResolver'/'pythonResolver'/'cachedResolver'/'httpResolver'
# export AR_RESOLVER_NAME=cachedResolver
# Define App (for other apps, see documentation)
# export AR_DCC_NAME=HOUDINI
# export HFS=/opt/<InsertHoudiniVersion>
# Clear existing build data and invoke cmake
rm -R build
rm -R dist
set -e # Exit on error
cmake . -B build
cmake --build build --clean-first              # make clean all
cmake --install build                          # make install
ctest -VV --test-dir build