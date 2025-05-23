const std = @import("std");
const Board = [9][9]u8;

const ParsingError = error{
    MalformedBoard,
    NotInteger,
    NotWithinRange,
};

pub fn getBoxNumber(i: usize) u8 {
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
