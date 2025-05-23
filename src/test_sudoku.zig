const std = @import("std");
const sud = @import("sudoku.zig");
const expect = std.testing.expect;

test "test getBoxNumber" {
    try expect(sud.getBoxNumber(0) == 0);
    try expect(sud.getBoxNumber(3) == 1);
    try expect(sud.getBoxNumber(80) == 8);
}

test "test parsing erros" {
    try expect(sud.parse("64") == sud.ParsingError.MalformedBoard);
    try expect(sud.parse("abcd23476942576138763418592259841763678395241314267859896154327437682915521739684") == sud.ParsingError.InvalidCellValue);
}
