import Foundation
import UIKit

// MARK: - Tabellen-Export (Excel, CSV, PDF)

/// Eine Tabelle für den Export: Blattname, Kopfzeile, Zeilen
struct ExportSheet {
    enum Cell {
        case text(String)
        case number(Double)
    }
    let name: String
    var header: [String]
    var rows: [[Cell]]
    /// relative Spaltenbreiten (Zeichen), optional
    var widths: [Double] = []
}

extension ExportSheet.Cell {
    static func num(_ v: Double?) -> ExportSheet.Cell { v.map { .number($0) } ?? .text("") }
    static func int(_ v: Int) -> ExportSheet.Cell { .number(Double(v)) }

    var csvText: String {
        switch self {
        case .text(let s): return s
        case .number(let v): return SheetExport.germanNumber(v)
        }
    }
}

enum SheetExport {
    static func germanNumber(_ v: Double) -> String {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.usesGroupingSeparator = false
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: v)) ?? String(v)
    }

    // MARK: CSV

    /// Semikolon-getrennt mit deutschem Komma, so öffnet Excel die Datei direkt richtig. Blätter stehen untereinander.
    static func csv(_ sheets: [ExportSheet]) -> String {
        var lines: [String] = []
        for (i, sheet) in sheets.enumerated() {
            if i > 0 { lines.append("") }
            lines.append(escape(sheet.name))
            lines.append(sheet.header.map(escape).joined(separator: ";"))
            for row in sheet.rows { lines.append(row.map { escape($0.csvText) }.joined(separator: ";")) }
        }
        // BOM, damit Excel Umlaute als UTF-8 erkennt
        return "\u{FEFF}" + lines.joined(separator: "\r\n") + "\r\n"
    }

    private static func escape(_ s: String) -> String {
        if s.contains(";") || s.contains("\"") || s.contains("\n") || s.contains("\r") {
            return "\"" + s.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        return s
    }

    // MARK: Excel (.xlsx)

    /// Echte Excel-Datei mit einem Blatt pro Tabelle (Office Open XML, ohne Fremdbibliothek)
    static func xlsx(_ sheets: [ExportSheet]) -> Data {
        var files: [(String, Data)] = []
        let overrides = sheets.indices.map {
            "<Override PartName=\"/xl/worksheets/sheet\($0 + 1).xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>"
        }.joined()
        files.append(("[Content_Types].xml", Data((xmlHead + """
        <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\
        <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\
        <Default Extension="xml" ContentType="application/xml"/>\
        <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>\
        <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>\
        \(overrides)</Types>
        """).utf8)))
        files.append(("_rels/.rels", Data((xmlHead + """
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\
        <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>\
        </Relationships>
        """).utf8)))
        var used = Set<String>()
        let sheetTags = sheets.enumerated().map { i, s -> String in
            var name = sheetName(s.name)
            while used.contains(name) { name = String(name.prefix(28)) + " \(i + 1)" }
            used.insert(name)
            return "<sheet name=\"\(xml(name))\" sheetId=\"\(i + 1)\" r:id=\"rId\(i + 1)\"/>"
        }.joined()
        files.append(("xl/workbook.xml", Data((xmlHead + """
        <workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" \
        xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">\
        <sheets>\(sheetTags)</sheets></workbook>
        """).utf8)))
        let rels = sheets.indices.map {
            "<Relationship Id=\"rId\($0 + 1)\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet\($0 + 1).xml\"/>"
        }.joined()
        files.append(("xl/_rels/workbook.xml.rels", Data((xmlHead + """
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\(rels)\
        <Relationship Id="rId\(sheets.count + 1)" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>\
        </Relationships>
        """).utf8)))
        files.append(("xl/styles.xml", Data((xmlHead + """
        <styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">\
        <fonts count="2"><font><sz val="11"/><name val="Calibri"/></font><font><b/><sz val="11"/><name val="Calibri"/></font></fonts>\
        <fills count="3"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill>\
        <fill><patternFill patternType="solid"><fgColor rgb="FFE8EEF7"/><bgColor indexed="64"/></patternFill></fill></fills>\
        <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>\
        <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>\
        <cellXfs count="3"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>\
        <xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1"/>\
        <xf numFmtId="4" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/></cellXfs>\
        <cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>\
        </styleSheet>
        """).utf8)))
        for (i, s) in sheets.enumerated() {
            files.append(("xl/worksheets/sheet\(i + 1).xml", Data(worksheet(s).utf8)))
        }
        return ZipWriter.archive(files)
    }

    private static let xmlHead = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"

    private static func worksheet(_ s: ExportSheet) -> String {
        var out = xmlHead + "<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">"
        out += "<sheetViews><sheetView workbookViewId=\"0\"><pane ySplit=\"1\" topLeftCell=\"A2\" activePane=\"bottomLeft\" state=\"frozen\"/></sheetView></sheetViews>"
        let count = max(s.header.count, s.rows.map(\.count).max() ?? 0)
        if count > 0 {
            out += "<cols>"
            for c in 0..<count {
                let w = c < s.widths.count ? s.widths[c] : autoWidth(s, column: c)
                out += "<col min=\"\(c + 1)\" max=\"\(c + 1)\" width=\"\(String(format: "%.1f", w))\" customWidth=\"1\"/>"
            }
            out += "</cols>"
        }
        out += "<sheetData>"
        out += row(1, s.header.map { ExportSheet.Cell.text($0) }, style: 1)
        for (i, r) in s.rows.enumerated() { out += row(i + 2, r, style: 0) }
        out += "</sheetData></worksheet>"
        return out
    }

    private static func autoWidth(_ s: ExportSheet, column c: Int) -> Double {
        var w = c < s.header.count ? s.header[c].count : 6
        for r in s.rows.prefix(200) where c < r.count { w = max(w, r[c].csvText.count) }
        return Double(min(60, max(8, w + 2)))
    }

    private static func row(_ n: Int, _ cells: [ExportSheet.Cell], style: Int) -> String {
        var out = "<row r=\"\(n)\">"
        for (i, cell) in cells.enumerated() {
            let ref = column(i) + String(n)
            switch cell {
            case .text(let t):
                if t.isEmpty { continue }
                out += "<c r=\"\(ref)\" t=\"inlineStr\"\(style > 0 ? " s=\"\(style)\"" : "")><is><t xml:space=\"preserve\">\(xml(t))</t></is></c>"
            case .number(let v):
                guard v.isFinite else { continue }
                out += "<c r=\"\(ref)\"\(style > 0 ? " s=\"\(style)\"" : "")><v>\(String(format: "%.4f", v))</v></c>"
            }
        }
        return out + "</row>"
    }

    /// Spaltenbuchstaben: 0 → A, 25 → Z, 26 → AA
    static func column(_ index: Int) -> String {
        var n = index + 1
        var s = ""
        while n > 0 {
            let r = (n - 1) % 26
            s = String(Character(UnicodeScalar(UInt8(65 + r)))) + s
            n = (n - 1) / 26
        }
        return s
    }

    private static func sheetName(_ s: String) -> String {
        let bad: Set<Character> = ["[", "]", ":", "*", "?", "/", "\\"]
        let clean = String(s.filter { !bad.contains($0) }.prefix(31))
        return clean.isEmpty ? "Tabelle" : clean
    }

    static func xml(_ s: String) -> String {
        var out = ""
        for ch in s.unicodeScalars {
            switch ch {
            case "&": out += "&amp;"
            case "<": out += "&lt;"
            case ">": out += "&gt;"
            case "\"": out += "&quot;"
            default:
                // Steuerzeichen sind in XML nicht erlaubt (außer Tab und Zeilenumbruch)
                if ch.value < 0x20 && ch != "\t" && ch != "\n" && ch != "\r" { continue }
                out.unicodeScalars.append(ch)
            }
        }
        return out
    }

    /// Schreibt Daten in eine temporäre Datei zum Teilen
    static func write(_ data: Data, name: String) -> URL? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        try? FileManager.default.removeItem(at: url)
        return (try? data.write(to: url, options: .atomic)) != nil ? url : nil
    }
}

