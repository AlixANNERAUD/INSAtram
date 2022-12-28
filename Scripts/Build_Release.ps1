cd ../

# Clean binaries folder
Remove-Item './Binaries' -Recurse

Copy-Item -Path ".\Libraries\sdl_gfx.pas" -Destination ".\Code" -Force

# Recreate binaries folder structure.
mkdir ./Binaries
mkdir ./Binaries/Windows
mkdir ./Binaries/Windows/Resources

fpc "./Code/INSAtram.pas" -FE"./Binaries/Windows"

# Copy resources

Copy-Item -Path ".\Libraries\*" -Destination ".\Binaries\Windows" -Recurse -Force
Copy-Item -Path ".\Resources\*" -Destination ".\Binaries\Windows\Resources" -Recurse -Force

# Remove sdl_gfx header

Remove-Item './Code/sdl_gfx.pas'