const std = @import("std");

pub fn parseCSV(allocator: std.mem.Allocator, file_path: []const u8) ![]const []const u8 {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var reader = buf_reader.reader();

    var line_buffer: [1024]u8 = undefined;

    var problems = std.ArrayList([]const u8).init(allocator);
    defer problems.deinit();

    while (try reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        if (line.len < 81) continue;

        const problem = try allocator.dupe(u8, line);
        try problems.append(problem);
    }
    return problems.toOwnedSlice();
}

test "test parseCSV" {
    const file_path = "../problems/test_problems.csv";
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const problems = try parseCSV(allocator, file_path);
    defer {
        for (problems) |problem| {
            allocator.free(problem);
        }
        allocator.free(problems);
    }
    try std.testing.expectEqual(std.mem.eql(u8, problems[0], "070000043040009610800634900094052000358460020000800530080070091902100005007040802"), true);
    try std.testing.expectEqual(std.mem.eql(u8, problems[1], "301086504046521070500000001400800002080347900009050038004090200008734090007208103"), true);
    try std.testing.expectEqual(std.mem.eql(u8, problems[3], "008317000004205109000040070327160904901450000045700800030001060872604000416070080"), true);
}
