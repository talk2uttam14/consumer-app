import SwiftUI

// MARK: -                                                                                                                                      

@Observable
final class PrimaryTextFieldForm {
  private(set) var values: [String: String] = [:]

  subscript(key: String) -> String {
    get { values[key] ?? "" }
    set { values[key] = newValue }
  }

  func binding(for key: String) -> Binding<String> {
    Binding(
      get: { self.values[key] ?? "" },
      set: { self.values[key] = $0 }
    )
  }
}

// MARK: - Right accessory

enum FieldAccessory {
  case dropdown([String])
  case calendar(format: String = "dd/MM/yyyy")
  case bottomSheet(title: String, options: [String])
  case camera(() -> String)
  case icon(String, action: () -> Void)
}

// MARK: - PrimaryTextField

struct PrimaryTextField: View {

  let key: String
  let placeholder: String
  var regex: String?
  var errorMessage: String?
  var isSecure = false
  var isEnabled = true
  var keyboardType: UIKeyboardType = .default
  var textInputAutocapitalization: TextInputAutocapitalization = .sentences
  var autocorrectionDisabled = false
  var leftIcon: String?
  var leftIconColor: Color = ColorConstants.textSecondary
  var leftText: String?
  var rightAccessory: FieldAccessory?
  var onFocusChange: ((Bool) -> Void)?
  var onTap: (() -> Void)?

  @Binding private var text: String

  @FocusState private var isFocused: Bool
  @State private var touched = false
  @State private var showPickerSheet = false
  @State private var pickerDate = Date()

  private let fieldHeight: CGFloat = 56
  private let errorHeight: CGFloat = 12

  init(
    key: String,
    form: PrimaryTextFieldForm,
    placeholder: String,
    regex: String? = nil,
    errorMessage: String? = nil,
    isSecure: Bool = false,
    isEnabled: Bool = true,
    keyboardType: UIKeyboardType = .default,
    textInputAutocapitalization: TextInputAutocapitalization = .sentences,
    autocorrectionDisabled: Bool = false,
    leftIcon: String? = nil,
    leftIconColor: Color = ColorConstants.textSecondary,
    leftText: String? = nil,
    rightAccessory: FieldAccessory? = nil,
    onFocusChange: ((Bool) -> Void)? = nil,
    onTap: (() -> Void)? = nil
  ) {
    self.key = key
    self.placeholder = placeholder
    self.regex = regex
    self.errorMessage = errorMessage
    self.isSecure = isSecure
    self.isEnabled = isEnabled
    self.keyboardType = keyboardType
    self.textInputAutocapitalization = textInputAutocapitalization
    self.autocorrectionDisabled = autocorrectionDisabled
    self.leftIcon = leftIcon
    self.leftIconColor = leftIconColor
    self.leftText = leftText
    self.rightAccessory = rightAccessory
    self.onFocusChange = onFocusChange
    self.onTap = onTap
    _text = form.binding(for: key)
  }

  private var isEditable: Bool {
    isEnabled && onTap == nil
  }

  private var labelUp: Bool { (isFocused && isEditable) || !text.isEmpty }

  private var errorText: String? {
    guard touched, !text.isEmpty,
          let regex, let errorMessage else { return nil }
    let valid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    return valid ? nil : errorMessage
  }

  private var hasError: Bool { errorText != nil }

