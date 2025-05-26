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
