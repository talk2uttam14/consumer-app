import SwiftUI

struct LandingView: View {
  @State private var viewModel = LandingViewModel()
  @Environment(AppRouter.self) private var router

  var body: some View {
    VStack(spacing: SpacingConstants.xl) {
      Spacer()

      Image(ImageConstants.launchLogo)
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 220)
        
    Spacer()

      HStack(spacing: SpacingConstants.xs) {
        Text("Welcome to")
          .font(FontConstants.size20(.regular))
          .foregroundStyle(ColorConstants.secondary)
        Text("BlueMarble Retail")
          .font(FontConstants.size24(.bold))
          .foregroundStyle(ColorConstants.secondary)
      }


      if !viewModel.tenants.isEmpty {
        tenantList
      }

      PrimaryButton(
        title: "Log in",
        isLoading: viewModel.isLoading,
        variant: .secondary,
        action: {
//          viewModel.handleLoginTapped {
            router.push(.login(.mobileAndPin))
//          }
        }
      )
      .padding(.horizontal, SpacingConstants.xl)
      .padding(.bottom, SpacingConstants.xl)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ColorConstants.surfacePrimary.ignoresSafeArea())
    .task {
//      await viewModel.loadTenantParameters()
    }
    .errorAlert(error: $viewModel.error) {
      Task { await viewModel.loadTenantParameters() }
    }
  }

  private var tenantList: some View {
    VStack(alignment: .leading, spacing: SpacingConstants.sm) {
      Text("Select tenant")
        .font(FontConstants.size14(.semiBold))
        .foregroundStyle(ColorConstants.textSecondary)

      ForEach(viewModel.tenants) { tenant in
        Button {
          viewModel.selectTenant(tenant)
        } label: {
          HStack {
            Text(tenant.description ?? tenant.tenantId ?? "Tenant")
              .font(FontConstants.size14(.regular))
              .foregroundStyle(ColorConstants.textPrimary)
            Spacer()
            if viewModel.selectedTenant?.id == tenant.id {
              Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(ColorConstants.primary)
            }
          }
          .padding(SpacingConstants.md)
          .background(ColorConstants.surfaceSecondary)
          .clipShape(RoundedRectangle(cornerRadius: RadiusConstants.sm, style: .continuous))
        }
        .buttonStyle(.plain)
      }
    }
    .padding(.horizontal, SpacingConstants.xl)
  }
}

#Preview {
  LandingView()
    .environment(AppRouter.shared)
}
