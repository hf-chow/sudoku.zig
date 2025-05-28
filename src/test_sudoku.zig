const std = @import("std");
const sud = @import("sudoku.zig");
const expect = std.testing.expect;

test "test fillCell" {
    var incomplete_board = sud.Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    try incomplete_board.fillCell(0, 0, 1);
    try expect(incomplete_board.state[0][0] == 1);
}
test "test checkBoard" {
    const correct_board = sud.Board{
        .state = .{
            .{ 1, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };

    const incomplete_board = sud.Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };

    const incorrect_board = sud.Board{
        .state = .{
            .{ 9, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    try expect(try sud.checkBoard(incomplete_board) == false);
    try expect(try sud.checkBoard(incorrect_board) == false);
    try expect(try sud.checkBoard(correct_board) == true);
}

test "test getColumn" {
    const board = sud.Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    const cols: [9][9]usize = .{
        .{ 0, 9, 7, 2, 6, 3, 8, 4, 5 },
        .{ 8, 4, 6, 5, 7, 1, 9, 3, 2 },
        .{ 5, 2, 3, 9, 8, 4, 6, 7, 1 },
        .{ 9, 5, 4, 8, 3, 2, 1, 6, 7 },
        .{ 2, 7, 1, 4, 9, 6, 5, 8, 3 },
        .{ 3, 6, 8, 1, 5, 7, 4, 2, 9 },
        .{ 4, 1, 5, 7, 2, 8, 3, 9, 6 },
        .{ 7, 3, 9, 6, 4, 5, 2, 1, 8 },
        .{ 6, 8, 2, 3, 1, 9, 7, 5, 4 },
    };
    for (0..9) |i| {
        const col = try sud.getColumn(board, i);
        try std.testing.expectEqualSlices(usize, &col, &cols[i]);
    }
}

test "test getBoxNumber" {
    try expect(try sud.getBoxNumber(0) == 0);
    try expect(try sud.getBoxNumber(3) == 1);
    try expect(try sud.getBoxNumber(80) == 8);
}

test "test getBoxNumber errors" {
    try expect(sud.getBoxNumber(81) == sud.ParsingError.MalformedBoard);
}

test "parse valid input" {
    const input = "085923476942576138763418592259841763678395241314267859896154327437682915521739684";
    const expected = sud.Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    const board = try sud.parse(input);
    try std.testing.expectEqual(expected, board);
}

test "test parsing errors" {
    try expect(sud.parse("64") == sud.ParsingError.MalformedBoard);
    try expect(sud.parse("abcd23476942576138763418592259841763678395241314267859896154327437682915521739684") == sud.ParsingError.InvalidCellValue);
}

test "test checking" {
    const valid = [_]usize{ 9, 3, 4, 2, 1, 5, 7, 6, 8 };
    try expect(try sud.check(&valid) == true);

    const repetition = [_]usize{ 9, 3, 4, 2, 1, 5, 7, 6, 9 };
    try expect(try sud.check(&repetition) == false);

    const malformed = [_]usize{ 9, 3, 4, 2, 1, 5, 7, 6 };
    try expect(sud.check(&malformed) == sud.ParsingError.MalformedBoard);
}

test "test boardToBoxes" {
    const board = sud.Board{ .state = .{
        .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
        .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
        .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
        .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
        .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
        .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
        .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
        .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
        .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
    } };
    const expected: [9][9]usize = .{
        .{ 0, 8, 5, 9, 4, 2, 7, 6, 3 },
        .{ 9, 2, 3, 5, 7, 6, 4, 1, 8 },
        .{ 4, 7, 6, 1, 3, 8, 5, 9, 2 },
        .{ 2, 5, 9, 6, 7, 8, 3, 1, 4 },
        .{ 8, 4, 1, 3, 9, 5, 2, 6, 7 },
        .{ 7, 6, 3, 2, 4, 1, 8, 5, 9 },
        .{ 8, 9, 6, 4, 3, 7, 5, 2, 1 },
        .{ 1, 5, 4, 6, 8, 2, 7, 3, 9 },
        .{ 3, 2, 7, 9, 1, 5, 6, 8, 4 },
    };
    const boxes = try sud.boardToBoxes(board);
    for (0..8) |i| {
        try std.testing.expectEqualSlices(usize, &expected[i], &boxes[i]);
    }
}