  private var borderColor: Color {
    if hasError { return ColorConstants.error }
    if isFocused && isEditable { return ColorConstants.primary }
    return ColorConstants.textSecondary.opacity(0.35)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      fieldBox
      errorLine
    }
    .onAppear {
      if !text.isEmpty { touched = true }
    }
    .onChange(of: text) { _, _ in touched = true }
    .sheet(isPresented: $showPickerSheet) { pickerSheet }
  }

  private var fieldBox: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: RadiusConstants.md, style: .continuous)
        .fill(ColorConstants.secondary)
        .overlay(
          RoundedRectangle(cornerRadius: RadiusConstants.md, style: .continuous)
            .stroke(borderColor, lineWidth: 1)
        )
        .frame(height: fieldHeight)

      HStack(spacing: SpacingConstants.sm) {
        leftView
        VStack(alignment: .leading, spacing: 0) {
          if labelUp {
            Text(placeholder)
              .font(FontConstants.size12(.medium))
              .foregroundStyle(labelColor)
          }
          textInput
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        rightView
      }
      .padding(.horizontal, SpacingConstants.md)
      .padding(.vertical, labelUp ? SpacingConstants.xs : 0)

      if !labelUp {
        HStack(spacing: SpacingConstants.sm) {
          if leftIcon != nil || leftText != nil {
            Color.clear.frame(width: 24)
          }
          Text(placeholder)
            .font(FontConstants.size16(.regular))
            .foregroundStyle(ColorConstants.textSecondary.opacity(0.7))
            .allowsHitTesting(false)
        }
        .padding(.horizontal, SpacingConstants.md)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture { handleTap() }
    .onChange(of: isFocused) { _, focused in
      guard isEditable else { return }
      onFocusChange?(focused)
      if !focused { touched = true }
    }
  }

  private func handleTap() {
    guard isEnabled else { return }
    if let onTap {
      onTap()
      return
    }
    if isEditable {
      isFocused = true
    }
  }

  @ViewBuilder
  private var leftView: some View {
    if let leftIcon {
      Image(systemName: leftIcon)
        .font(.system(size: 18, weight: .medium))
        .foregroundStyle(leftIconColor)
        .frame(width: 24)
    } else if let leftText {
      Text(leftText)
        .font(FontConstants.size14(.medium))
        .foregroundStyle(ColorConstants.textSecondary)
    }
  }

  @ViewBuilder
  private var textInput: some View {
    if isEditable {
      Group {
        if isSecure {
          SecureField("", text: $text)
        } else {
          TextField("", text: $text)
        }
      }
      .font(FontConstants.size16(.regular))
      .foregroundStyle(ColorConstants.textPrimary)
      .keyboardType(keyboardType)
      .textInputAutocapitalization(textInputAutocapitalization)
      .autocorrectionDisabled(autocorrectionDisabled)
      .focused($isFocused)
      .submitLabel(.done)
      .onSubmit {
        touched = true
        isFocused = false
      }
    } else {
      Text(text.isEmpty ? " " : text)
        .font(FontConstants.size16(.regular))
        .foregroundStyle(ColorConstants.textPrimary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .allowsHitTesting(false)
    }
  }

  @ViewBuilder
  private var rightView: some View {
    switch rightAccessory {
    case .none:
      EmptyView()
    case .dropdown(let options):
      Menu {
        ForEach(options, id: \.self) { option in
          Button(option) {
            text = option
            touched = true
          }
        }
      } label: {
        fieldIcon("chevron.down")
      }
      .disabled(!isEnabled)
    case .calendar:
      Button { showPickerSheet = true } label: { fieldIcon("calendar") }
        .disabled(!isEnabled)
    case .bottomSheet:
      Button { showPickerSheet = true } label: { fieldIcon("list.bullet") }
        .disabled(!isEnabled)
    case .camera(let onCapture):
      Button {
        text = onCapture()
        touched = true
      } label: {
        fieldIcon("camera.fill")
      }
      .disabled(!isEnabled)
    case .icon(let name, let action):
      Button(action: action) { fieldIcon(name) }
        .disabled(!isEnabled)
    }
  }

  private func fieldIcon(_ name: String) -> some View {
    Image(systemName: name)
      .font(.system(size: 18, weight: .medium))
      .foregroundStyle(ColorConstants.textSecondary)
      .frame(width: 28, height: 28)
  }

  private var errorLine: some View {
    Text(errorText ?? " ")
      .font(FontConstants.size12(.regular))
      .foregroundStyle(ColorConstants.error)
      .lineLimit(1)
      .truncationMode(.tail)
      .frame(maxWidth: .infinity, alignment: .leading)
      .frame(height: errorHeight)
      .padding(.leading, SpacingConstants.xs)
      .opacity(hasError ? 1 : 0)
      .accessibilityHidden(!hasError)
  }

  private var labelColor: Color {
    if hasError { return ColorConstants.error }
    if isFocused && isEditable { return ColorConstants.primary }
    return ColorConstants.textSecondary
  }

  @ViewBuilder
  private var pickerSheet: some View {
    switch rightAccessory {
    case .calendar(let format):
      NavigationStack {
        DatePicker("", selection: $pickerDate, displayedComponents: .date)
          .datePickerStyle(.graphical)
          .padding()
          .navigationTitle("Select date")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") { showPickerSheet = false }
            }
            ToolbarItem(placement: .confirmationAction) {
              Button("Done") {
                let formatter = DateFormatter()
                formatter.dateFormat = format
                text = formatter.string(from: pickerDate)
                touched = true
                showPickerSheet = false
              }
            }
          }
      }
      .presentationDetents([.medium])

    case .bottomSheet(let title, let options):
      NavigationStack {
        List(options, id: \.self) { option in
          Button(option) {
            text = option
            touched = true
            showPickerSheet = false
          }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { showPickerSheet = false }
          }
        }
      }
      .presentationDetents([.medium])

    default:
      EmptyView()
    }
  }
}
