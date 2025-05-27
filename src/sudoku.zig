const std = @import("std");

pub const Board = [9][9]usize;

pub const ParsingError = error{
    MalformedBoard,
    InvalidCellValue,
};

pub fn getColumn(board: Board, idx: usize) ![]const usize {
    if (idx > 8) {
        return error.MalformedBoard;
    }
    var col: [9]usize = .{0} ** 9;
    for (0..9) |row| {
        col[row] = board[row][idx];
    }
    return col[0..];
}

pub fn getBoxNumber(i: usize) !u8 {
    if (i > 80) {
        return error.MalformedBoard;
    }
    const row = i / 9;
    const col = i % 9;
    const box_num = (row / 3) * 3 + (col / 3);
    return @intCast(box_num);
}

pub fn boardToBoxes(board: Board) ![9][9]usize {
    var boxes: [9][9]usize = .{.{0} ** 9} ** 9;
    var box_counts: [9]usize = .{0} ** 9;
    for (0..81) |i| {
        const row = i / 9;
        const col = i % 9;
        const box_num = try getBoxNumber(i);
        const cell_idx = box_counts[box_num];
        boxes[box_num][cell_idx] = board[row][col];
        box_counts[box_num] += 1;
    }
    return boxes;
}

pub fn check(group: []const usize) !bool {
    if (group.len != 9) {
        return error.MalformedBoard;
    }
    var sorted: [9]usize = undefined;
    @memcpy(sorted[0..], group);
    std.mem.sort(usize, sorted[0..], {}, std.sort.asc(usize));

    var i: usize = 1;
    while (i < 9) : (i += 1) {
        if (sorted[i] != 0 and sorted[i] == sorted[i - 1]) {
            return false;
        }
    }
    return true;
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
            std.debug.print("{d} ", .{board[row][col]});
        }
        std.debug.print("\n", .{});
    }
}
