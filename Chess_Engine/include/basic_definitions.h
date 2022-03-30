#ifndef BDEFS_H
#define BDEFS_H

#define BOARD_SIZE 120

#define MAX_NUMBER_OF_MOVES 2048

#include <stdint.h>
#include <stdlib.h>
#include <math.h>

/*
 * Each ply is half a move. A move consists of a black and a white ply.
 * Each position has a key?
 * The _board arrays are used internally to convert between the two board formats.
 * The init function is used to initialize states and global variables
 * */

extern int board_120_to_64[BOARD_SIZE], board_64_to_120[64]; 

extern void init ();

typedef enum { EMPTY_SQUARE, W_P, W_N, W_B, W_R, W_Q, W_K, B_P, B_N, B_B, B_R, B_Q, B_K } piece;

typedef enum { A_FILE, B_FILE, C_FILE,  D_FILE, E_FILE, F_FILE, G_FILE, H_FILE, INVALID_FILE } file;

typedef enum { RANK_1, RANK_2, RANK_3, RANK_4, RANK_5, RANK_6, RANK_7, RANK_8, INVALID_RANK } rank; 

typedef enum { FALSE, TRUE } boolean;

typedef enum { BLACK, WHITE } color;

typedef enum { WHITE_KING_SIDE = 0, WHITE_QUEEN_SIDE = 2, BLACK_KING_SIDE = 4, BLACK_QUEEN_SIDE = 8 } castling_permission;
/* board starts from 21 as the first two and last 2 rows are used as invalid squares as the knight can jump to them similarly the first and the last column are used as invalid squares */
typedef enum {
    A1 = 21, B1, C1, D1, E1, F1, G1, H1,
    A2 = 31, B2, C2, D2, E2, F2, G2, H2,
    A3 = 41, B3, C3, D3, E3, F3, G3, H3,
    A4 = 51, B4, C4, D4, E4, F4, G4, H4,
    A5 = 61, B5, C5, D5, E5, F5, G5, H5,
    A6 = 71, B6, C6, D6, E6, F6, G6, H6,
    A7 = 81, B7, C7, D7, E7, F7, G7, H7,
    A8 = 91, B8, C8, D8, E8, F8, G8, H8, INVALID_SQUARE
} square;
/* the INVALID_SQUARE macro is also used to mark squares of the board as invalid, it is an out of bounds value on both 64 and 120 square indexing, this way the EMPTY_SQUARE represents valid but empty squares and the rest out of bounds are invalid*/

extern uint64_t piece_pos_keys[13][64]; /* once key for each piece type in each legal position on the board. 13th row of keys for en_passant keys*/
/* Technically only 16 keys are needed for en passant, but using the same key arr makes it convenient */

extern uint64_t side_pos_key; /* If it's white's turn XOR another random key value */

extern uint64_t castling_pos_keys[16]; /* Since castling permission has 4 bits for each possible permission. So number of combinations is 16, so we have 16 possible castling position keys */

/* Castling permission is 4 bits because black king side, black queen side and same on white */

typedef struct {
    square   en_passant;
    uint8_t  castling_permission;
    uint16_t move;
    uint16_t draw_counter; 
    uint32_t position_key; 
} move_history_t;

typedef struct { 
    //stores the piece on each position in the 64 squares.
    color          turn; 
    square         pieces[120];
    square         en_passant;
    move_history_t history[MAX_NUMBER_OF_MOVES]; // stores every single move in game
    uint8_t        piece_count[13]; // count number of pieces of each type on the board.
    uint8_t        big_piece_count[2]; // count of all pieces that aren't pawns
    uint8_t        major_piece_count[2]; // Number of major pieces on both sides i.e rooks and queens
    uint8_t        minor_piece_count[2]; // Number of major pieces on both sides i.e knights and bishops
    uint8_t        castling_permission;
    uint8_t        piece_list[13][10]; // save the file on which each piece is kept to reduce compute time 
    uint16_t       draw_counter; // to set draw on hitting 50 moves
    uint16_t       ply;
    uint16_t       repeat_ply; // to set draw due to repitition
    uint32_t       position_key; 
    uint64_t       pawn_postions[2]; //Is a bitfield used to save the position of each pawn (8 on each side)
} board_t;

#endif
