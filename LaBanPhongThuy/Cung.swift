import SwiftUI

/// Hai nhóm hướng theo phong thủy Bát trạch.
enum NhomTrach {
    case dong, tay

    var ten: String { self == .dong ? "Đông Tứ Trạch" : "Tây Tứ Trạch" }

    var cacHuong: String {
        self == .dong ? "Bắc • Đông • Nam • Đông Nam" : "Tây • Tây Bắc • Tây Nam • Đông Bắc"
    }

    var cacQue: String {
        self == .dong ? "Khảm • Chấn • Ly • Tốn" : "Đoài • Càn • Khôn • Cấn"
    }

    var mau: Color {
        self == .dong ? Color(red: 0.11, green: 0.43, blue: 0.27) : Color(red: 0.73, green: 0.29, blue: 0.18)
    }

    var mauNhat: Color {
        self == .dong ? Color(red: 0.86, green: 0.94, blue: 0.87) : Color(red: 0.99, green: 0.89, blue: 0.84)
    }
}

/// Một trong 8 cung (quẻ) của Bát quái hậu thiên, mỗi cung rộng 45°.
struct Cung: Identifiable, Equatable {
    let id: Int          // 0 = Bắc, tăng theo chiều kim đồng hồ
    let huong: String
    let vietTat: String
    let que: String
    let kyHieu: String
    let nguHanh: String

    var nhom: NhomTrach { [0, 2, 3, 4].contains(id) ? .dong : .tay }
    var gocGiua: Double { Double(id) * 45 }
    var doiDien: Cung { Cung.tatCa[(id + 4) % 8] }

    static let tatCa: [Cung] = [
        Cung(id: 0, huong: "Bắc",      vietTat: "B",  que: "Khảm", kyHieu: "☵", nguHanh: "Thủy"),
        Cung(id: 1, huong: "Đông Bắc", vietTat: "ĐB", que: "Cấn",  kyHieu: "☶", nguHanh: "Thổ"),
        Cung(id: 2, huong: "Đông",     vietTat: "Đ",  que: "Chấn", kyHieu: "☳", nguHanh: "Mộc"),
        Cung(id: 3, huong: "Đông Nam", vietTat: "ĐN", que: "Tốn",  kyHieu: "☴", nguHanh: "Mộc"),
        Cung(id: 4, huong: "Nam",      vietTat: "N",  que: "Ly",   kyHieu: "☲", nguHanh: "Hỏa"),
        Cung(id: 5, huong: "Tây Nam",  vietTat: "TN", que: "Khôn", kyHieu: "☷", nguHanh: "Thổ"),
        Cung(id: 6, huong: "Tây",      vietTat: "T",  que: "Đoài", kyHieu: "☱", nguHanh: "Kim"),
        Cung(id: 7, huong: "Tây Bắc",  vietTat: "TB", que: "Càn",  kyHieu: "☰", nguHanh: "Kim"),
    ]

    static func tu(goc: Double) -> Cung {
        let d = chuanHoa(goc)
        return tatCa[Int((d + 22.5) / 45) % 8]
    }
}

/// 24 sơn, mỗi sơn rộng 15°, bắt đầu từ Tý (chính Bắc).
enum Son {
    static let ten = [
        "Tý", "Quý", "Sửu", "Cấn", "Dần", "Giáp", "Mão", "Ất",
        "Thìn", "Tốn", "Tỵ", "Bính", "Ngọ", "Đinh", "Mùi", "Khôn",
        "Thân", "Canh", "Dậu", "Tân", "Tuất", "Càn", "Hợi", "Nhâm",
    ]

    static func tu(goc: Double) -> String {
        ten[Int((chuanHoa(goc) + 7.5) / 15) % 24]
    }
}

func chuanHoa(_ goc: Double) -> Double {
    let d = goc.truncatingRemainder(dividingBy: 360)
    return d < 0 ? d + 360 : d
}
