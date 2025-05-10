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

