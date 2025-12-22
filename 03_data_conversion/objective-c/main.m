#import <Foundation/Foundation.h>

static NSString *ReadAllStdin(void) {
  NSFileHandle *in = [NSFileHandle fileHandleWithStandardInput];
  NSData *data = [in readDataToEndOfFile];
  NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  return s ?: @"";
}

static NSArray<NSString *> *SplitCsvLine(NSString *line) {
  NSMutableArray<NSString *> *out = [NSMutableArray array];
  NSMutableString *cur = [NSMutableString string];
  BOOL inQuotes = NO;

  NSUInteger i = 0;
  while (i < line.length) {
    unichar c = [line characterAtIndex:i];
    if (inQuotes) {
      if (c == '"') {
        BOOL nextIsQuote = (i + 1 < line.length) && ([line characterAtIndex:i + 1] == '"');
        if (nextIsQuote) {
          [cur appendString:@"\""];
          i += 1;
        } else {
          inQuotes = NO;
        }
      } else {
        [cur appendFormat:@"%C", c];
      }
    } else {
      if (c == ',') {
        [out addObject:[cur copy]];
        [cur setString:@""];
      } else if (c == '"') {
        inQuotes = YES;
      } else {
        [cur appendFormat:@"%C", c];
      }
    }
    i += 1;
  }
  [out addObject:[cur copy]];
  return out;
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSString *sample =
      @"name,age,city\n"
       "Alice,30,Paris\n"
       "Bob,25,\"New York\"\n";

    NSString *input = ReadAllStdin();
    if ([[input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
      input = sample;
    }

    NSArray<NSString *> *lines =
      [[input componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]
        filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *s, NSDictionary *_) {
          return s.length > 0;
        }]];

    if (lines.count == 0) return 0;

    NSArray<NSString *> *headers = SplitCsvLine(lines[0]);
    NSMutableArray<NSDictionary<NSString *, NSString *> *> *arr = [NSMutableArray array];

    for (NSUInteger idx = 1; idx < lines.count; idx++) {
      NSArray<NSString *> *cols = SplitCsvLine(lines[idx]);
      NSMutableDictionary<NSString *, NSString *> *obj = [NSMutableDictionary dictionary];
      NSUInteger m = MIN(headers.count, cols.count);
      for (NSUInteger j = 0; j < m; j++) {
        obj[headers[j]] = cols[j];
      }
      [arr addObject:obj];
    }

    NSError *err = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&err];
    if (!json) {
      fprintf(stderr, "JSON error: %s\n", err.localizedDescription.UTF8String);
      return 1;
    }
    fwrite(json.bytes, 1, json.length, stdout);
    fputc('\n', stdout);
  }
  return 0;
}


