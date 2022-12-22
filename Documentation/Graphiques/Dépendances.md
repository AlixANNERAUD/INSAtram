```mermaid
stateDiagram-v2


    state SDL {
        sdl
        sdl_gfx
        sdl_mixer
        sdl_ttf
        sdl_image
    }

    SDL --> INSAtram

    state fpc {
        sysutils
        Math
        crt
    }
    
    fpc --> INSAtram

    state INSAtram {

    state Base {

    Unit_Types --> Unit_Common
    Unit_Constants --> Unit_Common
    }

    Base --> Unit_Animation

    Base --> Unit_Graphics
    Base --> Unit_Logic
    Base --> Unit_Sound
    Base --> Unit_Mouse

    Unit_Animation --> Unit_Graphics

    Unit_Sound --> Unit_Logic

    Unit_Graphics --> Unit_Logic

    Unit_Mouse --> Unit_Logic

    Unit_Logic --> INSAtr

    }

```