// MARK: - ZIP (nur gespeichert, ohne Kompression – reicht für Excel)

enum ZipWriter {
    static func archive(_ files: [(String, Data)]) -> Data {
        var out = Data()
        var central = Data()
        let (time, date) = dosDateTime(Date())
        for (name, data) in files {
            let nameData = Data(name.utf8)
            let crc = crc32(data)
            let offset = UInt32(out.count)
            // lokaler Dateikopf
            out.appendLE(UInt32(0x04034b50))
            out.appendLE(UInt16(20))            // benötigte Version
            out.appendLE(UInt16(0x0800))        // Flag: Namen in UTF-8
            out.appendLE(UInt16(0))             // Methode: gespeichert
            out.appendLE(time)
            out.appendLE(date)
            out.appendLE(crc)
            out.appendLE(UInt32(data.count))
            out.appendLE(UInt32(data.count))
            out.appendLE(UInt16(nameData.count))
            out.appendLE(UInt16(0))
            out.append(nameData)
            out.append(data)
            // Eintrag im Inhaltsverzeichnis
            central.appendLE(UInt32(0x02014b50))
            central.appendLE(UInt16(20))        // erstellt mit
            central.appendLE(UInt16(20))
            central.appendLE(UInt16(0x0800))
            central.appendLE(UInt16(0))
            central.appendLE(time)
            central.appendLE(date)
            central.appendLE(crc)
            central.appendLE(UInt32(data.count))
            central.appendLE(UInt32(data.count))
            central.appendLE(UInt16(nameData.count))
            central.appendLE(UInt16(0))         // Extra
            central.appendLE(UInt16(0))         // Kommentar
            central.appendLE(UInt16(0))         // Datenträger
            central.appendLE(UInt16(0))         // interne Attribute
            central.appendLE(UInt32(0))         // externe Attribute
            central.appendLE(offset)
            central.append(nameData)
        }
        let centralOffset = UInt32(out.count)
        out.append(central)
        out.appendLE(UInt32(0x06054b50))
        out.appendLE(UInt16(0))
        out.appendLE(UInt16(0))
        out.appendLE(UInt16(files.count))
        out.appendLE(UInt16(files.count))
        out.appendLE(UInt32(central.count))
        out.appendLE(centralOffset)
        out.appendLE(UInt16(0))
        return out
    }

