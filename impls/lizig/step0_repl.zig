const std = @import("std");

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
        } else {
            break;
        }
    }
}
