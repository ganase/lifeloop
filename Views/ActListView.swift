import SwiftUI

struct ActListView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isAddPresented = false

    var body: some View {
        List {
            if appState.actTemplates.isEmpty {
                ContentUnavailableView(
                    "Actがありません",
                    systemImage: "list.bullet.rectangle",
                    description: Text("右上の追加ボタンからActを作成できます。")
                )
            } else {
                Section {
                    ForEach(appState.actTemplates) { act in
                        NavigationLink {
                            ActEditorView(originalTitle: act.title)
                        } label: {
                            ActRowView(act: act)
                        }
                    }
                } footer: {
                    Text("Actは行動だけを管理します。Placeへの到着時に、PlaceとActが組み合わさってStepsになります。")
                }
            }
        }
        .themedScreenBackground()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isAddPresented = true
                } label: {
                    Label("Actを追加", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddPresented) {
            NavigationStack {
                AddActView()
                    .environmentObject(appState)
            }
        }
    }
}

private struct ActRowView: View {
    let act: ActTemplate

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "list.bullet.rectangle")
                .foregroundStyle(.blue)
                .frame(width: 24)

            Text(act.title)
                .font(.body)
                .lineLimit(3)

            Spacer()

            if act.usageCount > 1 {
                Text("\(act.usageCount)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.10))
                    .clipShape(Capsule())
            }

            DisclosureChevron()
        }
        .padding(.vertical, 4)
    }
}

private struct AddActView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    private var normalizedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        Form {
            Section {
                EditorContextHeader(
                    title: "Actを追加",
                    subtitle: normalizedTitle.isEmpty ? "新しい行動" : normalizedTitle,
                    detail: "Placeとは切り離して、行動の名前だけを作成します。StepでPlaceと組み合わせます。",
                    systemImage: "list.bullet.rectangle",
                    badges: [
                        EditorContextBadge(title: "Act", systemImage: "list.bullet.rectangle")
                    ]
                )
            }

            Section("Act") {
                TextField("例: 鍵を確認する", text: $title, axis: .vertical)
                    .lineLimit(1...3)
            }

            Section {
                EditorActionBar(
                    canSave: !normalizedTitle.isEmpty,
                    onSave: {
                        appState.addAct(title: normalizedTitle)
                        dismiss()
                    },
                    onCancel: {
                        dismiss()
                    }
                )
            }
        }
        .themedScreenBackground()
        .navigationTitle("Actを追加")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ActEditorView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var draftTitle: String
    @State private var isDeleteConfirmationPresented = false

    let originalTitle: String

    init(originalTitle: String) {
        self.originalTitle = originalTitle
        _draftTitle = State(initialValue: originalTitle)
    }

    private var normalizedTitle: String {
        draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        Form {
            Section {
                EditorContextHeader(
                    title: "Actを編集",
                    subtitle: normalizedTitle.isEmpty ? originalTitle : normalizedTitle,
                    detail: "行動名を変更します。このActを使っているStepにも同じ名前が反映されます。",
                    systemImage: "list.bullet.rectangle",
                    badges: [
                        EditorContextBadge(title: "Act", systemImage: "list.bullet.rectangle")
                    ]
                )
            }

            Section("Act") {
                TextField("Act", text: $draftTitle, axis: .vertical)
                    .lineLimit(1...3)
            }

            Section {
                EditorActionBar(
                    canSave: !normalizedTitle.isEmpty,
                    onSave: {
                        appState.updateAct(matching: originalTitle, to: normalizedTitle)
                        dismiss()
                    },
                    onCancel: {
                        dismiss()
                    },
                    onDelete: {
                        isDeleteConfirmationPresented = true
                    }
                )
            }
        }
        .themedScreenBackground()
        .navigationTitle("Actを編集")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Actを削除しますか？",
            isPresented: $isDeleteConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button("削除", role: .destructive) {
                appState.deleteAct(matching: originalTitle)
                dismiss()
            }

            Button("キャンセル", role: .cancel) {}
        } message: {
            Text(originalTitle)
        }
    }
}