    private static let table: [UInt32] = (0..<256).map { i -> UInt32 in
        var c = UInt32(i)
        for _ in 0..<8 { c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1 }
        return c
    }

    static func crc32(_ data: Data) -> UInt32 {
        var c: UInt32 = 0xFFFFFFFF
        for b in data { c = table[Int((c ^ UInt32(b)) & 0xFF)] ^ (c >> 8) }
        return c ^ 0xFFFFFFFF
    }

    private static func dosDateTime(_ d: Date) -> (UInt16, UInt16) {
        let c = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .hour, .minute, .second], from: d)
        let time = UInt16(((c.hour ?? 0) << 11) | ((c.minute ?? 0) << 5) | ((c.second ?? 0) / 2))
        let date = UInt16((max(0, (c.year ?? 1980) - 1980) << 9) | ((c.month ?? 1) << 5) | (c.day ?? 1))
        return (time, date)
    }
}

private extension Data {
    mutating func appendLE(_ v: UInt16) {
        append(UInt8(v & 0xFF))
        append(UInt8(v >> 8))
    }
    mutating func appendLE(_ v: UInt32) {
        for shift in stride(from: 0, to: 32, by: 8) { append(UInt8((v >> UInt32(shift)) & 0xFF)) }
    }
}

// MARK: - PDF

/// Einfacher Bericht als PDF (A4, mehrseitig): Überschriften, Absätze, Aufzählungen und Tabellen
enum ReportPDF {
    enum Block {
        case heading(String)
        case paragraph(String)
        case bullets([String])
        case table(ExportSheet)
    }

