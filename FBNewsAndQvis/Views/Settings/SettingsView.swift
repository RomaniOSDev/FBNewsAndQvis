import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showResults = false
    @State private var showInfo: Bool = false
    
    var body: some View {
        ZStack{
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            VStack{
                //MARK: - Result button
                Button {
                    showResults.toggle()
                } label: {
                    Image(.resultButton)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                }
                //MARK: - Privacy button
                Button {
                    if let url = URL(string: "https://www.termsfeed.com/live/679dabb9-5e1f-44e3-97b4-4ea39cd15ae2") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Image(.privacy)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                }
                //MARK: - Info button
                Button {
                    showInfo.toggle()
                } label: {
                    Image(.infoButton)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                }
                //MARK: - rateUs button
                Button {
                    SKStoreReviewController.requestReview()
                } label: {
                    Image(.rateUs)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                }

            }
        }
        .fullScreenCover(isPresented: $showInfo, content: {
            InfoView()
        })
        .fullScreenCover(isPresented: $showResults) {
            QuizResultsSheet()
        }
    }
}

#Preview {
    SettingsView()
}
