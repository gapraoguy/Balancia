import SwiftUI
import Charts

struct SummaryView: View {
    @EnvironmentObject var listViewModel: EntryListViewModel
    @StateObject private var viewModel = SummaryViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                MonthSelectorView(
                    dateText: viewModel.formattedMonth,
                    onPrevious: {
                        viewModel.moveMonth(by: -1)
                        viewModel.calculate(from: listViewModel.entries)
                    },
                    onNext: {
                        viewModel.moveMonth(by: 1)
                        viewModel.calculate(from: listViewModel.entries)
                    }
                )

                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("収入合計")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(viewModel.formattedTotalIncome)
                                .font(.title3)
                                .foregroundColor(.green)
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("支出合計")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(viewModel.formattedTotalExpense)
                                .font(.title3)
                                .foregroundColor(.red)
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("差額")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(viewModel.formattedNetBalance)
                                .font(.title3)
                                .foregroundColor(
                                    viewModel.netBalance > 0 ? .green :
                                    viewModel.netBalance < 0 ? .red : .gray
                                )
                        }
                    }
                    .padding()
                }

                if !viewModel.categorySummaries.isEmpty {
                    VStack {
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
                        .padding()
                    }
                    
                }

                Spacer()
            }
            .onAppear {
                viewModel.calculate(from: listViewModel.entries)
            }
        }
    }
}

