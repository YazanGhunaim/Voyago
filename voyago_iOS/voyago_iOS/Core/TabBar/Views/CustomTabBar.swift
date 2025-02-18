//
//  CustomTabBar.swift
//  voyago_iOS
//
//  Created by Yazan Ghunaim on 2/17/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedItem: Int
    @Namespace private var animation
    @State private var showSheet: Bool = false

    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 70)
                .foregroundStyle(Color(.secondarySystemBackground).opacity(0.9))
                .shadow(color: .secondary, radius: 2)

            HStack {
                ForEach(TabBarItemsViewModel.allCases, id: \.rawValue) { item in
                    Button {
                        if item.rawValue == 1 {
                            showSheet.toggle()
                        } else {
                            withAnimation(.easeInOut) {
                                selectedItem = item.rawValue
                            }
                        }
                    } label: {
                        VStack(spacing: 3) {
                            //                            Spacer()

                            Image(systemName: item.iconName)
                                .font(.system(size: 25))

                            //                            Text(item.name)
                            //                                .font(.caption)

                            if item.rawValue == selectedItem {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundStyle(.clear)
                                    .offset(y: 8)
                                    .matchedGeometryEffect(id: "selectedItemID", in: animation)
                            } else {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundStyle(.clear)
                                    .offset(y: 8)
                            }
                        }
                        .foregroundStyle(item.rawValue == selectedItem ? .indigo : .gray)
                    }
                }
            }
            .frame(height: 70)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
        .sheet(isPresented: $showSheet) {
            VisualizeTravelBoardView()
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    CustomTabBar(selectedItem: .constant(0))
}
