import SwiftUI

struct PrimaryTextFieldShowcaseView: View {
  @State private var form = PrimaryTextFieldForm()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingConstants.sm) {
                PrimaryTextField(
                    key: "tenantId",
                    form: form,
                    placeholder: "Tenant ID",
                    regex: "^[A-Za-z0-9_-]{3,30}$",
                    errorMessage: "Invalid tenant ID",
                    leftIcon: "building.2"
                )
                
                PrimaryTextField(
                    key: "mobile",
                    form: form,
                    placeholder: "Mobile",
                    regex: "^[0-9]{8}$",
                    errorMessage: "8 digits required",
                    keyboardType: .phonePad,
                    leftText: "+968"
                )
                
                PrimaryTextField(
                    key: "country",
                    form: form,
                    placeholder: "Country",
                    leftIcon: "globe",
                    rightAccessory: .dropdown(["Oman", "India", "UAE"])
                )
                
                PrimaryTextField(
                    key: "visitDate",
                    form: form,
                    placeholder: "Visit date",
                    rightAccessory: .calendar()
                )
                
                PrimaryTextField(
                    key: "plan",
                    form: form,
                    placeholder: "Plan",
                    rightAccessory: .bottomSheet(title: "Plans", options: ["Basic", "Premium"])
                )
                
                PrimaryTextField(
                    key: "branch",
                    form: form,
                    placeholder: "Select branch",
                    leftIcon: "building.2",
                    rightAccessory: .icon("chevron.right") {
                        form["branch"] = "Muscat Branch"
                    },
                    onTap: { form["branch"] = "Tap — open branch picker" }
                )
                
                PrimaryTextField(
                    key: "locked",
                    form: form,
                    placeholder: "Disabled field",
                    isEnabled: false,
                    leftIcon: "lock"
                )
                
                PrimaryButton(title: "Print values") {
                    LogUtils.print("\(form.values)")
                }
            }
            .padding(SpacingConstants.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Title")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar(.visible, for: .navigationBar)
    }
}

#Preview {
  PrimaryTextFieldShowcaseView()
}
