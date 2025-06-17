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
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                Text("カテゴリ別支出")
                    .font(.headline)
                    .padding()

                if viewModel.categorySummaries.isEmpty {
                    VStack {
                        ZStack {
                            Circle()
                                .trim(from: 0, to: 1)
                                .stroke(style: StrokeStyle(lineWidth: 16, dash: [4]))
                                .foregroundColor(.gray.opacity(0.2))
                                .frame(height: 300)
                                .padding()

                            Text("データがありません")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        VStack(spacing: 6) {
                            ForEach(0..<3) { _ in
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 12, height: 12)
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 14)
                                        .cornerRadius(4)
                                    Spacer()
                                }
                                .redacted(reason: .placeholder)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    VStack {
                        Chart(viewModel.categorySummaries.sorted(by: { $0.amount > $1.amount })) { item in
                            SectorMark(
                                angle: .value("Amount", item.amount),
                                innerRadius: .ratio(0.5),
                                angularInset: 1.5
                            )
                            .foregroundStyle(Color.hex(item.colorHex))
                        }
                        .frame(height: 300)
                        .padding()
                        .rotationEffect(.degrees(0))
                        
                        VStack(alignment: .leading, spacing: 6) {
                           ForEach(viewModel.categorySummaries.sorted(by: { $0.amount > $1.amount })) { item in
                               HStack(spacing: 8) {
                                   Circle()
                                       .fill(Color.hex(item.colorHex))
                                       .frame(width: 12, height: 12)
                                   Text(item.categoryName)
                                       .font(.subheadline)
                                   Spacer()
                                   Text(FormatterUtils.formattedAmountWithSymbol(item.amount))
                                       .font(.subheadline)
                                       .foregroundColor(.red)
                               }
                           }
                       }
                       .padding(.horizontal)
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

