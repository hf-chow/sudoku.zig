const std = @import("std");
const sud = @import("sudoku.zig");

pub fn main() !void {
    const input = "085923476942576138763418592259841763678395241314267859896154327437682915521739684";
    const board = sud.parse(input) catch |err| {
        std.debug.print("Parse error: {}\n", .{err});
        return;
    };
    sud.printBoard(board);
}
