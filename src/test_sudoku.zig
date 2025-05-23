const std = @import("std");
const sud = @import("sudoku.zig");
const expect = std.testing.expect;

test "test getBoxNumber" {
    try expect(sud.getBoxNumber(0) == 0);
    try expect(sud.getBoxNumber(3) == 1);
    try expect(sud.getBoxNumber(80) == 8);
}
