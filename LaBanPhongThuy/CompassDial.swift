import SwiftUI

/// Mặt la bàn: 8 cung tô màu theo Đông/Tây tứ trạch, vạch chia độ và vòng 24 sơn.
struct CompassDial: View {
    var cungHienTai: Cung

    var body: some View {
        GeometryReader { geo in
            let r = min(geo.size.width, geo.size.height) / 2
            ZStack {
                Circle().fill(Color(.systemBackground))
                Circle().stroke(Color.primary.opacity(0.25), lineWidth: 1)

                // 8 cung
                ForEach(Cung.tatCa) { cung in
                    let dangChon = cung == cungHienTai
                    Sector(tamGoc: cung.gocGiua, rong: 45, trongTiLe: 0.40, ngoaiTiLe: 0.76)
                        .fill(dangChon ? cung.nhom.mau.opacity(0.9) : cung.nhom.mauNhat)
                    Sector(tamGoc: cung.gocGiua, rong: 45, trongTiLe: 0.40, ngoaiTiLe: 0.76)
                        .stroke(Color(.systemBackground), lineWidth: 2)

                    VStack(spacing: 1) {
                        Text(cung.kyHieu).font(.system(size: r * 0.12))
                        Text(cung.que).font(.system(size: r * 0.085, weight: .bold))
                        Text(cung.vietTat).font(.system(size: r * 0.065, weight: .semibold))
                    }
                    .foregroundStyle(dangChon ? Color.white : cung.nhom.mau)
                    .offset(y: -r * 0.58)
                    .rotationEffect(.degrees(cung.gocGiua))
                }

                // Vạch chia độ
                Canvas { ctx, size in
                    let c = CGPoint(x: size.width / 2, y: size.height / 2)
                    for deg in stride(from: 0, to: 360, by: 3) {
                        let dai = deg % 45 == 0 ? 0.08 : (deg % 15 == 0 ? 0.055 : 0.03)
                        let a = Double(deg - 90) * .pi / 180
                        let r1 = r * 0.985, r2 = r * (0.985 - dai)
                        var p = Path()
                        p.move(to: CGPoint(x: c.x + cos(a) * r1, y: c.y + sin(a) * r1))
                        p.addLine(to: CGPoint(x: c.x + cos(a) * r2, y: c.y + sin(a) * r2))
                        ctx.stroke(p, with: .color(deg == 0 ? Color.red : Color.primary.opacity(0.6)),
                                   lineWidth: deg % 15 == 0 ? 1.5 : 0.8)
                    }
                }

                // Vòng 24 sơn
                ForEach(0..<24, id: \.self) { i in
                    Text(Son.ten[i])
                        .font(.system(size: r * 0.055, weight: .medium))
                        .foregroundStyle(i == 0 ? Color.red : Color.secondary)
                        .offset(y: -r * 0.84)
                        .rotationEffect(.degrees(Double(i) * 15))
                }

                // Tâm
                Circle().fill(Color(.secondarySystemBackground)).frame(width: r * 0.78, height: r * 0.78)
                Text("BẮC")
                    .font(.system(size: r * 0.07, weight: .heavy))
                    .foregroundStyle(.red)
                    .offset(y: -r * 0.30)
                Image(systemName: "location.north.fill")
                    .font(.system(size: r * 0.16))
                    .foregroundStyle(.red)
                    .offset(y: -r * 0.12)
            }
            .frame(width: r * 2, height: r * 2)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

/// Hình quạt vành khuyên. Góc tính theo la bàn: 0° = Bắc (lên trên), tăng theo chiều kim đồng hồ.
struct Sector: Shape {
    var tamGoc: Double
    var rong: Double
    var trongTiLe: CGFloat
    var ngoaiTiLe: CGFloat

    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        let bd = Angle.degrees(tamGoc - rong / 2 - 90)
        let kt = Angle.degrees(tamGoc + rong / 2 - 90)
        var p = Path()
        p.addArc(center: c, radius: r * ngoaiTiLe, startAngle: bd, endAngle: kt, clockwise: false)
        p.addArc(center: c, radius: r * trongTiLe, startAngle: kt, endAngle: bd, clockwise: true)
        p.closeSubpath()
        return p
    }
}
