cd ../

# Clean binaries folder
rm ./Binaries -rf


# Recreate binaries folder structure.
mkdir ./Binaries
mkdir ./Binaries/Linux
mkdir ./Binaries/Linux/Resources

# Compile
fpc "./Code/INSAtram.pas" -FE"./Binaries/Linux"

# Copy resources and dynamic libraries (for windows).
cp -a ./Resources/* ./Binaries/Linux/Resources


