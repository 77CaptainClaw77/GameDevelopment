#include "board_ops.h"
#include "engine_util.h"
#include "basic_definitions.h"
void reset_board(board_t* board) {
    int i = 0;
    for (i = 0; i < BOARD_SIZE; i++) {
        board->pieces[i] = INVALID_SQUARE;
    }

    for (i = 0; i < 64; i++) {
        board->pieces[board_64_to_120[i]] = EMPTY_SQUARE;
    }

    for (i = 0; i < 2; i++) {
        board->major_piece_count[i] = 0;
        board->minor_piece_count[i] = 0;
        board->big_piece_count[i] = 0;
        board->pawn_postions[i] = 0ULL;
    }

    for (i = 0; i < 13; i++) {
        board->piece_count[i] = 0;
    }
    
    board->draw_counter = 0;
    board->turn = WHITE;
    board->en_passant = INVALID_SQUARE;

    board->ply = 0;
    board->repeat_ply = 0;

    board->castling_permission = 0;
    
    board->pos_key = 0ULL;
}


