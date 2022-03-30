/*
 *Contains initialization methods. Use to set all the variables and set up the board. 
 * */

#include "basic_definitions.h"
#include "engine_util.h"
#include <time.h>

int board_120_to_64[BOARD_SIZE], board_64_to_120[64];

uint64_t piece_pos_keys[13][64], side_pos_key, castling_pos_keys[16], en_passant_pos_keys[16]; 

void init_board_conversion () {
    int i, j, k, square;
    k = 0;

    for (i = 0; i < BOARD_SIZE; i++) {
        board_120_to_64[i] = 64;
    }

    for (i = 0; i < 64; i++) {
        board_64_to_120[i] = 120;
    }

    for (i = RANK_1; i <= RANK_8; i++) {
        for (j = A_FILE; j <= H_FILE; j++) {
            square = FILE_RANK_TO_SQ120(j, i);
            board_120_to_64[square] = k;
            board_64_to_120[k++] = square;
        }
    }
}

void init_pos_key_vals () {
    int i, j;

    for (i = 0; i < 13; i++) {
        for (j = 0; j < 64; j++) {
            piece_pos_keys[i][j] = RAND_64_BIT;
        }
    }

    side_pos_key = RAND_64_BIT;

    for (i = 0; i < 16; i++) {
        castling_pos_keys[i] = RAND_64_BIT;
    }
}

void init () { 
    srand(time(NULL)); /* Seed for random numbers */
    init_board_conversion();
    init_pos_key_vals();
}
