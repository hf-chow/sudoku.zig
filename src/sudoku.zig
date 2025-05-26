const std = @import("std");

pub const Board = [9][9]u8;

pub const ParsingError = error{
    MalformedBoard,
    InvalidCellValue,
};

pub fn getBoxNumber(i: usize) !u8 {
    if (i > 80) {
        return error.MalformedBoard;
    }
    const row = i / 9;
    const col = i % 9;
    const box_num = (row / 3) * 3 + (col / 3);
    return @intCast(box_num);
}

pub fn parse(input: []const u8) !Board {
    if (input.len != 81) {
        return error.MalformedBoard;
    }
    var board: Board = .{.{0} ** 9} ** 9;
    for (0.., input) |i, elem| {
        if (elem < '0' or elem > '9') {
            return error.InvalidCellValue;
        }
        const row = i / 9;
        const col = i % 9;
        board[row][col] = elem - '0';
    }
    return board;
}

pub fn printBoard(board: Board) void {
    for (0..9) |row| {
        for (0..9) |col| {
            std.debug.print("{c} ", .{board[row][col]});
        }
        std.debug.print("\n", .{});
    }
}
