import SwiftUI

struct HomeView: View {
  @Bindable var viewModel: HomeViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: SpacingConstants.lg) {
      Text("Home")
        .font(FontConstants.size24(.bold))
        .foregroundStyle(ColorConstants.textPrimary)

      if let language = viewModel.language, let items = language.data, !items.isEmpty {
        ForEach(items) { item in
          VStack(alignment: .leading, spacing: SpacingConstants.xs) {
            Text(item.ques)
              .font(FontConstants.size16(.semiBold))
            Text(item.ans)
              .font(FontConstants.size14(.regular))
              .foregroundStyle(ColorConstants.textSecondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(SpacingConstants.lg)
          .background(ColorConstants.surfaceSecondary)
          .clipShape(RoundedRectangle(cornerRadius: RadiusConstants.sm, style: .continuous))
        }
      } else {
        Text("No content loaded yet.")
          .font(FontConstants.size14(.regular))
          .foregroundStyle(ColorConstants.textSecondary)
      }

      PrimaryButton(title: "Refresh", isLoading: viewModel.isLoading) {
        Task { await viewModel.loadLanguages() }
      }

      Spacer()
    }
    .padding(SpacingConstants.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(ColorConstants.backgroundPrimary.ignoresSafeArea())
    .task {
      await viewModel.loadLanguages()
    }
    
  }
}
