import SwiftUI

struct MonthSelectorView: View {
    let dateText: String
    let onPrevious: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onPrevious) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }
            Text(dateText)
                .font(.headline)
            Button(action: onNext) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
    }
}
