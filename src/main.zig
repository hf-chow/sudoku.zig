const std = @import("std");
const sud = @import("sudoku.zig");
const ParsingError = error{
    MalformedBoard,
    NotInteger,
    NotWithinRange,
};

fn getBoxNumber(i: usize) u8 {
    const row = i / 9;
    const col = i % 9;
    const box_num = (row / 3) * 3 + (col / 3);
    return @intCast(box_num);
}

//fn parse(input: []const u8) !Board {
//    if (input.len != 81) {
//        return error.MalformedBoard;
//    }
//    for (input, 0..) |cell, index| {
//
//    }
//}

pub fn main() void {
    const input = "085923476942576138763418592259841763678395241314267859896154327437682915521739684";
    for (0.., input) |i, _| {
        const boxNumber = sud.getBoxNumber(i);
        std.debug.print("{}\n", .{boxNumber});
    }
}
