const std = @import("std");
const mvzr = @import("mvzr");

const MAL_REGEX = mvzr.compile("[\\(\\)[\\]{}]|\"(\\\\.|[^\\\\\"])*\"|;.*|[^\\s\\[\\]{}('\"`,;]+").?;

const Reader = struct {
    position: u32,
    string: []const u8,
    tokens: [][]const u8,

    pub fn init(string: []const u8, tokens: [][]const u8) Reader {
        return Reader{
            .position = 0,
            .string = string,
            .tokens = tokens,
        };
    }

    pub fn next(self: *Reader) ?[]const u8 {
        if (self.position >= self.tokens.len) {
            return null;
        }

        const token = self.tokens[self.position];
        self.position += 1;
        return token;
    }

    pub fn peek(self: *Reader) ?[]const u8 {
        if (self.position >= self.tokens.len) {
            return null;
        }

        return self.tokens[self.position];
    }
};

pub fn read_str(allocator: std.mem.Allocator, string: []const u8) !Reader {
    const tokens = try tokenize(allocator, string);
    return Reader.init(string, tokens);
}

pub fn tokenize(allocator: std.mem.Allocator, string: []const u8) ![][]const u8 {
    var tokens: std.ArrayListUnmanaged([]const u8) = .empty;

    // If an error happens (OOM), free what we allocated
    errdefer tokens.deinit(allocator);

    var iter = MAL_REGEX.iterator(string);

    while (iter.next()) |match| {
        const token = match.slice;
        if (token.len == 0 or token[0] == ';') {
            continue;
        }
        try tokens.append(allocator, token);
    }

    // Returns the memory to the caller
    return tokens.toOwnedSlice(allocator);
}
