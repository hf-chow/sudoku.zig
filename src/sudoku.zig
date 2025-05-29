const std = @import("std");

pub const ParsingError = error{
    MalformedBoard,
    InvalidCellValue,
};

pub const BoardError = error{
    NonEmptyCell,
    NoSolution,
};

pub const Board = struct {
    state: [9][9]usize,

    pub fn fillCell(self: *Board, row: usize, col: usize, digit: usize) !void {
        if (self.state[row][col] != 0) {
            return error.NonEmptyCell;
        }
        self.state[row][col] = digit;
    }

    fn isValid(self: *const Board, row: usize, col: usize, digit: u8) !bool {
        // check if the incoming digit does not collide with the existing one
        for (0..9) |r| {
            if (r != row and self.state[r][col] == digit) {
                return false;
            }
        }
        for (0..9) |c| {
            if (c != col and self.state[row][c] == digit) {
                return false;
            }
        }

        const box_row = (row / 3) * 3;
        const box_col = (col / 3) * 3;
        for (box_row..box_row + 3) |r| {
            for (box_col..box_col + 3) |c| {
                if (r != row and c != col and self.state[r][c] == digit) {
                    return false;
                }
            }
        }
        return true;
    }
};

pub fn solve(board: *Board) !bool {
    if (!(try solveRecursive(board))) {
        return error.NoSolution;
    }
    if (!(try checkBoard(board.*))) {
        return error.InvalidCellValue;
    }
    return try solveRecursive(board);
}

fn solveRecursive(board: *Board) !bool {
    // find the empty cell to fill
    var row: usize = 0;
    var col: usize = 0;
    var found = false;
    for (0..9) |r| {
        for (0..9) |c| {
            if (board.state[r][c] == 0) {
                row = r;
                col = c;
                found = true;
                break;
            }
        }
        if (found) break;
    }

    // base case
    if (!found) {
        return true;
    }

    // DFS with backtracking
    for (1..10) |digit| {
        const d: u8 = @intCast(digit);
        if (try board.isValid(row, col, d)) {
            // try to fill cell
            board.state[row][col] = d;
            if (try solveRecursive(board)) {
                return true;
            } else {
                // restoring the cell to empty
                board.state[row][col] = 0;
            }
        }
    }
    // backtracking
    return false;
}

pub fn getColumn(board: Board, idx: usize) ![9]usize {
    if (idx > 8) {
        return error.MalformedBoard;
    }
    var col: [9]usize = .{0} ** 9;
    for (0..9) |row| {
        col[row] = board.state[row][idx];
    }
    return col;
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
        boxes[box_num][cell_idx] = board.state[row][col];
        box_counts[box_num] += 1;
    }
    return boxes;
}

pub fn check(group: []const usize) !bool {
    for (0..group.len) |i| {
        if (group[i] == 0) {
            return false;
        }
    }
    if (group.len != 9) {
        return error.MalformedBoard;
    }
    var sorted: [9]usize = .{0} ** 9;
    @memcpy(sorted[0..], group);
    std.mem.sort(usize, sorted[0..], {}, std.sort.asc(usize));

    var i: usize = 1;
    while (i < 9) : (i += 1) {
        if (sorted[i] == sorted[i - 1]) {
            return false;
        }
    }
    return true;
}

pub fn parse(input: []const u8) !Board {
    if (input.len != 81) {
        return error.MalformedBoard;
    }
    var board = Board{
        .state = .{.{0} ** 9} ** 9,
    };
    for (0.., input) |i, elem| {
        if (elem < '0' or elem > '9') {
            return error.InvalidCellValue;
        }
        const row = i / 9;
        const col = i % 9;
        board.state[row][col] = elem - '0';
    }
    return board;
}

pub fn printBoard(board: Board) void {
    for (0..9) |_| {
        std.debug.print("--", .{});
    }
    std.debug.print("\n", .{});

    for (0..9) |row| {
        for (0..9) |col| {
            std.debug.print("{d} ", .{board.state[row][col]});
        }
        std.debug.print("\n", .{});
    }
    for (0..9) |_| {
        std.debug.print("--", .{});
    }
    std.debug.print("\n", .{});
}

pub fn checkBoard(board: Board) !bool {
    const boxes = try boardToBoxes(board);
    for (0..9) |i| {
        const curr_col = try getColumn(board, i);
        const curr_row = board.state[i];
        const curr_box = boxes[i];

        if (try check(&curr_col) and try check(&curr_row) and try check(&curr_box)) {
            continue;
        } else {
            return false;
        }
    }
    return true;
}
