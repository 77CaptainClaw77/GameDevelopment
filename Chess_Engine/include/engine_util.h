/*
 * Contains functions and macros to simplify tasks in the engine
 * */
#ifndef ENGINE_UTIL_H
#define ENGINE_UTIL_H

#include "basic_definitions.h"
#include <stdio.h>
#include <ctype.h>

#define RAND_64_BIT ((uint64_t)rand() | \
        (uint64_t)rand() << 15 | \
        (uint64_t)rand() << 30 | \
        (uint64_t)rand() << 45 | \
        ((uint64_t)rand() & 0x0f) << 60)

#define FILE_RANK_TO_SQ120(f, r) (21 + (f) + ((r) * 10))

#define CLEAR_BIT(bit_board, square) (bit_board &= (~(1ULL << (square))))

#define SET_BIT(bit_board, square) (bit_board |= (1ULL << (square)))

#define DEBUG 

#ifndef DEBUG
#define ASSERT(n) assert((n));
#else
#define ASSERT(n) {\
    if (!(n)) { \
        printf("Failed at line %d in %s() in file %s\n", __LINE__, __func__, __FILE__); \
        exit(1);\
    } \
}
#endif

void print_bitboard (uint64_t bit_board);

int pop_bit (uint64_t* bit_board); /* find the smallest set bit, retrun index and set bit to 0 */

int count_bit (uint64_t bit_board); /* count and return number of set bits in the bitboard. */

uint64_t generate_position_key (const board_t* board); /* generate a position hash key for current board*/

int parse_fen (const char* fen, board_t* board);

#endif
