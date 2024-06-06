//
//  PerformedList.swift
//  Comish
//
//  Created by Kevin Green on 10/3/20.
//

import SwiftUI
import Combine
import CoreData

struct PerformedList: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    
    @State private var totalCommish: Float = 0.0
    @State private var progress: Float = 0.0
    @State private var totalWithCommish: Float = 0.0
    @State private var difference: Float = 0.0
    @State private var totalCounter: Float = 0.0
    @State private var differenceCounter: Float = 0.0
  
    var columns = [ GridItem(.flexible(minimum: 100, maximum: .infinity)) ]

    
    var body: some View {
        ZStack {
            ColorManager.mainBackgroundGradient.ignoresSafeArea()
            
            VStack {
                TotalComHeader(totalCommissionAmount: $totalCommish, difference: $difference, progress: $progress, totalCounter: $totalCounter, differenceCounter: $differenceCounter)
                    .padding(.top)
                
                SegmentedFilter(account: account)
                    .onChange(of: vm.filterType, perform: { type in
                        prepareProgressBars(for: type, with: account)
                        print("segmentFilter changed")
                    })
                    .onAppear {
                        prepareProgressBars(for: .all, with: account)
                        print("segmentFilter appeared")
                    }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(vm.servicesArray) { servicePerformed in
                            NavigationLink(destination: EditServicePerformedInfo(servicePerformed: servicePerformed, dateInterval: account.servicePerformedDateRange),
                                           label: {
                                            PerformedCell(servicePerformed: servicePerformed)
                                                .transition(AnyTransition.scale)
                                           })
                                
                            
                            .contextMenu {
                                Button {
                                    vm.alertItem = AlertItem(
                                        title: Text("Delete?"),
                                        message: Text("Are you sure you want to delete this Performed Service?"),
                                        dismissButton: .cancel(Text("Cancel")),
                                        secondaryButton: .destructive(Text("Delete"), action: {
                                            withAnimation {
                                                vm.delete(servicePerformed: servicePerformed)
                                            }
                                        }))
                                } label: {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                            
                        } // End ForEach
                    } // end LazyVGrid
                } // End ScrollView
                
                .padding(.top)
                                
                .navigationBarTitle("Services Performed", displayMode: .inline)

                .navigationBarItems(trailing: Button(action: {
                    vm.alertItem = AlertItem(title: Text("Archive?"),
                                             message: Text("Are you sure you want to archive? You wont be able to edit your services after archiving. This will reset all current services performed."),
                                             dismissButton: .cancel(Text("No")),
                                             secondaryButton: .destructive(Text("Archive")) {
                                                vm.createArchive(for: account)
                                                presentationMode.wrappedValue.dismiss()
                                             }
                    )
                }, label: {
                    Image(systemName: "plus.rectangle.on.folder")
                        .foregroundColor(.white)
                }).disabled(account.serviceArray.count == 0 ? true : false))
                
                .alert(item: $vm.alertItem) { alertItem in
                    if let secondaryButton = alertItem.secondaryButton {
                        return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
                    } else {
                        return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                    }
                }
                
                Spacer()
                
            } // End VStack
        } // End ZStack
    } // End Body
    
    fileprivate func prepareProgressBars(for type: FilterType, with account: Account) {
        progress = 0.0
        totalCounter = 0.0
        differenceCounter = 0.0
        totalCommish = 0.0
        totalWithCommish = 0.0
        
        vm.dateToShow = account.servicePerformedDateRange.end
        vm.servicesArray = account.serviceArray
        
        switch type {
        case .all:
            totalCommish = account.totalComAmountWithTip
            difference = abs(account.totalAmountsFromServicePerfArray - totalCommish)
        
        case .date:
            for servicePerf in vm.servicesArray {
                totalCommish += servicePerf.isTip ? servicePerf.amount : servicePerf.commissionAmount
                totalWithCommish += servicePerf.amount
            }
            difference = abs(totalWithCommish - totalCommish)
        }
    }
    
} // End Struct


struct TotalComHeader: View {
    @Binding var totalCommissionAmount: Float
    @Binding var difference: Float
    @Binding var progress: Float
    @Binding var totalCounter: Float
    @Binding var differenceCounter: Float
        
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let labelTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("$\(String(format: "%.2f", totalCounter))")
                    .foregroundColor(.green)
                    .font(.title2)
                    .bold()
                    .padding(.leading)
                    
                    // animates the total commission text label
                    .onReceive(labelTimer) { _ in
                        if totalCounter < totalCommissionAmount {
                            totalCounter += (totalCommissionAmount * 0.01)
                        } else {
                            totalCounter = totalCommissionAmount
                            self.timer.upstream.connect().cancel()
                        }
                    }
                
