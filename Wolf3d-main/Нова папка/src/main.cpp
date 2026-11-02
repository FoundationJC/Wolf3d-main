#include "Game.h"

#include <SDL.h>
#include <iostream>

int main(int argc, char* argv[]) {
    (void)argc;
    (void)argv;

    Game game;
    if (!game.initialize()) {
        const char* sdlError = SDL_GetError();
        std::cerr << "Failed to initialize the game";
        if (sdlError != nullptr && sdlError[0] != '\0') {
            std::cerr << ": " << sdlError;
        }
        std::cerr << std::endl;
        return 1;
    }

    game.run();
    game.shutdown();
    return 0;
}
