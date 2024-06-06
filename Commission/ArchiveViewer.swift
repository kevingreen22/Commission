//
//  NewArchiveViewer.swift
//  Commission
//
//  Created by Kevin Green on 4/29/21.
//

import SwiftUI

struct ArchiveViewer: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    @State var shouldShowAlert = false
    
    var body: some View {
        ZStack {
            BackgroundImage()
            
            VStack {
                TitleView(account: account)
                CardsLayoutView(account: account, shouldShowAlert: $shouldShowAlert)
            }
            
            CloseButtonView()
            
        }
        .onChange(of: scenePhase, perform: { value in
            switch value {
            case .background, .inactive:
                presentationMode.wrappedValue.dismiss()
            case .active:
                break
            @unknown default:
                break
            }
        })
    }
}


struct CardsLayoutView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    @Binding var shouldShowAlert: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            ForEach(account.archivesArray) { archive in
                CardView(account: account, shouldShowAlert: $shouldShowAlert, archive: archive)
                    .environment(\.managedObjectContext, moc)
                    .environmentObject(vm)
            }
        }.modifier(SnapingScroll(items: account.archivesArray.count, itemWidth: 280, itemSpacing: 30))
    }
}


struct CardView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    @Binding var shouldShowAlert: Bool
    var archive: Archives
    var cardWidth: CGFloat = 280
    var cardHeight: CGFloat = 500
    

    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(ColorManager.secondaryGradient)
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Text(archive.dateRange.kgDateIntervalFormatter)
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                        Button(action: {
                            shouldShowAlert.toggle()
//                            vm.alertItem = AlertItem(
//                                title: Text("Delete Archive?"),
//                                message: Text("Are you sure you want to delete this Archive?"),
//                                dismissButton: .cancel(Text("Cancel")),
//                                secondaryButton: .destructive(Text("Delete"), action: {
//                                    Haptics.success()
//                                    PersistenceController.shared.delete(archive, from: account)
//                                    presentationMode.wrappedValue.dismiss()
//                                })
//                            )
                        }, label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        })
                        
                        .alert(isPresented: $shouldShowAlert) {
                            Alert(title: Text("Delete Archive?"), message: Text("Are you sure you want to delete this Archive?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Delete"), action: {
                                Haptics.success()
                                PersistenceController.shared.delete(archive, from: account)
                                presentationMode.wrappedValue.dismiss()
                            }))
                        }
//                        .alert(item: $vm.alertItem, content: { alertItem in
//                            if let secondaryButton = alertItem.secondaryButton {
//                                return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
//                            } else {
//                                return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
//                            }
//                        }) // end alert
                    }
                   
                    Text(archive.commissionMadeInCurrency)
                        .foregroundColor(ColorManager.mainDark)

                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: 350))]) {
                            ForEach(archive.serviceArray) { archive in
                                CardCell(archive: archive)
                            }
                        }
                    }.cornerRadius(10)
                }
                .padding([.top, .leading, .trailing])
                .frame(width: cardWidth, height: cardHeight - 10)
            )
            .frame(width: cardWidth, height: cardHeight, alignment: .center)
    }
}


struct CardCell: View {
    @Environment(\.managedObjectContext) var moc
    var archive: ServicePerformed

    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .fill(ColorManager.secondDark)
            .frame(width: 230, height: 65, alignment: .center)
            .overlay(
                VStack {
                    HStack {
                        Text(archive.name)
                            .font(.body)
                            .foregroundColor(.white)
                        Spacer()
                        Text(archive.date.kgDateFormatter(year: false, time: true))
                            .font(.caption2)
                            .foregroundColor(Color.white)
                    }.padding(.horizontal)
                    
                    HStack {
                        Text(archive.amountAsCurrency)
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Text(archive.commissionAsPercent)
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Text("$\(String(format: "%.2f", archive.amount * archive.percent.asDecimalFromContext()))")
                            .font(.caption)
                            .foregroundColor(.white)
                    }.padding(.horizontal)
                }
            )
    }
}


struct TitleView: View {
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var account: Account
    
    var body: some View {
        Text(account.archivesArray.count >= 1 ? "Archives" : "No Archives")
            .font(.largeTitle).bold()
            .foregroundColor(.white)
    }
}


struct CloseButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    print("Archive Dismissed")
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(Color.white)
                })
            }
            Spacer()
        }
        .frame(width: screenWidth, height: screenHeight)
        .padding(.top, 75)
        .padding(.trailing, 20)
    }
}


struct BackgroundImage: View {
    var body: some View {
        Image("worm_hole_2")
            .resizable()
            .ignoresSafeArea()
            .scaledToFit()
            .padding(-50)
    }
}




// MARK: Previews

struct AllViews_Preview: PreviewProvider {
    static var previews: some View {
        let vc = PersistenceController.preview.container.viewContext
        let account = vc.registeredObjects.first(where: { $0 is Account }) as! Account
//        let archive = account.archives?.allObjects[0] as! ServicePerformed
        
//        NewArchiveViewer(account: account)
//            .environment(\.managedObjectContext, vc)
        
//        Card(archive: account.archivesArray.first!)
//            .environment(\.managedObjectContext, vc)
        
//        CardCell(archive: archive)
//            .environment(\.managedObjectContext, vc)
        
        CloseButtonView()
        
        BackgroundImage()
        
        TitleView(account: account)
    }
}
