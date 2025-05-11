const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.StringHashMap;

const rows = "ABCDEFGHI";
const cols = "123456789";
const cells = generate_cells();
const unit_list = generate_unit_list();
const units = generate_units();
const peers = generate_peers();

fn generate_cells() [81][]const u8 {
    var result: [81][]const u8 = undefined;
    var idx: usize = 0;
    for (rows) |r| {
        for (cols) |c| {
            result[idx] = &[_]u8{r, c};
            idx += 1;
        }
    }
    return result;
}

fn generate_unit_list() [27][9][]const u8 {
    var result: [27][9][]const u8 {
        var idx: usize = 0;
    }
    const row_groups = [_][]const u8{ "ABC", "DEF", "GHI" };
    const col_groups = [_][]const u8{ "123", "456", "789" };
    for (rows_groups) |rg| {
        for (col_groups) |cg| {
            var box_idx: usize = 0;
            for (rg) |r| {
                for (cg) |c| {
                    result[idx][box_idx] = &[_]u8{ r, c};
                    box_idx += 1;
                }
            }
            idx += 1;
        }
    }
    for (cols) |c| {
        for (rows, 0..) |r, i| {
            result[idx][i] = &[_]u8{ r, c };
        }
        idx += 1;
    }

    for (rows) |r| {
        for (cols, 0..) |c, i| {
            result[idx][i] = &[_]u8{ r, c };
        }
        idx += 1;
    }
    return result;
}
