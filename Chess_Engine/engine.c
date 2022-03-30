//This is the main class.
#include <stdio.h>
#include "basic_definitions.h"
#include "engine_util.h"

void test () {
    uint64_t bb = 1ULL << board_120_to_64[A1];
    print_bitboard(bb);
    printf("\nCount of number of set bits: %d", count_bit(bb));    
    printf("\nAfter popping the last set bit at %d:-\n\n", pop_bit(&bb));
    print_bitboard(bb);
    printf("\nCount of number of set bits: %d", count_bit(bb));

    SET_BIT(bb, board_120_to_64[A3]);
    print_bitboard(bb);
    SET_BIT(bb, board_120_to_64[A2]);
    print_bitboard(bb);
    SET_BIT(bb, board_120_to_64[A4]);
    print_bitboard(bb);
    SET_BIT(bb, board_120_to_64[A5]);
    print_bitboard(bb);
    SET_BIT(bb, board_120_to_64[A6]);
    print_bitboard(bb);

    CLEAR_BIT(bb, board_120_to_64[A2]);
    print_bitboard(bb);
    CLEAR_BIT(bb, board_120_to_64[A3]);
    print_bitboard(bb);
    CLEAR_BIT(bb, board_120_to_64[A4]);
    print_bitboard(bb);
    CLEAR_BIT(bb, board_120_to_64[A5]);
    print_bitboard(bb);
    CLEAR_BIT(bb, board_120_to_64[A6]);
    print_bitboard(bb);

}

void print_test_board(board_t *board) {
    int i, j;
    for (i = 0; i < 12; i++) {
        for (j = 0; j < 10; j++){
            printf("%3d", board->pieces[i*10+j]);
        }
        printf("\n");
    }
}
int main (int argc, char* argv[]) {
    init();
    /*printf("A3: %d H3: %d A6: %d H6: %d\n", board_120_to_64[A3], board_120_to_64[H3], board_120_to_64[A6], board_120_to_64[H6]);*/
    board_t b;
    char* fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
    parse_fen(fen, &b);
    print_test_board(&b);
    return 0;
}
