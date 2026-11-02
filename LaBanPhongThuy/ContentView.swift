import SwiftUI

struct ContentView: View {
    @StateObject private var compass = CompassManager()
    @Environment(\.scenePhase) private var scenePhase

    @State private var khoa = false
    @State private var gocKhoa: Double = 0
    @State private var gocXoay: Double = 0   // góc xoay liên tục, tránh giật khi qua 0°/360°

    private var goc: Double { khoa ? gocKhoa : compass.heading }
    private var cung: Cung { Cung.tu(goc: goc) }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Text("LA BÀN BÁT TRẠCH")
                    .font(.system(.title2, design: .serif).weight(.heavy))
                    .padding(.top, 8)

                if !compass.coLaBan {
                    Label("Thiết bị này không có la bàn.", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                }

                ZStack(alignment: .top) {
                    CompassDial(cungHienTai: cung)
                        .rotationEffect(.degrees(-gocXoay))
                        .animation(.easeOut(duration: 0.25), value: gocXoay)
                        .padding(.top, 14)

                    // Kim chỉ hướng cố định ở đầu điện thoại
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(cung.nhom.mau)
                }
                .padding(.horizontal, 12)

                theThongTin
                nutKhoa

                Text("Đặt điện thoại nằm ngang, đầu máy hướng ra cửa chính khi bạn đứng trong nhà nhìn ra. Tránh xa vật kim loại và thiết bị điện.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if compass.accuracy < 0 || compass.accuracy > 25 {
                    Label("Độ chính xác thấp – hãy xoay điện thoại theo hình số 8 để hiệu chỉnh.",
                          systemImage: "arrow.triangle.2.circlepath")
                        .font(.footnote)
                        .foregroundStyle(.orange)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .sensoryFeedback(.selection, trigger: cung.id)
        .onAppear { compass.start() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { compass.start() } else { compass.stop() }
        }
        .onChange(of: goc) { _, moi in
            var delta = moi - chuanHoa(gocXoay)
            if delta > 180 { delta -= 360 }
            if delta < -180 { delta += 360 }
            gocXoay += delta
        }
    }

    private var theThongTin: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(cung.huong)
                    .font(.system(size: 34, weight: .bold, design: .serif))
                Spacer()
                Text("\(Int(goc.rounded()) % 360)°")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .monospacedDigit()
            }

            HStack {
                Text("Cung \(cung.que) \(cung.kyHieu)")
                    .font(.title3.weight(.semibold))
                Spacer()
                Text("Hành \(cung.nguHanh)")
                    .foregroundStyle(.secondary)
            }

            Text(cung.nhom.ten.uppercased())
                .font(.system(.title3, design: .serif).weight(.heavy))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(cung.nhom.mau, in: RoundedRectangle(cornerRadius: 12))

            VStack(spacing: 4) {
                Text(cung.nhom.cacHuong).font(.subheadline.weight(.semibold))
                Text(cung.nhom.cacQue).font(.subheadline.italic())
            }
            .foregroundStyle(cung.nhom.mau)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(cung.nhom.mauNhat, in: RoundedRectangle(cornerRadius: 12))

            Divider()

            HStack {
                dong("Sơn (24 sơn)", Son.tu(goc: goc))
                Spacer()
                dong("Tọa (lưng nhà)", "\(cung.doiDien.huong) – \(cung.doiDien.que)")
            }

            if !compass.dungBacThat && compass.coLaBan {
                Text("Đang dùng Bắc từ. Cho phép truy cập vị trí để dùng Bắc thật.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal)
    }

    private func dong(_ nhan: String, _ giaTri: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(nhan).font(.caption).foregroundStyle(.secondary)
            Text(giaTri).font(.headline)
        }
    }

    private var nutKhoa: some View {
        Button {
            if !khoa { gocKhoa = compass.heading }
            khoa.toggle()
        } label: {
            Label(khoa ? "Bỏ khóa hướng" : "Khóa hướng", systemImage: khoa ? "lock.open.fill" : "lock.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .tint(khoa ? .gray : cung.nhom.mau)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
