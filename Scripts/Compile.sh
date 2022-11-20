cd ../

# Clean binaries folder
rm ./Binaries -rf


# Recreate binaries folder structure.
mkdir ./Binaries
mkdir ./Binaries/Linux
mkdir ./Binaries/Windows
mkdir ./Binaries/Linux/Resources
mkdir ./Binaries/Windows/Resources

# Compile
fpc "./Code/INSAtram.pas" -FE"./Binaries/Linux" -gh
# fpc "./Code/INSAtram.pas" -FE"./Binaries/Windows" -gh -Twin64

# Copy resources and dynamic libraries (for windows).
cp -a ./Librairies/* ./Binaries/Windows
cp -a ./Resources/* ./Binaries/Linux/Resources


