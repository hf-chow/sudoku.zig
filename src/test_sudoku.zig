const std = @import("std");
const sud = @import("sudoku.zig");
const expect = std.testing.expect;

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
    const expected: sud.Board = .{
        .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
        .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
        .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
        .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
        .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
        .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
        .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
        .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
        .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
    };
    const board = try sud.parse(input);
    try std.testing.expectEqual(expected, board);
}

test "test parsing errors" {
    try expect(sud.parse("64") == sud.ParsingError.MalformedBoard);
    try expect(sud.parse("abcd23476942576138763418592259841763678395241314267859896154327437682915521739684") == sud.ParsingError.InvalidCellValue);
}

test "test checking" {
    const valid = [_]u8{ 9, 3, 4, 2, 1, 5, 7, 6, 8 };
    try expect(try sud.check(&valid) == true);

    const repetition = [_]u8{ 9, 3, 4, 2, 1, 5, 7, 6, 9 };
    try expect(try sud.check(&repetition) == false);

    const malformed = [_]u8{ 9, 3, 4, 2, 1, 5, 7, 6 };
    try expect(sud.check(&malformed) == sud.ParsingError.MalformedBoard);
}

test "test boardToBoxes" {
    const board: sud.Board = .{
        .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
        .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
        .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
        .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
        .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
        .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
        .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
        .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
        .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
    };
    const expected: [9][9]u8 = .{
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
        try std.testing.expectEqualSlices(u8, &expected[i], &boxes[i]);
    }
}
