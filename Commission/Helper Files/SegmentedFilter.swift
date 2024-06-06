//
//  SegmentedFilter.swift
//  Comish
//
//  Created by Kevin Green on 12/3/20.
//

import CoreData
import SwiftUI

enum FilterType: String {
    case all = "all"
    case date = "date"
}

struct SegmentedFilter: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    @State private var isShowingDate = false
    
    var body: some View {
        VStack {
            Picker("", selection: $vm.segmentSelection) {
                Text("All").tag(1)
                Text("Date").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.horizontal, .top])
            
            .onChange(of: vm.segmentSelection) { _ in
                withAnimation(.easeOut) {
                    switch vm.segmentSelection {
                    case 1:
                        vm.filterType = .all
                        vm.dateToShow = account.servicePerformedDateRange.end
                        isShowingDate = false
                    case 2:
                        vm.filterType = .date
                        vm.dateToShow = vm.dateToShow.addToDate(by: 0)
                        isShowingDate = true
                    default:
                        break
                    }
                }
            }
            
            
            if isShowingDate {
                HStack {
                    Spacer()
                    Button(action: {
                        // change filter date backward
                        vm.dateToShow = vm.dateToShow.addToDate(by: -1)
                        vm.servicesArray = (account.serviceArray.filter({
                            $0.date.kgDateFormatter() == vm.dateToShow.kgDateFormatter()
                        }))
                    }, label: {
                        Image(systemName: "chevron.left.circle.fill").foregroundColor(.white)
                    }).disabled(vm.dateToShow.kgDateFormatter() == account.servicePerformedDateRange.start.kgDateFormatter() ? true : false)
                    
                    Spacer()
                    Text(vm.dateToShow.kgDateFormatter()).foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        // change filter date forward
                        vm.dateToShow = vm.dateToShow.addToDate(by: 1)
                        vm.servicesArray = account.serviceArray.filter({
                            $0.date.kgDateFormatter() == vm.dateToShow.kgDateFormatter()
                        })
                    }, label: {
                        Image(systemName: "chevron.right.circle.fill").foregroundColor(.white)
                    }).disabled(vm.dateToShow.kgDateFormatter() == account.servicePerformedDateRange.end.kgDateFormatter() ? true : false)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                
            } // End isShowingDate
        } // End VStack
    } // End Body
} // End SegmentFilter Struct



struct SegmentedFilter_Previews: PreviewProvider {
    static var previews: some View {
        let vc = PersistenceController.preview.container.viewContext
        let account = vc.registeredObjects.first(where: { $0 is Account }) as! Account
        
        SegmentedFilter(account: account)
            .environment(\.managedObjectContext, vc)
    }
}
