const std = @import("std");
const sdk = @import("sudoku.zig");
const psr = @import("parser.zig");

pub fn main() !void {
    const file_path = "../problems/test_problems.csv";
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var timer = try std.time.Timer.start();

    std.debug.print("Parsing problem CSV...\n", .{});
    const parse_start = timer.read();

    const problems = try psr.parseCSV(allocator, file_path);

    const parse_end = timer.read();

    std.debug.print("Solving problems...\n", .{});
    const solve_start = timer.read();

    defer {
        for (problems) |problem| {
            allocator.free(problem);
        }
        allocator.free(problems);
    }
    for (problems) |prob| {
        var board = try sdk.parse(prob);
        const done = try sdk.solve(&board);
        if (done) {
            continue;
        }
    }
    const solve_end = timer.read();

    const parse_time_ns = parse_end - parse_start;
    const solve_time_ns = solve_end - solve_start;
    const average_time_ns = solve_time_ns / problems.len;
    // Report results
    std.debug.print("\nBenchmark Results:\n", .{});
    std.debug.print("Total parsing time: {:.2} seconds\n", .{@as(f64, @floatFromInt(parse_time_ns)) / 1_000_000_000.0});
    std.debug.print("Total solving time: {:.2} seconds\n", .{@as(f64, @floatFromInt(solve_time_ns)) / 1_000_000_000.0});
    std.debug.print("Average solving time: {:.2} seconds\n", .{@as(f64, @floatFromInt(average_time_ns)) / 1_000_000_000.0});
}
