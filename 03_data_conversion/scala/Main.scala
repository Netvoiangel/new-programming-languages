import scala.io.Source

object Main {
  private def readAllStdin(): String =
    Source.stdin.getLines().mkString("\n")

  private def splitCsvLine(line: String): List[String] = {
    // Минималистичный парсер CSV: поддерживает кавычки и экранирование "" внутри кавычек.
    val out = scala.collection.mutable.ListBuffer.empty[String]
    val sb = new StringBuilder
    var i = 0
    var inQuotes = false
    while (i < line.length) {
      val c = line.charAt(i)
      if (inQuotes) {
        if (c == '"') {
          val nextIsQuote = i + 1 < line.length && line.charAt(i + 1) == '"'
          if (nextIsQuote) {
            sb.append('"')
            i += 1
          } else {
            inQuotes = false
          }
        } else {
          sb.append(c)
        }
      } else {
        c match {
          case ',' =>
            out += sb.result()
            sb.clear()
          case '"' =>
            inQuotes = true
          case _ =>
            sb.append(c)
        }
      }
      i += 1
    }
    out += sb.result()
    out.toList
  }

  private def jsonEscape(s: String): String =
    s.flatMap {
      case '"'  => "\\\""
      case '\\' => "\\\\"
      case '\b' => "\\b"
      case '\f' => "\\f"
      case '\n' => "\\n"
      case '\r' => "\\r"
      case '\t' => "\\t"
      case c if c.isControl => f"\\u${c.toInt}%04x"
      case c => c.toString
    }

  private def toJsonArray(headers: List[String], rows: List[List[String]]): String = {
    val objs = rows.map { cols =>
      val pairs = headers.zipAll(cols, "", "").map { case (k, v) =>
        s""""${jsonEscape(k)}":"${jsonEscape(v)}""""
      }
      pairs.mkString("{", ",", "}")
    }
    objs.mkString("[", ",", "]")
  }

  def main(args: Array[String]): Unit = {
    val sample =
      """name,age,city
        |Alice,30,Paris
        |Bob,25,"New York"
        |""".stripMargin.trim

    val input = {
      val s = readAllStdin()
      if (s.trim.nonEmpty) s else sample
    }

    val lines = input.split("\n").toList.filter(_.nonEmpty)
    val headers = splitCsvLine(lines.head)
    val rows = lines.tail.map(splitCsvLine)

    println(toJsonArray(headers, rows))
  }
}


