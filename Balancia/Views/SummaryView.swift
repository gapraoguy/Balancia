import SwiftUI
import Charts

struct SummaryView: View {
    @EnvironmentObject var listViewModel: EntryListViewModel
    @StateObject private var viewModel = SummaryViewModel()

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    viewModel.moveMonth(by: -1)
                    viewModel.calculate(from: listViewModel.entries)
                }) {
                    Image(systemName: "chevron.left")
                }
                Text(viewModel.formattedMonth)
                    .font(.headline)
                Button(action: {
                    viewModel.moveMonth(by: 1)
                    viewModel.calculate(from: listViewModel.entries)
                }) {
                    Image(systemName: "chevron.right")
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("収入合計").font(.subheadline)
                    Text(viewModel.formattedTotalIncome).font(.title3).foregroundColor(.green)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("支出合計").font(.subheadline)
                    Text(viewModel.formattedTotalExpense).font(.title3).foregroundColor(.red)
                }
            }

            HStack {
                Text("差額").font(.subheadline)
                Spacer()
                Text(viewModel.formattedNetBalance)
                    .font(.title3)
                    .foregroundColor(viewModel.netBalance > 0 ? .green : viewModel.netBalance < 0 ? .red : .gray)
            }
            .padding()

            if !viewModel.categorySummaries.isEmpty {
                Text("カテゴリ別支出").font(.headline)

                Chart(viewModel.categorySummaries) { item in
                    SectorMark(
                        angle: .value("Amount", item.amount),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("カテゴリ", item.categoryName))
                }
                .frame(height: 300)
                .padding(.bottom, 16)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.calculate(from: listViewModel.entries)
        }
        .navigationTitle("集計")
    }
}
