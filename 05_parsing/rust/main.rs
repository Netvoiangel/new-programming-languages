use std::collections::BTreeMap;

fn from_hex(b: u8) -> Option<u8> {
    match b {
        b'0'..=b'9' => Some(b - b'0'),
        b'a'..=b'f' => Some(b - b'a' + 10),
        b'A'..=b'F' => Some(b - b'A' + 10),
        _ => None,
    }
}

fn percent_decode(s: &str) -> String {
    let bytes = s.as_bytes();
    let mut out: Vec<u8> = Vec::with_capacity(bytes.len());
    let mut i = 0;
    while i < bytes.len() {
        match bytes[i] {
            b'+' => {
                out.push(b' ');
                i += 1;
            }
            b'%' if i + 2 < bytes.len() => {
                if let (Some(h1), Some(h2)) = (from_hex(bytes[i + 1]), from_hex(bytes[i + 2])) {
                    out.push((h1 << 4) | h2);
                    i += 3;
                } else {
                    out.push(bytes[i]);
                    i += 1;
                }
            }
            c => {
                out.push(c);
                i += 1;
            }
        }
    }
    String::from_utf8_lossy(&out).to_string()
}

fn json_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for ch in s.chars() {
        match ch {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if c.is_control() => out.push_str(&format!("\\u{:04x}", c as u32)),
            c => out.push(c),
        }
    }
    out
}

fn parse_query(q: &str) -> BTreeMap<String, String> {
    let mut m = BTreeMap::new();
    for part in q.split('&').filter(|p| !p.is_empty()) {
        let (k, v) = match part.split_once('=') {
            Some((a, b)) => (a, b),
            None => (part, ""),
        };
        m.insert(percent_decode(k), percent_decode(v));
    }
    m
}

fn main() {
    let q = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "name=Alice&city=New%20York&age=30".to_string());

    let m = parse_query(&q);

    // Печатаем как JSON-объект (вручную, без зависимостей).
    print!("{{");
    let mut first = true;
    for (k, v) in m {
        if !first {
            print!(",");
        }
        first = false;
        print!("\"{}\":\"{}\"", json_escape(&k), json_escape(&v));
    }
    println!("}}");
}


