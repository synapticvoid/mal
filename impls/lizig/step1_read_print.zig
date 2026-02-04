const std = @import("std");
const reader_mod = @import("reader.zig");

pub fn READ(line: []const u8) []const u8 {
    return line;
}

pub fn EVAL(ast: []const u8) []const u8 {
    return ast;
}

pub fn PRINT(exp: []const u8) []const u8 {
    return exp;
}

pub fn rep(line: []const u8) []const u8 {
    return PRINT(EVAL(READ(line)));
}

pub fn main() !void {
    // Initialize the allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var read_buffer: [1024]u8 = undefined;
    var write_buffer: [1024]u8 = undefined;

    var stdin = std.fs.File.stdin().reader(&read_buffer);
    var stdout = std.fs.File.stdout().writer(&write_buffer);

    while (true) {
        try stdout.interface.print("user> ", .{});
        try stdout.interface.flush();

        if (stdin.interface.takeDelimiter('\n') catch null) |line| {
            // Trim the \r for Windows users
            const input = std.mem.trimRight(u8, line, "\r");
            try stdout.interface.print("{s}\n", .{rep(input)});
            try stdout.interface.flush();

            const reader = try reader_mod.read_str(allocator, input);
            defer allocator.free(reader.tokens);

            std.debug.print("Tokens: ", .{});
            for (reader.tokens) |t| std.debug.print("[{s}] ", .{t});
            std.debug.print("\n", .{});
        } else {
            break;
        }
    }
}
