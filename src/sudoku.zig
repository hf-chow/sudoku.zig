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

fn getColumn(board: Board, idx: usize) ![9]usize {
    if (idx > 8) {
        return error.MalformedBoard;
    }
    var col: [9]usize = .{0} ** 9;
    for (0..9) |row| {
        col[row] = board.state[row][idx];
    }
    return col;
}

fn getBoxNumber(i: usize) !u8 {
    if (i > 80) {
        return error.MalformedBoard;
    }
    const row = i / 9;
    const col = i % 9;
    const box_num = (row / 3) * 3 + (col / 3);
    return @intCast(box_num);
}

fn boardToBoxes(board: Board) ![9][9]usize {
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

fn check(group: []const usize) !bool {
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

test "test solve" {
    var incomplete_board = Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };

    const solved_board = Board{
        .state = .{
            .{ 1, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    try std.testing.expectEqual(try solve(&incomplete_board), true);
    try std.testing.expectEqual(incomplete_board, solved_board);
}
test "test fillCell" {
    var incomplete_board = Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    try incomplete_board.fillCell(0, 0, 1);
    try std.testing.expectEqual(incomplete_board.state[0][0], 1);
}
test "test checkBoard" {
    const correct_board = Board{
        .state = .{
            .{ 1, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };

    const incomplete_board = Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };

    const incorrect_board = Board{
        .state = .{
            .{ 9, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    try std.testing.expectEqual(try checkBoard(correct_board), true);
    try std.testing.expectEqual(try checkBoard(incorrect_board), false);
    try std.testing.expectEqual(try checkBoard(incomplete_board), false);
}

test "test getColumn" {
    const board = Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    const cols: [9][9]usize = .{
        .{ 0, 9, 7, 2, 6, 3, 8, 4, 5 },
        .{ 8, 4, 6, 5, 7, 1, 9, 3, 2 },
        .{ 5, 2, 3, 9, 8, 4, 6, 7, 1 },
        .{ 9, 5, 4, 8, 3, 2, 1, 6, 7 },
        .{ 2, 7, 1, 4, 9, 6, 5, 8, 3 },
        .{ 3, 6, 8, 1, 5, 7, 4, 2, 9 },
        .{ 4, 1, 5, 7, 2, 8, 3, 9, 6 },
        .{ 7, 3, 9, 6, 4, 5, 2, 1, 8 },
        .{ 6, 8, 2, 3, 1, 9, 7, 5, 4 },
    };
    for (0..9) |i| {
        const col = try getColumn(board, i);
        try std.testing.expectEqualSlices(usize, &col, &cols[i]);
    }
}

test "test getBoxNumber" {
    try std.testing.expectEqual(try getBoxNumber(0), 0);
    try std.testing.expectEqual(try getBoxNumber(3), 1);
    try std.testing.expectEqual(try getBoxNumber(80), 8);
}

test "test getBoxNumber errors" {
    try std.testing.expectEqual(getBoxNumber(81), ParsingError.MalformedBoard);
}

test "parse valid input" {
    const input = "085923476942576138763418592259841763678395241314267859896154327437682915521739684";
    const expected = Board{
        .state = .{
            .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
            .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
            .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
            .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
            .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
            .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
            .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
            .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
            .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
        },
    };
    const board = try parse(input);
    try std.testing.expectEqual(expected, board);
}

test "test parsing errors" {
    try std.testing.expectEqual(parse("64"), ParsingError.MalformedBoard);
    try std.testing.expectEqual(parse("abcd23476942576138763418592259841763678395241314267859896154327437682915521739684"), ParsingError.InvalidCellValue);
}

test "test checking" {
    const valid = [_]usize{ 9, 3, 4, 2, 1, 5, 7, 6, 8 };
    try std.testing.expectEqual(try check(&valid), true);

    const repetition = [_]usize{ 9, 3, 4, 2, 1, 5, 7, 6, 9 };
    try std.testing.expectEqual(try check(&repetition), false);

    const empty = [_]usize{ 0, 3, 4, 2, 1, 5, 7, 6, 9 };
    try std.testing.expectEqual(try check(&empty), false);

    const malformed = [_]usize{ 9, 3, 4, 2, 1, 5, 7, 6 };
    try std.testing.expectEqual(check(&malformed), ParsingError.MalformedBoard);
}

test "test boardToBoxes" {
    const board = Board{ .state = .{
        .{ 0, 8, 5, 9, 2, 3, 4, 7, 6 },
        .{ 9, 4, 2, 5, 7, 6, 1, 3, 8 },
        .{ 7, 6, 3, 4, 1, 8, 5, 9, 2 },
        .{ 2, 5, 9, 8, 4, 1, 7, 6, 3 },
        .{ 6, 7, 8, 3, 9, 5, 2, 4, 1 },
        .{ 3, 1, 4, 2, 6, 7, 8, 5, 9 },
        .{ 8, 9, 6, 1, 5, 4, 3, 2, 7 },
        .{ 4, 3, 7, 6, 8, 2, 9, 1, 5 },
        .{ 5, 2, 1, 7, 3, 9, 6, 8, 4 },
    } };
    const expected: [9][9]usize = .{
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
    const boxes = try boardToBoxes(board);
    for (0..8) |i| {
        try std.testing.expectEqualSlices(usize, &expected[i], &boxes[i]);
    }
}
