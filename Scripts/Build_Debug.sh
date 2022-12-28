cd ../

# Clean binaries folder
rm ./Binaries -rf


# Recreate binaries folder structure.
mkdir ./Binaries
mkdir ./Binaries/Linux
mkdir ./Binaries/Linux/Resources

# Compile
fpc "./Code/INSAtram.pas" -FE"./Binaries/Linux" -gh -gl -vewnh
# fpc "./Code/INSAtram.pas" -FE"./Binaries/Windows" -gh -Twin64

# Copy resources
cp -a ./Resources/* ./Binaries/Linux/Resources