                Spacer()
                
                Text("$-\(String(format: "%.2f", differenceCounter))")
                    .foregroundColor(.red)
                    .font(.title3)
                    .bold()
                    .padding(.trailing)
                    
                    // animates the percentage text label
                    .onReceive(labelTimer) { _ in
                        if differenceCounter < difference {
                            differenceCounter += (difference * 0.01)
                        } else {
                            differenceCounter = difference
                            self.timer.upstream.connect().cancel()
                        }
                    }
                    
            } // End name amounts and date labels
            
            ZStack(alignment: .leading) {
                ProgressView(value: progress)
                    .progressViewStyle(KGDualProgressBarStyle(difference: $difference, height: 30))
            }
            .frame(height: 30)
            .padding(.horizontal)
        }
        
        //  animates the progress bars
        .onReceive(timer) { _ in
            print(progress.roundTo(decimal: 2))
            if progress.roundTo(decimal: 2) < 0.9 {
                progress += 0.1
            } else {
                progress = 1.0
                self.timer.upstream.connect().cancel()
            }
        }
    }
}


struct PerformedCell: View {
    @State var servicePerformed: ServicePerformed
    @State private var progress: Float = 0.0
    @State private var totalCommish: Float = 0.0
    @State private var myCut: Float = 0.0
    @State private var difference: Float = 0.0
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(ColorManager.secondaryGradient)
            .frame(height: 100, alignment: .center)
            .modifier(Shadow())
            .overlay(
                VStack {
                    HStack {
                        Text("\(servicePerformed.name)")
                            .foregroundColor(.black)
                            .bold()
                            .padding(.horizontal)
                        Spacer()
                        Text(servicePerformed.date.kgDateFormatter())
                            .foregroundColor(ColorManager.mainDark)
                        Image(systemName: "chevron.right")
                            .foregroundColor(ColorManager.mainDark)
                            .padding(.trailing)
                    }
                    .padding(.top, 4)
                    
                    HStack {
                        Text(servicePerformed.amountAsCurrency)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Text(servicePerformed.commissionAsPercent)
                            .foregroundColor(.red)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Text(servicePerformed.date.elapsedTimeStamp)
                            .foregroundColor(ColorManager.mainDark)
                            .padding(.trailing)
                    }
                    
                    // progress bars
                    HStack {
                        VStack {
                            ZStack {
                                ZStack(alignment: .leading) {
                                    ProgressView(value: progress)
                                        .progressViewStyle(KGDualProgressBarStyle(difference: $servicePerformed.percent, height: 30))
                                }
                                .padding(.horizontal)
                                
                                ZStack {
                                    HStack {
                                        Text("$\(String(format: "%.2f", servicePerformed.commissionAmount))")
                                            .foregroundColor(.black)
                                            .bold()
                                            .font(.title3)
                                            .padding(.leading, 25)
                                            .offset(y: -5)
                                        Spacer()
                                        Text("$-\(String(format: "%.2f", difference))")
                                            .foregroundColor(.black)
                                            .padding(.trailing, 25)
                                            .offset(y: -5)
                                    }
                                }
                            }
                        }
                    }
                }
            )
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(ColorManager.mainDark, lineWidth: 2))
            .padding(.horizontal)
        
            // animates the progress bars
            .onReceive(timer) { _ in
                if progress.roundTo(decimal: 2) < 0.9 {
                    progress += 0.1
                } else {
                    progress = 1.0
                    self.timer.upstream.connect().cancel()
                }
            }
            
            .onAppear {
                prepareForAnimations()
            }
    }
    
    fileprivate func prepareForAnimations() {
        difference = abs(servicePerformed.commissionAmount - servicePerformed.amount)
    }
}




// MARK: Previews

struct PerformedList_Previews: PreviewProvider {
    static var previews: some View {
        let vc = PersistenceController.preview.container.viewContext
        let account = vc.registeredObjects.first(where: { $0 is Account }) as! Account
        
        return PerformedList(account: account)
            .environmentObject(ViewModel())
            .environment(\.managedObjectContext, vc)
    }
}


struct PerformedCell_Previews: PreviewProvider {
    static var previews: some View {
        let vc = PersistenceController.preview.container.viewContext
        let account = vc.registeredObjects.first(where: { $0 is Account }) as! Account
        let servicePerformed = account.servicePerformed?.first(where: { $0 is ServicePerformed }) as! ServicePerformed
        
        return PerformedCell(servicePerformed: servicePerformed)
            .environmentObject(ViewModel())
            .environment(\.managedObjectContext, vc)
    }
}
