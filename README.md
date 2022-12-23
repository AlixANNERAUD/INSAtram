# 🚃 INSAtram

## 🗺️ Table of contents

- [🚃 INSAtram](#-insatram)
  - [🗺️ Table of contents](#️-table-of-contents)
  - [🪧 Introduction](#-introduction)
  - [📦️ Installation](#️-installation)
    - [🧰 Prerequisite](#-prerequisite)
    - [🎮️ Use](#️-use)
    - [🧑‍💻 Development](#-development)
  - [🗃️ Structure](#️-structure)
  - [ℹ️ About](#ℹ️-about)
    - [⚖️ Licence](#️-licence)
    - [👤 Authors](#-authors)
    - [📃 Credits](#-credits)

## 🪧 Introduction

This game is a copy of Mini Metro developed by the studio Dinosaur Polo Club.
This is a project carried out for the IT project requested by INSA Rouen in the 2nd year of preparatory class.
Thus, **no intellectual property rights were violated** during the realization of this project. It was designed and developed **solely** from **observations** made on the game.

## 📦️ Installation

### 🧰 Prerequisite

In order to compile the project, you will need to install the following tools :

- First, you need SDL 1.2 library. On ubuntu, install the synaptic packet manager with :
```
sudo apt install synaptic
```

- Then, from Synaptic, install the followings packets :
  - `libsdl-gfx1.2-dev`
  - `libsdl-image1.2-dev`
  - `libsdl-mixer1.2-dev`
  - `libsdl-ttf2.0-dev`
  - `libsmpeg-dev`

### 🎮️ Use

You can download the archives containing the binaries here:

- [Linux](https://github.com/AlixANNERAUD/INSAtram/releases/download/1.0.0/Binaries_Linux_x86_64.zip)
- [Windows]()

### 🧑‍💻 Development

You can develop this project by making a fork of it and then clone it on your computer. For compiling the source code, on linux, you can use the following scripts :

- `Scripts/Build_Debug.sh` : Build for debugging purpose.
- `Scripts/Test.sh` : Build and run for debugging purpose.
- `Scripts/Build_Release.sh` : Build for release.

## 🗃️ Structure

The project is structured in folder as follows:
- `Binaries` : Contains compiled binaries (compiler output) as well as the resources (Fonts, Images).
- `Code` : Contains the project code as well as the scripts allowing the compilation and the launching.
- `Documentation` : Contains project documentation (specifications, top-down analysis, final report).
- `Librairies` : Contains libraries for Windows.
- `Scripts` : Contains script for testing and compiling the code automatically.

## ℹ️ About

### ⚖️ Licence

This project is under MIT License.

### 👤 Authors

- Myriem ABID
- Alix ANNERAUD
- Hugo LASCOUTS

### 📃 Credits

This project uses the following resources :
- Compiler : [Free Pascal Compiler](https://www.freepascal.org/)
- Graphics library : [SDL 1.2](https://www.libsdl.org/index.php)
- Icons : [Font Awesome](https://fontawesome.com/)
- Background music : [Ambiance Guitar X1](https://freesound.org/people/frankum/sounds/405453/) - [Frankum](https://frankum-frankumjay.blogspot.com/)
- Font : [Titillium Web](https://fonts.google.com/specimen/Titillium+Web) -  [Accademia di Belle Arti di Urbino](https://fonts.google.com/?query=Accademia%20di%20Belle%20Arti%20di%20Urbino)