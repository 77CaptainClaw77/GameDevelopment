#include "engine_util.h"

const int de_brujin_lookup[] = {
   0,  1,  48,  2, 57, 49, 28,  3,
   61, 58, 50, 42, 38, 29, 17,  4,
   62, 55, 59, 36, 53, 51, 43, 22,
   45, 39, 33, 30, 24, 18, 12,  5,
   63, 47, 56, 27, 60, 41, 37, 16,
   54, 35, 52, 21, 44, 32, 23, 11,
   46, 26, 40, 15, 34, 20, 31, 10,
   25, 14, 19,  9, 13,  8,  7,  6
}; /* de brujin mapping for pop */

const uint64_t de_brujin = 0x03f79d71b4cb0a89ULL;

void print_bitboard (uint64_t bit_board) {
    int r, f, square;
    printf("\n\n\t------BOARD------\n\n");
    for (r = RANK_8; r >= RANK_1; r--) { /*Rank 8 is on top and is printed first*/
        for (f = A_FILE; f <= H_FILE; f++) {
            square = board_120_to_64[FILE_RANK_TO_SQ120(f, r)];
            if (bit_board & (1ULL << square)) {
                printf("%3c", 'X');
            } else {
                printf("%3c", '-');
            }
        }
        printf("\n");
    }
}

int pop_bit (uint64_t* bit_board) {
    ASSERT((*bit_board) != 0);
    int pos = de_brujin_lookup[(((*bit_board) & -(*bit_board)) * de_brujin) >> 58]; /* isloate LS1B, multiply by de_brujin number and right shift to get get position of set bit by lookup */
    *bit_board &= (*bit_board - 1);
    return pos;
}

int count_bit (uint64_t bit_board) {
    int i;
    for(i = 0; bit_board; i++, bit_board &= bit_board - 1); /* pop bits */
    return i;
}

uint64_t generate_position_key (const board_t* board) {
    uint64_t pos_key = 0;
    int i, j, piece, square;

    for (i = RANK_8; i >= RANK_1; i--) {
        for (j = A_FILE; j <= H_FILE; j++) {
            square = board_120_to_64[FILE_RANK_TO_SQ120(j, i)];
            piece = board->pieces[FILE_RANK_TO_SQ120(j, i)];
            if (piece == EMPTY_SQUARE) {
                continue;
            }
            ASSERT(piece >= W_P && piece <= B_K);
            pos_key ^= piece_pos_keys[piece][square];
        }
    }

    if (board->turn == WHITE) {
        pos_key ^= side_pos_key;
    }

    if (board->en_passant != INVALID_SQUARE) {
        ASSERT(board->en_passant >= 0 && board->en_passant <= BOARD_SIZE)
        pos_key ^= piece_pos_keys[EMPTY_SQUARE][board->en_passant];
    }

    ASSERT(board->castling_permission >= 0 && board->castling_permission <= 15)
    pos_key ^= castling_pos_keys[board->castling_permission];

    return pos_key;
}

int parse_fen (const char* fen, board_t* board) { 
    int i, j; 
    i = 0;
    int r = RANK_8, f = A_FILE;
    int empty_count = 0;
    int piece = EMPTY_SQUARE;
    while (r >= RANK_1 && fen[i] != '\0') {
        if (fen[i] == '/' || fen[i] == ' ') {
            r--;
            f = A_FILE;
            i++;
            continue;
        }

        if (isdigit(fen[i])) {
            empty_count = fen[i] - '0';
            for (j = 0; j < empty_count; j++, f++){
                board -> pieces[FILE_RANK_TO_SQ120(f, r)] = EMPTY_SQUARE;
            }
        }

        else {
            switch(tolower(fen[i])) {
                case 'r': piece = isupper(fen[i])? W_R: B_R;
                    break;
                case 'n': piece = isupper(fen[i])? W_N: B_N;
                    break;
                case 'b': piece = isupper(fen[i])? W_B: B_B;
                    break;
                case 'q': piece = isupper(fen[i])? W_Q: B_Q;
                    break;
                case 'k': piece = isupper(fen[i])? W_K: B_K;
                    break;
                default:  piece = isupper(fen[i])? W_P: B_P;
            }
            board -> pieces[FILE_RANK_TO_SQ120(f, r)] = piece;
            f++;
        }
        
        i++;
    }
    board->turn = fen[i] == 'b'? BLACK: WHITE;
    i += 2;

    board->castling_permission = 0;
    while (fen[i] != '-' && fen[i] != ' ') {
        if (fen[i] == 'K') {
            board->castling_permission |= WHITE_KING_SIDE;
        }
        else if (fen[i] == 'Q') {
            board->castling_permission |= WHITE_QUEEN_SIDE;
        }
        else if (fen[i] == 'k') {
            board->castling_permission |= BLACK_KING_SIDE;
        }
        else {
            board->castling_permission |= BLACK_QUEEN_SIDE;
        }
        i++;
    }
    if(fen[i] == '-') {
        i++;
    }
    i++;
    if(fen[i] != '-') {
        f = fen[i] - 'a';
        r = fen[i+1] - '1';

        board->en_passant = FILE_RANK_TO_SQ120(f, r);
    }
}