    static func make(title: String, subtitle: String, blocks: [Block]) -> Data {
        let page = CGRect(x: 0, y: 0, width: 595, height: 842)
        let margin: CGFloat = 40
        let width = page.width - 2 * margin
        let renderer = UIGraphicsPDFRenderer(bounds: page)
        let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 22), .foregroundColor: UIColor.black]
        let subAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.darkGray]
        let headAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.black]
        let bodyAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor.black]
        let footAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 8), .foregroundColor: UIColor.gray]
        let clip = NSMutableParagraphStyle()
        clip.lineBreakMode = .byTruncatingTail
        let cellAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 8.5), .foregroundColor: UIColor.black, .paragraphStyle: clip]
        let cellHeadAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 8.5), .foregroundColor: UIColor.black, .paragraphStyle: clip]

        return renderer.pdfData { ctx in
            var y: CGFloat = margin
            var pageNumber = 0

            func newPage() {
                ctx.beginPage()
                pageNumber += 1
                y = margin
                let foot = "Bodyformance (BFC) · \(title) · Seite \(pageNumber)" as NSString
                foot.draw(in: CGRect(x: margin, y: page.height - 28, width: width, height: 12), withAttributes: footAttr)
            }
            func height(_ s: String, _ attr: [NSAttributedString.Key: Any], _ w: CGFloat) -> CGFloat {
                ceil((s as NSString).boundingRect(with: CGSize(width: w, height: .greatestFiniteMagnitude),
                                                  options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                  attributes: attr, context: nil).height)
            }
            func ensure(_ h: CGFloat) {
                if y + h > page.height - margin - 16 { newPage() }
            }
            func text(_ s: String, _ attr: [NSAttributedString.Key: Any], indent: CGFloat = 0, after: CGFloat = 4) {
                let h = height(s, attr, width - indent)
                ensure(h)
                (s as NSString).draw(in: CGRect(x: margin + indent, y: y, width: width - indent, height: h), withAttributes: attr)
                y += h + after
            }

            newPage()
            text(title, titleAttr, after: 2)
            text(subtitle, subAttr, after: 14)

            for block in blocks {
                switch block {
                case .heading(let s):
                    ensure(40)
                    y += 6
                    text(s, headAttr, after: 6)
                case .paragraph(let s):
                    text(s, bodyAttr, after: 6)
                case .bullets(let items):
                    for item in items { text("•  " + item, bodyAttr, indent: 4, after: 3) }
                    y += 4
                case .table(let sheet):
                    let cols = max(sheet.header.count, 1)
                    let weights: [Double] = (0..<cols).map { c in
                        if c < sheet.widths.count { return sheet.widths[c] }
                        var w = sheet.header[c].count
                        for r in sheet.rows.prefix(100) where c < r.count { w = max(w, r[c].csvText.count) }
                        return Double(min(34, max(5, w)))
                    }
                    let total = weights.reduce(0, +)
                    let colW = weights.map { CGFloat($0 / total) * width }
                    let rowH: CGFloat = 14
                    func drawRow(_ cells: [String], bold: Bool, shade: Bool) {
                        ensure(rowH)
                        if shade {
                            UIColor(red: 0.91, green: 0.93, blue: 0.97, alpha: 1).setFill()
                            UIRectFill(CGRect(x: margin, y: y, width: width, height: rowH))
                        }
                        var x = margin
                        for (i, c) in cells.prefix(cols).enumerated() {
                            (c as NSString).draw(in: CGRect(x: x + 2, y: y + 2, width: colW[i] - 4, height: rowH - 2),
                                                 withAttributes: bold ? cellHeadAttr : cellAttr)
                            x += colW[i]
                        }
                        y += rowH
                    }
                    ensure(rowH * 3)
                    drawRow(sheet.header, bold: true, shade: true)
                    for r in sheet.rows {
                        // Kopfzeile auf jeder neuen Seite wiederholen
                        if y + rowH > page.height - margin - 16 {
                            newPage()
                            drawRow(sheet.header, bold: true, shade: true)
                        }
                        drawRow(r.map(\.csvText), bold: false, shade: false)
                    }
                    y += 10
                }
            }
        }
    }
}
