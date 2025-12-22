import Foundation

func readAllStdin() -> String {
    var data = Data()
    while true {
        let chunk = FileHandle.standardInput.availableData
        if chunk.isEmpty { break }
        data.append(chunk)
    }
    return String(data: data, encoding: .utf8) ?? ""
}

func splitCsvLine(_ line: String) -> [String] {
    var out: [String] = []
    var cur = ""
    var inQuotes = false
    var i = line.startIndex
    while i < line.endIndex {
        let c = line[i]
        if inQuotes {
            if c == "\"" {
                let next = line.index(after: i)
                if next < line.endIndex, line[next] == "\"" {
                    cur.append("\"")
                    i = next
                } else {
                    inQuotes = false
                }
            } else {
                cur.append(c)
            }
        } else {
            if c == "," {
                out.append(cur)
                cur = ""
            } else if c == "\"" {
                inQuotes = true
            } else {
                cur.append(c)
            }
        }
        i = line.index(after: i)
    }
    out.append(cur)
    return out
}

let sample = """
name,age,city
Alice,30,Paris
Bob,25,"New York"
"""

let input = {
    let s = readAllStdin()
    return s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? sample : s
}()

let lines = input.split(whereSeparator: \.isNewline).map(String.init)
if lines.isEmpty {
    exit(0)
}

let headers = splitCsvLine(lines[0])
var arr: [[String: String]] = []
for line in lines.dropFirst() {
    let cols = splitCsvLine(line)
    var obj: [String: String] = [:]
    for (k, v) in zip(headers, cols) {
        obj[k] = v
    }
    arr.append(obj)
}

let json = try JSONSerialization.data(withJSONObject: arr, options: [.prettyPrinted, .sortedKeys])
FileHandle.standardOutput.write(json)
FileHandle.standardOutput.write("\n".data(using: .utf8)!)


